//
//  DrawingImageView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusRoute.h"
#import "BusStop.h"

@interface DrawingImageView : UIImageView
{
//    NSMutableArray *lines;
//    NSMutableArray *points;
    NSMutableArray *annotations;
}

@property (retain, nonatomic) BusRoute *busRoute;

- (void)addLineFrom:(BusStop*)fromBusStop To:(BusStop*)toBusStop forMapView:(MKMapView*)mapView;
- (void)addBusStop:(BusStop*)busStop;
- (void)removeBusStop:(BusStop*)busStop fromMapView:(MKMapView*)mapView;
- (void)showBusRoute:(MKMapView*)mapView;
- (void)removeAllBusRoutesFromMap:(MKMapView*)mapView;

@end

@interface DrawingImageView (PrivateMethods)
- (void)clearLine;
- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to;
@end
