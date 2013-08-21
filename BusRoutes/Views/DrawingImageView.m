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
        points = [[NSMutableArray alloc] initWithCapacity:0];
        lines = [[NSMutableArray alloc] initWithCapacity:0];
        annotations = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [points release]; points = nil;
    [annotations release]; annotations = nil;
    [lines release]; lines = nil;
    [_busRoute release]; _busRoute = nil;
    [super dealloc];
}

- (void)clearLines
{
    [self clearLine];
    [lines release]; lines = nil;
    lines = [[NSMutableArray alloc] initWithCapacity:0];
    self.image = nil;
}

- (void)clearLine
{
    [points release]; points = nil;
    points = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)closeLine
{
//    [lines addObject:points];
//    [self clearLine];
}

- (void)addLineFrom:(BusStop*)fromBusStop To:(BusStop*)toBusStop forMapView:(MKMapView*)mapView
{
    CGPoint toPoint = [mapView convertCoordinate:toBusStop.coordinate toPointToView:self];
    CGPoint fromPoint = [mapView convertCoordinate:fromBusStop.coordinate toPointToView:self];
    if ([annotations count] == 0 && [points count] == 0) {
        [annotations addObject:fromBusStop];
        [points addObject:[NSValue valueWithCGPoint:fromPoint]];
    }
    [self drawLineFrom:fromPoint To:toPoint];
    [annotations addObject:toBusStop];
    [points addObject:[NSValue valueWithCGPoint:toPoint]];
}

- (void)addBusStop:(BusStop*)busStop
{
    [annotations addObject:busStop];
}

- (void)removeBusStop:(BusStop*)busStop fromMapView:(MKMapView*)mapView
{
    [annotations removeObject:busStop];
    CGPoint removingPoint = [mapView convertCoordinate:busStop.coordinate toPointToView:self];
    [points removeObject:[NSValue valueWithCGPoint:removingPoint]];
/*    self.image = nil;
    for (NSMutableArray *pointsArray in lines) {
        [pointsArray removeObject:[NSValue valueWithCGPoint:removingPoint]];
        CGPoint lastPoint = (CGPoint){0,0};
        for (NSValue *valuePoint in pointsArray) {
            if (lastPoint.x != 0 && lastPoint.y != 0) {
                CGPoint point = [valuePoint CGPointValue];
                [self drawLineFrom:lastPoint To:point];
            }
            lastPoint = [valuePoint CGPointValue];
        }
    }*/
    [self showBusRoute:mapView];
//    self.image = nil;
}

- (void)createBusRoute:(MKMapView*)mapView
{
    
}

- (void)showBusRoute:(MKMapView*)mapView
{
    [mapView removeOverlays:_busRoute.lines];
    if (_busRoute) [_busRoute release];
    NSMutableArray *newLines = [[NSMutableArray alloc] initWithCapacity:0];
    CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [annotations count]);
    for (int i = 0; i < [annotations count]; i++) {
        line[i] = ((BusStop*)[annotations objectAtIndex:i]).coordinate;
    }
    [newLines insertObject:[MKPolyline polylineWithCoordinates:line count:[annotations count]] atIndex:[newLines count]];
    free(line);

    _busRoute = [[BusRoute alloc] initWithLines:[NSArray arrayWithArray:newLines] andTitle:@""];
    [mapView addOverlays:_busRoute.lines];
    [newLines release];
    self.image = nil;
}

- (void)removeBusRoutes:(BusRoute*)busRoute fromMap:(MKMapView*)mapView
{
/*    for (BusRoute *busRoute in _busRoutes)
        [mapView removeOverlays:busRoute.lines];
    [_busRoutes removeObject:busRoute];
    for (BusRoute *busRoute in _busRoutes)
        [mapView addOverlays:busRoute.lines];
 */
}

- (void)removeAllBusRoutesFromMap:(MKMapView*)mapView
{
/*    for (BusRoute *busRoute in _busRoutes)
        [mapView removeOverlays:busRoute.lines];
    [_busRoutes release]; _busRoutes = nil;
    _busRoutes = [[NSMutableArray alloc] initWithCapacity:0];
 */
}

#pragma Private Methods
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
