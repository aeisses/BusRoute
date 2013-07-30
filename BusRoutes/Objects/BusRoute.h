//
//  BusRoute.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KML/KML.h>
#import <MapKit/MapKit.h>
#import "Enums.h"

@interface BusRoute : NSObject
{
    NSString *stopDescription;
    NSInteger objectId;
    NSInteger routeNum;
    CLASS classType;
    NSString *routeTitle;
    SOURCE source;
    SACC sacc;
    NSDate *startDate;
    NSDate *revDate;
    float shapeLen;
    NSString *socrateId;
    CLLocationCoordinate2D *coordinatesArray;
}

@property (nonatomic, copy) NSString *title;
@property (readonly) NSInteger count;

- (id)initWithTitle:(NSString *)title description:(NSString*)description andGeometries:(KMLMultiGeometry*)geometries;
- (void)getCoordinates:(CLLocationCoordinate2D*)coordinates;

@end
