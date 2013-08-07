//
//  MapViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController (PrivateMethods)
- (void)frameIntervalLoop:(CADisplayLink *)sender;
@end;

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenDown:)];
        swipeDown.numberOfTouchesRequired = 1;
        swipeDown.direction = (UISwipeGestureRecognizerDirectionDown);
        
        swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenUp:)];
        swipeUp.numberOfTouchesRequired = 1;
        swipeUp.direction = (UISwipeGestureRecognizerDirectionUp);
        
        UIImage *image = [UIImage imageNamed:@"landscapeHudView"];
        hudView = [[HudView alloc] initWithImage:image];
        hudView.delegate = self;
        hudView.frame = (CGRect){hudView.frame.origin.x, 0-hudView.frame.size.height, hudView.frame.size};
        
        legendView = [[[[NSBundle mainBundle] loadNibNamed:@"LegendView" owner:self options:nil] objectAtIndex:0] retain];
        legendView.delegate = self;
        
        showNumberOfRoutesStops = NO;
        buttonSort = -1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (date != nil) {
        [date release];
        date = [[NSDate alloc] init];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    [self.view addSubview:hudView];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameIntervalLoop:)];
    [displayLink setFrameInterval:15];
}

- (void)swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture
{
    [hudView hide];
}

- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture
{
    [hudView show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView setRegion:[RegionZoomData getRegion:HRM] animated:NO];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    if (date != nil) {
        [date release];
        date = [[NSDate alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBusStop:(BusStop*)busStop
{
    loadingBusStopCounter++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotation:busStop];
    });
}

- (void)addRoute:(BusRoute*)route
{
    loadingBusRouteCounter++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addOverlays:route.lines];
    });
}

- (void)addProgressIndicator
{
    if (activityIndicator == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
            [activityIndicator hidesWhenStopped];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
    });
}

- (void)removeProgressIndicator
{
    if (!_isDataLoading && !loadingBusStopCounter && !loadingBusRouteCounter) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });
    }
}

- (void)enableGestures
{
    swipeDown.enabled = YES;
    swipeUp.enabled = YES;
}

- (void)disableGestures
{
    swipeDown.enabled = NO;
    swipeUp.enabled = NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (hudView.frame.origin.y >= 0) {
        hudView.hidden = YES;
    }
    [hudView setOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (hudView.hidden) {
        hudView.hidden = NO;
    }
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
}

- (void)dealloc
{
    [super dealloc];
    [hudView release];
    [_mapView release]; _mapView = nil;
    [swipeDown release]; swipeDown = nil;
    [swipeUp release]; swipeUp = nil;
    [legendView release]; legendView = nil;
    _delegate = nil;
}

#pragma Private Methods
- (void)frameIntervalLoop:(CADisplayLink *)sender
{
    if (hudView.frame.origin.y >= 0) {
        if (date == nil) {
            date = [[NSDate alloc] init];
        }
        if ([date timeIntervalSinceNow] < WINDOWS_AUTO_CLOSE) {
            [hudView hide];
            [date release]; date = nil;
        }
    }
}

#pragma HudViewDelegate Methods
- (void)zoomButtonTouched:(id)sender
{
    MovementButton *button = (MovementButton*)sender;
    [_mapView setRegion:[RegionZoomData getRegion:button.region] animated:NO];
    [hudView hide];
}

- (void)displayButtonPressed:(id)sender
{
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        DisplayButton *button = (DisplayButton*)sender;
        [self addProgressIndicator];
        if (button.displayType == routes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:[_delegate getStops]];
            });
            [_delegate showRoutes];
        } else if (button.displayType == stops) {
            for (BusRoute *busRoute in [_delegate getRoutes]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeOverlays:busRoute.lines];
                });
            }
            [_delegate showStopsWithValue:-1];
        }
    });
    dispatch_release(loadDataQueue);
    [hudView hide];
}

- (void)stopsButtonPressed:(id)sender
{
    StopsButton *button = (StopsButton*)sender;
    if (button.stopType == legend) {
        legendView.frame = (CGRect){50,200,legendView.frame.size};
        [self.view addSubview:legendView];
    } else if (button.stopType == terminal) {
        dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
        dispatch_async(loadDataQueue, ^{
            [self addProgressIndicator];
            showTerminals = YES;
            showNumberOfRoutesStops = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:[_delegate getStops]];
            });
            [_delegate showStopsWithValue:-1];
        });
        dispatch_release(loadDataQueue);
    } else {
        dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
        dispatch_async(loadDataQueue, ^{
            [self addProgressIndicator];
            showNumberOfRoutesStops = YES;
            showTerminals = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:[_delegate getStops]];
            });
            [_delegate showStopsWithValue:-1];
        });
        dispatch_release(loadDataQueue);
    }
    [hudView hide];
}

#pragma LegendViewDelegate Methods
- (void)showNumberOfRoutes:(NSInteger)num
{
    buttonSort = num;
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        [self addProgressIndicator];
        showNumberOfRoutesStops = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapView removeAnnotations:[_delegate getStops]];
        });
        [_delegate showStopsWithValue:buttonSort];
    });
    dispatch_release(loadDataQueue);
}

- (void)exitLegendView
{
    [legendView removeFromSuperview];
}

#pragma MKMapViewDelegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BusStop class]]) {
        NSString *identifier;
        if (!showNumberOfRoutesStops && !showTerminals) {
            identifier = @"BusStop";
        } else if (!showNumberOfRoutesStops && showTerminals) {
            BusStop *busStop = (BusStop*)annotation;
            identifier = [NSString stringWithFormat:@"Terminal%i",busStop.fcode];
        } else {
            BusStop *busStop = (BusStop*)annotation;
            identifier = [NSString stringWithFormat:@"BusStop%i",[busStop.routes count]];
        }
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            annotationView.enabled = NO;
            annotationView.canShowCallout = NO;
            NSString *imageName;
            if (!showNumberOfRoutesStops && !showTerminals) {
                imageName = @"dot0.png";
            } else if (!showNumberOfRoutesStops && showTerminals) {
                BusStop *busStop = (BusStop*)annotation;
                imageName = [NSString stringWithFormat:@"terminal%i",busStop.fcode];
            } else {
                BusStop *busStop = (BusStop*)annotation;
                imageName = [NSString stringWithFormat:@"dot%i.png",[busStop.routes count]];
/*                if (buttonSort != -1 && [busStop.routes count] != buttonSort) {
                    annotationView.hidden = YES;
                } else {
                    annotationView.hidden = NO;
                }
 */
            }
            annotationView.image = [UIImage imageNamed:imageName];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    loadingBusStopCounter--;
    [self removeProgressIndicator];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    polylineView.strokeColor = [UIColor blackColor];
    polylineView.lineJoin = kCGLineCapButt;
    polylineView.lineWidth = 2.0;
    
    return polylineView;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews {
    loadingBusRouteCounter--;
    [self removeProgressIndicator];
}

@end
