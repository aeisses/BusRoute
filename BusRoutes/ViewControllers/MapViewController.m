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
        
        burrowZoomButtonView = [[[NSBundle mainBundle] loadNibNamed:@"BurrowZoomButtonsView" owner:self options:nil] objectAtIndex:0];
        burrowZoomButtonView.delegate = self;
        burrowZoomButtonView.frame = (CGRect){
            self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
            0-burrowZoomButtonView.frame.size.height,
            burrowZoomButtonView.frame.size};
        [burrowZoomButtonView setButtons];
        [self.view addSubview:burrowZoomButtonView];
        
        displayTypeView = [[[NSBundle mainBundle] loadNibNamed:@"DisplayTypeView" owner:self options:nil] objectAtIndex:0];
        displayTypeView.delegate = self;
        displayTypeView.frame = (CGRect){
            0,
            0-displayTypeView.frame.size.height,
            displayTypeView.frame.size
        };
        [displayTypeView setButtons];
        [self.view addSubview:displayTypeView];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (date != nil) {
        [date release];
        date = [[NSDate alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameIntervalLoop:)];
    [displayLink setFrameInterval:15];
}

- (void)swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture
{
    [burrowZoomButtonView showViewAtFrame:(CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0-burrowZoomButtonView.frame.size.height,
        burrowZoomButtonView.frame.size
    }];
    [displayTypeView showViewAtFrame:(CGRect){
        0,
        0-displayTypeView.frame.size.height,
        displayTypeView.frame.size
    }];
}

- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture
{
    burrowZoomButtonView.frame = (CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0-burrowZoomButtonView.frame.size.height,
        burrowZoomButtonView.frame.size};
    displayTypeView.frame = (CGRect){
        0,
        0-displayTypeView.frame.size.height,
        displayTypeView.frame.size
    };
    [burrowZoomButtonView showViewAtFrame:(CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0,
        burrowZoomButtonView.frame.size
    }];
    [displayTypeView showViewAtFrame:(CGRect){
        0,
        0,
        displayTypeView.frame.size
    }];
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
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
        [activityIndicator hidesWhenStopped];
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
    if (burrowZoomButtonView.frame.origin.y >= 0) {
        burrowZoomButtonView.hidden = YES;
        displayTypeView.hidden = YES;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (burrowZoomButtonView.hidden) {
        burrowZoomButtonView.frame = (CGRect){
            self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
            0,
            burrowZoomButtonView.frame.size
        };
        displayTypeView.frame = (CGRect){
            0,
            0,
            displayTypeView.frame.size
        };
        burrowZoomButtonView.hidden = NO;
        displayTypeView.hidden = NO;
    }
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
}

- (void)dealloc
{
    [super dealloc];
    [_mapView release]; _mapView = nil;
    [burrowZoomButtonView release]; burrowZoomButtonView = nil;
    [swipeDown release]; swipeDown = nil;
    [swipeUp release]; swipeUp = nil;
    _delegate = nil;
}

#pragma Private Methods
- (void)frameIntervalLoop:(CADisplayLink *)sender
{
    if (burrowZoomButtonView.frame.origin.y >= 0) {
        if (date == nil) {
            date = [[NSDate alloc] init];
        }
        if ([date timeIntervalSinceNow] < WINDOWS_AUTO_CLOSE) {
            [burrowZoomButtonView showViewAtFrame:(CGRect){
                self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
                0-burrowZoomButtonView.frame.size.height,
                burrowZoomButtonView.frame.size
            }];
            [displayTypeView showViewAtFrame:(CGRect){
                0,
                0-displayTypeView.frame.size.height,
                displayTypeView.frame.size
            }];
            [date release]; date = nil;
        }
    }
}

#pragma BurrowZoomButtonViewDelegate
- (void)burrowZoomButtonTouched:(id)sender
{
    MovementButton *button = (MovementButton*)sender;
    [_mapView setRegion:[RegionZoomData getRegion:button.region] animated:NO];
    [burrowZoomButtonView showViewAtFrame:(CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0-burrowZoomButtonView.frame.size.height,
        burrowZoomButtonView.frame.size
    }];
    [displayTypeView showViewAtFrame:(CGRect){
        0,
        0-displayTypeView.frame.size.height,
        displayTypeView.frame.size
    }];
}

#pragma DisplayTypeViewDelegate
- (void)displayTypeButtonPressed:(id)sender
{
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        [self addProgressIndicator];
        if (displayTypeView.routeButton.enabled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:[_delegate getStops]];
            });
            [_delegate showRoutes];
            displayTypeView.routeButton.enabled = NO;
            displayTypeView.stopButton.enabled = YES;
        } else if (displayTypeView.stopButton.enabled) {
            for (BusRoute *busRoute in [_delegate getRoutes]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeOverlays:busRoute.lines];
                });
            }
            [_delegate showStops];
            displayTypeView.routeButton.enabled = YES;
            displayTypeView.stopButton.enabled = NO;
        }
    });
    dispatch_release(loadDataQueue);
}

#pragma MKMapViewDelegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"BusStop";
    if ([annotation isKindOfClass:[BusStop class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
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
