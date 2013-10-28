//
//  DrawingImageView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "DrawingImageView.h"

@implementation DrawingImageView

static id instance;

+ (DrawingImageView*)sharedInstance;
{
    if (!instance)
    {
        instance = [[[DrawingImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    }
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
        annotations = [[NSMutableArray alloc] initWithCapacity:0];
        reverse = [[NSMutableArray alloc] initWithCapacity:0];
        lines = [[NSMutableArray alloc] initWithCapacity:0];
        linesReverse = [[NSMutableArray alloc] initWithCapacity:0];
        _created = [[NSMutableArray alloc] initWithCapacity:0];
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
    [_created release]; _created = nil;
    [super dealloc];
}

- (void)addLineFrom:(BusStop*)fromBusStop To:(BusStop*)toBusStop forMapView:(MKMapView*)mapView
{
//    CGPoint toPoint = [mapView convertCoordinate:toBusStop.coordinate toPointToView:self];
//    CGPoint fromPoint = [mapView convertCoordinate:fromBusStop.coordinate toPointToView:self];
    if ([annotations count] == 0) {
        [annotations addObject:fromBusStop];
    }
    [annotations addObject:toBusStop];
    [self showLine:mapView];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self drawLineFrom:fromPoint To:toPoint];
//    });
}

- (void)addBusStop:(BusStop*)busStop toMapView:(MKMapView*)mapView
{
    if (lines && [lines count])
        return;
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
//    dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
//    dispatch_async(drawingQueue, ^{
        [self showBusRoute:mapView];
//    });
//    dispatch_release(drawingQueue);
}

- (void)clearBusStop:(BusStop *)busStop fromMapView:(MKMapView*)mapView
{
    [annotations removeObject:busStop];
//    [self showLine:mapView];
}

- (void)removeBusStop:(BusStop*)busStop fromMapView:(MKMapView*)mapView
{
    if (lines && [lines count])
    {
        [(NSMutableArray*)[lines objectAtIndex:activeLine] removeObject:busStop];
//        dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
//        dispatch_async(drawingQueue, ^{
            [self showBusRoute:mapView];
//        });
//        dispatch_release(drawingQueue);
    }
}

- (void)createBusRouteOnMap:(MKMapView*)mapView withName:(NSString*)name andNumber:(NSString*)number andDescription:(NSString*)description andIsReversed:(BOOL)isReversed
{
    dispatch_queue_t drawingQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(drawingQueue, ^{
        NSMutableArray *brLines = [[NSMutableArray alloc] initWithCapacity:[lines count]];
        for (int j=0; j<[lines count]; j++) {
            NSArray *lineArray = [[lines objectAtIndex:j] retain];
            CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [lineArray count]);
            for (int i = 0; i < [lineArray count]; i++) {
                line[i] = ((BusStop*)[lineArray objectAtIndex:i]).coordinate;
            }
            MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:line count:[lineArray count]];
            polyLine.title = @"Black";
            polyLine.subtitle = [NSString stringWithFormat:@"%i",-1];
            free(line);
            [brLines addObject:polyLine];
            [lineArray release];
        }
        BusRoute *busRoute = [[BusRoute alloc] initWithLines:brLines andTitle:name andNumber:number andDescription:description];
        [_created addObject:busRoute];
        [busRoute release];
        [brLines release];
        [self removeAllBusRoutesFromMap:mapView];
        [self showBusRoute:mapView];
    });
    dispatch_release(drawingQueue);
}

- (void)removeAllBusRoutesFromMap:(MKMapView*)mapView
{
    NSArray *arrayLines = [_busRoute.lines copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [mapView removeOverlays:arrayLines];
        [arrayLines release];
    });
    if (_busRoute) {
        [_busRoute release];
        _busRoute = nil;
    }
    [annotations release]; annotations = nil;
    annotations = [[NSMutableArray alloc] initWithCapacity:0];
    [lines release]; lines = nil;
    lines = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)addReverseStop:(BusStop*)busStop
{
    [reverse addObject:busStop];
}

- (void)reverseRouteOnMapView:(MKMapView *)mapView
{
    isReverse = YES;
}

- (void)endLine:(MKMapView*)mapView
{
    if (annotations && [annotations count] != 0) {
        [lines addObject:annotations];
        [linesReverse addObject:reverse];
        activeLine = [lines count] - 1;
        [self showBusRoute:mapView];
        [annotations release]; annotations = nil;
        [reverse release]; reverse = nil;
        annotations = [[NSMutableArray alloc] initWithCapacity:0];
        reverse = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (void)setActiveLine:(NSString*)lineNum forMapView:(MKMapView*)mapView
{
    activeLine = [lineNum integerValue];
    [self showBusRoute:mapView];
}

#pragma Private Methods
- (void)showLine:(MKMapView*)mapView
{
    self.image = nil;
    for (int i=1; i<[annotations count]; i++) {
        CGPoint toPoint = [mapView convertCoordinate:((BusStop*)[annotations objectAtIndex:i]).coordinate toPointToView:self];
        CGPoint fromPoint = [mapView convertCoordinate:((BusStop*)[annotations objectAtIndex:i-1]).coordinate toPointToView:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawLineFrom:fromPoint To:toPoint];
        });
    }
}
- (void)showBusRoute:(MKMapView*)mapView
{
    NSArray *arrayLines = [_busRoute.lines copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [mapView removeOverlays:arrayLines];
        [arrayLines release];
    });
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
    for (int j=0; j<[linesReverse count]; j++) {
        NSArray *lineArray = [[linesReverse objectAtIndex:j] retain];
        CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [lineArray count]);
        for (int i = 0; i < [lineArray count]; i++) {
            line[i] = ((BusStop*)[lineArray objectAtIndex:i]).coordinate;
        }
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:line count:[lineArray count]];
        polyLine.title = @"Green";
        polyLine.subtitle = [NSString stringWithFormat:@"%i",j];
        free(line);
        [brLines addObject:polyLine];
        [lineArray release];
    }
    _busRoute = [[BusRoute alloc] initWithLines:brLines andTitle:@""];
    [brLines release];
    dispatch_async(dispatch_get_main_queue(), ^{
        [mapView addOverlays:_busRoute.lines];
    });
    for (BusRoute *busRoute in _created) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapView addOverlays:busRoute.lines];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = nil;
    });
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
