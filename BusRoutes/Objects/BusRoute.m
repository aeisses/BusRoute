//
//  BusRoute.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "BusRoute.h"

@interface BusRoute (PrivateMethods)
- (void)parseRouteDescription;
@end;

@implementation BusRoute

- (id)initWithTitle:(NSString *)title description:(NSString*)description andGeometries:(KMLMultiGeometry*)geometries
{
    if (self = [super init])
    {
        _title = title;
        NSMutableArray *coordinatesMutable = [NSMutableArray array];
        for (int i=0; i<[geometries.geometries count]; i++) {
            if ([[geometries.geometries objectAtIndex:i] isKindOfClass:[KMLPoint class]]) {
            } else if ([[geometries.geometries objectAtIndex:i] isKindOfClass:[KMLLineString class]]) {
                [coordinatesMutable addObjectsFromArray:(NSArray *)(((KMLLineString *)[geometries.geometries objectAtIndex:i]).coordinates)];
            }
        }

        _count = [coordinatesMutable count];
        coordinatesArray = malloc(sizeof(CLLocationCoordinate2D) * _count);
        for (int i = 0; i < _count; ++i) {
            KMLCoordinate *point = (KMLCoordinate*)[coordinatesMutable objectAtIndex:i];
            coordinatesArray[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        }
        stopDescription = description;
//        NSLog(@"%@",description);
        [self parseRouteDescription];
    }
    return self;
}

- (void)getCoordinates:(CLLocationCoordinate2D*)coordinates
{
    memcpy(coordinates, coordinatesArray, _count * sizeof(CLLocationCoordinate2D));
}

- (void)dealloc
{
    [super dealloc];
    [_title release];
    free(coordinatesArray);
    [stopDescription release];
    [routeTitle release];
    [startDate release];
    [revDate release];
    [socrateId release];
}

# pragma Private Methods
- (void)parseRouteDescription
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
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"ROUTE_NUM"]) {
                routeNum = [(NSString *)([thisArray objectAtIndex:1]) integerValue];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"CLASS"]) {
                if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"WEEKDAY LIMITED"]) {
                    classType = weekday_limited;
                }
/*                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSAC"]) {
                    fcode = trbsac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSNAC"]) {
                    fcode = trbssnac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBS"]) {
                    fcode = trbs;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSHAC"]) {
                    fcode = trbsshac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSH"]) {
                    fcode = trbssh;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRPR"]) {
                    fcode = trpr;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSTMAC"]) {
                    fcode = trbstmac;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSTM"]) {
                    fcode = trbstm;
                } else if ([(NSString*)([thisArray objectAtIndex:1]) isEqualToString:@"TRBSSHIN"]) {
                    fcode = trbsshin;
                }
 */
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"TITLE"]) {
                routeTitle = (NSString *)[thisArray objectAtIndex:1];
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
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"DATE_ACT"]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, YYYY hh:mm:ss a"];
                startDate = [formatter dateFromString:(NSString*)([thisArray objectAtIndex:1])];
                [formatter release];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"DATE_REV"]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, YYYY hh:mm:ss a"];
                revDate = [formatter dateFromString:(NSString*)([thisArray objectAtIndex:1])];
                [formatter release];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"GOTIME"]) {
                shapeLen = [(NSString *)([thisArray objectAtIndex:1]) floatValue];
            } else if ([(NSString *)([thisArray objectAtIndex:0]) isEqualToString:@"LOCATION"]) {
                socrateId = (NSString *)[thisArray objectAtIndex:1];
            }
        }
    }
}

@end
