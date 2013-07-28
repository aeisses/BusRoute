//
//  BusRoute.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KML/KML.h>
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
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) KMLMultiGeometry *geometries;

- (id)initWithTitle:(NSString *)title description:(NSString*)decription andGeometries:(KMLMultiGeometry*)geometries;

@end
