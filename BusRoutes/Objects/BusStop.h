//
//  BusStop.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-23.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KML/KML.h>
#import <MapKit/MapKit.h>
#import "Enums.h"

@interface BusStop : NSObject <MKAnnotation>
{
    NSString *stopDescription;
    NSInteger objectId;
    FCODE fcode;
    SOURCE source;
    SACC sacc;
    NSDate *date;
    NSInteger gotime;
    NSString *address;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithTitle:(NSString *)title description:(NSString*)description andLocation:(KMLPoint*)location;

@end
