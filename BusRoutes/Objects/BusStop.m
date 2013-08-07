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

- (id)initWithTitle:(NSString *)title description:(NSString*)decription andLocation:(KMLPoint*)location
{
    if (self = [super init])
    {
        _title = title;
        _coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        stopDescription = decription;
        _routes = [NSArray array];
        [self parseStopDescription];
    }
    return self;
}

- (void)addRouteNumber:(NSNumber*)route
{
    if ([_routes indexOfObject:route] == NSNotFound) {
        NSMutableArray *mRoutes = [[NSMutableArray alloc] initWithArray:_routes];
        [mRoutes addObject:route];
        [_routes release];
        _routes = [[NSArray alloc] initWithArray:mRoutes];
        [mRoutes release];
    }
}

- (void)dealloc
{
    [super dealloc];
    [_title release];
    [stopDescription release];
    [date release];
    [address release];
    [_routes release];
}

#pragma Private Methods
- (void)parseStopDescription
{
    NSMutableString *temp = [[NSMutableString alloc] initWithString:stopDescription];
    [temp replaceOccurrencesOfString:@"<ul class=\"textattributes\">" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"<li><strong><span class=\"atr-name\">" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"</span>:</strong> <span class=\"atr-value\">" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"</span></li>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    
    NSArray *splitArray = [temp componentsSeparatedByString:@"\n"];
    [temp release];
    for (NSString *element in splitArray) {
        NSString *trimedElemet = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *thisArray = [trimedElemet componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([thisArray count] == 2) {
            if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"OBJECTID"]) {
                objectId = [(NSString *)([thisArray objectAtIndex:1]) integerValue];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"FCODE"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSIN"]) {
                    _fcode = trbsin;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSAC"]) {
                    _fcode = trbsac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSTMIN"]) {
                    _fcode = trbstmin;
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
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TBRSML"]) {
                    _fcode = tbrsml;
                }
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"SOURCE"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRANSIT"]) {
                    source = transit;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"HASTUS"]) {
                    source = hastus;
                }
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"SACC"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"DV"]) {
                    sacc = DV;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"IN"]) {
                    sacc = IN;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"XY"]) {
                    sacc = XY;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"GP"]) {
                    sacc = GP;
                }
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"SDATE"]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, YYYY hh:mm:ss a"];
                date = [formatter dateFromString:(NSString*)([thisArray objectAtIndex:1])];
                [formatter release];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"GOTIME"]) {
                _goTime = [(NSString *)([thisArray objectAtIndex:1]) integerValue];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"LOCATION"]) {
                address = (NSString *)[thisArray objectAtIndex:1];
            }
        }
    }
}

@end
