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
#import "KeyView.h"

@interface DrawingImageView : UIImageView
{
    NSMutableArray *annotations;
    NSMutableArray *lines;
    NSMutableArray *reverse;
    KeyView *keyView;
    NSInteger activeLine;
}

@property (retain, nonatomic) BusRoute *busRoute;
@property (retain, nonatomic) NSMutableArray *created;

- (void)addLineFrom:(BusStop*)fromBusStop To:(BusStop*)toBusStop forMapView:(MKMapView*)mapView;
- (void)addBusStop:(BusStop*)busStop toMapView:(MKMapView*)mapView;
- (void)removeBusStop:(BusStop*)busStop fromMapView:(MKMapView*)mapView;
- (void)removeAllBusRoutesFromMap:(MKMapView*)mapView;
- (void)reverseRoute;
- (void)endLine:(MKMapView*)mapView;
- (void)setActiveLine:(NSString*)lineNum forMapView:(MKMapView*)mapView;
- (void)createBusRouteOnMap:(MKMapView*)mapView withName:(NSString*)name andNumber:(NSString*)number andDescription:(NSString*)description andIsReversed:(BOOL)isReversed;

@end

@interface DrawingImageView (PrivateMethods)
- (void)showBusRoute:(MKMapView*)mapView;
- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to;
@end
