//
//  DrawingImageView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "DrawingImageView.h"

@implementation DrawingImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
        annotations = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [annotations release]; annotations = nil;
    [_busRoute release]; _busRoute = nil;
    [super dealloc];
}

- (void)addLineFrom:(BusStop*)fromBusStop To:(BusStop*)toBusStop forMapView:(MKMapView*)mapView
{
    CGPoint toPoint = [mapView convertCoordinate:toBusStop.coordinate toPointToView:self];
    CGPoint fromPoint = [mapView convertCoordinate:fromBusStop.coordinate toPointToView:self];
    if ([annotations count] == 0) {
        [annotations addObject:fromBusStop];
    }
    [self drawLineFrom:fromPoint To:toPoint];
    [annotations addObject:toBusStop];
}

- (void)addBusStop:(BusStop*)busStop toMapView:(MKMapView*)mapView
{
    double distance = 0;
    int locationToAdd = 0;
    int counter = 0;
    for (BusStop *bs in annotations) {
        double deltaLong = busStop.coordinate.longitude - bs.coordinate.longitude;
        double deltaLati = busStop.coordinate.latitude - bs.coordinate.latitude;
        double newDistance = sqrt((deltaLong * deltaLong) + (deltaLati * deltaLati));
        if (distance == 0 || newDistance < distance) {
            distance = newDistance;
            locationToAdd = counter;
        }
        counter++;
    }
    [annotations insertObject:busStop atIndex:locationToAdd];
    [self showBusRoute:mapView];
}

- (void)removeBusStop:(BusStop*)busStop fromMapView:(MKMapView*)mapView
{
    [annotations removeObject:busStop];
    [self showBusRoute:mapView];
}

- (void)createBusRoute:(MKMapView*)mapView
{
    
}

- (void)removeAllBusRoutesFromMap:(MKMapView*)mapView
{
    [mapView removeOverlays:_busRoute.lines];
}

- (void)reverseRoute
{
    
}

#pragma Private Methods
- (void)showBusRoute:(MKMapView*)mapView
{
    [mapView removeOverlays:_busRoute.lines];
    if (_busRoute) [_busRoute release];
    CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [annotations count]);
    for (int i = 0; i < [annotations count]; i++) {
        line[i] = ((BusStop*)[annotations objectAtIndex:i]).coordinate;
    }
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:line count:[annotations count]];
    free(line);
    
    _busRoute = [[BusRoute alloc] initWithLine:polyLine andTitle:@""];
    [mapView addOverlays:_busRoute.lines];
    self.image = nil;
}

- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), from.x, from.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), to.x, to.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0 );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    [self setAlpha:1.0];
    UIGraphicsEndImageContext();
}

@end
