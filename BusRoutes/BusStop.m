//
//  BusStop.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-23.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "BusStop.h"

@interface BusStop (PrivateMethods)
- (void)parseStopDescription;
@end;

@implementation BusStop

- (void)parseStopDescription
{
    NSMutableString *temp = [[NSMutableString alloc] initWithString:stopDescription];
    [temp replaceOccurrencesOfString:@"<ul class=\"textattributes\">" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"<li><strong><span class=\"atr-name\">" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"</span>:</strong> <span class=\"atr-value\">" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"</span></li>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    
    NSArray *splitArray = [temp componentsSeparatedByString:@"\n"];
    for (NSString *element in splitArray) {
        NSString *trimedElemet = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *thisArray = [trimedElemet componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([thisArray count] == 2) {
            if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"OBJECTID"]) {
                _objectId = [(NSString *)([thisArray objectAtIndex:1]) integerValue];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"FCODE"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSIN"]) {
                    _fcode = trbsin;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSAC"]) {
                    _fcode = trbsac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSNAC"]) {
                    _fcode = trbssnac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBS"]) {
                    _fcode = trbs;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSHAC"]) {
                    _fcode = trbsshac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSH"]) {
                    _fcode = trbssh;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRPR"]) {
                    _fcode = trpr;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSTMAC"]) {
                    _fcode = trbstmac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSTM"]) {
                    _fcode = trbstm;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSHIN"]) {
                    _fcode = trbsshin;
                }
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"SOURCE"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRANSIT"]) {
                    _source = transit;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"HASTUS"]) {
                    _source = hastus;
                }
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"SACC"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"DV"]) {
                    _sacc = DV;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"IN"]) {
                    _sacc = IN;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"XY"]) {
                    _sacc = XY;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"GP"]) {
                    _sacc = GP;
                }
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"SDATE"]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, YYYY hh:mm:ss a"];
                _date = [formatter dateFromString:(NSString*)([thisArray objectAtIndex:1])];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"GOTIME"]) {
                _gotime = [(NSString *)([thisArray objectAtIndex:1]) integerValue];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"LOCATION"]) {
                _address = (NSString *)[thisArray objectAtIndex:1];
            }
        }
    }
}

- (id)initWithName:(NSString *)name description:(NSString*)decription andLocation:(KMLPoint*)location
{
    if (self = [super init])
    {
        _name = name;
        _location = location;
        stopDescription = decription;
        [self parseStopDescription];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_name release];
    [_location release];
    [stopDescription release];
}

@end
