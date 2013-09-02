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
        lines = [[NSMutableArray alloc] initWithCapacity:0];
        created = [[NSMutableArray alloc] initWithCapacity:0];
        keyView = [[[[NSBundle mainBundle] loadNibNamed:@"KeyView" owner:self options:nil] objectAtIndex:0] retain];
        keyView.frame = (CGRect){10,55,keyView.frame.size};
        [keyView setUpKey];
        [self addSubview:keyView];
    }
    return self;
}

- (void)dealloc
{
    [lines release]; lines = nil;
    [annotations release]; annotations = nil;
    [_busRoute release]; _busRoute = nil;
    [created release]; created = nil;
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
    for (BusStop *bs in (NSMutableArray*)[lines objectAtIndex:activeLine]) {
        double deltaLong = busStop.coordinate.longitude - bs.coordinate.longitude;
        double deltaLati = busStop.coordinate.latitude - bs.coordinate.latitude;
        double newDistance = sqrt((deltaLong * deltaLong) + (deltaLati * deltaLati));
        if (distance == 0 || newDistance < distance ) {
            distance = newDistance;
            locationToAdd = counter;
        }
        counter++;
    }
    [(NSMutableArray*)[lines objectAtIndex:activeLine] insertObject:busStop atIndex:locationToAdd];
    [self showBusRoute:mapView];
}

- (void)removeBusStop:(BusStop*)busStop fromMapView:(MKMapView*)mapView
{
    [(NSMutableArray*)[lines objectAtIndex:activeLine] removeObject:busStop];
    [self showBusRoute:mapView];
}

- (void)createBusRouteOnMap:(MKMapView*)mapView withName:(NSString*)name andNumber:(NSString*)number andDescription:(NSString*)description andIsReversed:(BOOL)isReversed
{
    NSMutableArray *brLines = [[NSMutableArray alloc] initWithCapacity:[lines count]];
    for (int j=0; j<[lines count]; j++) {
        NSArray *lineArray = [[lines objectAtIndex:j] retain];
        CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [lineArray count]);
        for (int i = 0; i < [lineArray count]; i++) {
            line[i] = ((BusStop*)[lineArray objectAtIndex:i]).coordinate;
        }
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:line count:[lineArray count]];
        polyLine.title = @"Green";
        polyLine.subtitle = [NSString stringWithFormat:@"%i",-1];
        free(line);
        [brLines addObject:polyLine];
        [lineArray release];
    }
    BusRoute *busRoute = [[BusRoute alloc] initWithLines:brLines andTitle:name andNumber:number andDescription:description];
    [created addObject:busRoute];
    [busRoute release];
    [brLines release];
    [self removeAllBusRoutesFromMap:mapView];
    [self showBusRoute:mapView];
}

- (void)removeAllBusRoutesFromMap:(MKMapView*)mapView
{
    [mapView removeOverlays:_busRoute.lines];
    if (_busRoute) {
        [_busRoute release];
        _busRoute = nil;
    }
    [annotations release]; annotations = nil;
    annotations = [[NSMutableArray alloc] initWithCapacity:0];
    [lines release]; lines = nil;
    lines = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)reverseRoute
{
    
}

- (void)endLine:(MKMapView*)mapView
{
    if (annotations && [annotations count] != 0) {
        [lines addObject:annotations];
        activeLine = [lines count] - 1;
        [self showBusRoute:mapView];
        [annotations release]; annotations = nil;
        annotations = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (void)setActiveLine:(NSString*)lineNum forMapView:(MKMapView*)mapView
{
    activeLine = [lineNum integerValue];
    [self showBusRoute:mapView];
}

#pragma Private Methods
- (void)showBusRoute:(MKMapView*)mapView
{
    [mapView removeOverlays:_busRoute.lines];
    if (_busRoute) [_busRoute release];
    NSMutableArray *brLines = [[NSMutableArray alloc] initWithCapacity:[lines count]];
    for (int j=0; j<[lines count]; j++) {
        NSArray *lineArray = [[lines objectAtIndex:j] retain];
        CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [lineArray count]);
        for (int i = 0; i < [lineArray count]; i++) {
            line[i] = ((BusStop*)[lineArray objectAtIndex:i]).coordinate;
        }
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:line count:[lineArray count]];
        if ((int)activeLine == j) {
            polyLine.title = @"Red";
        } else {
            polyLine.title = @"Blue";
        }
        polyLine.subtitle = [NSString stringWithFormat:@"%i",j];
        free(line);
        [brLines addObject:polyLine];
        [lineArray release];
    }
    _busRoute = [[BusRoute alloc] initWithLines:brLines andTitle:@""];
    [brLines release];
    [mapView addOverlays:_busRoute.lines];
    for (BusRoute *busRoute in created) {
        [mapView addOverlays:busRoute.lines];
    }
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
