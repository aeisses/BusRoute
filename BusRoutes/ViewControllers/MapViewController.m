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
}

- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture
{
    burrowZoomButtonView.frame = (CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0-burrowZoomButtonView.frame.size.height,
        burrowZoomButtonView.frame.size};
    [burrowZoomButtonView showViewAtFrame:(CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0,
        burrowZoomButtonView.frame.size
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotation:busStop];
    });
}

- (void)addProgressIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
        [activityIndicator hidesWhenStopped];
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
    });
}

- (void)removeProgressIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    });
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
    if (burrowZoomButtonView.frame.origin.y >= 0)
        burrowZoomButtonView.hidden = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (burrowZoomButtonView.hidden) {
        burrowZoomButtonView.frame = (CGRect){
            self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
            0,
            burrowZoomButtonView.frame.size
        };
        burrowZoomButtonView.hidden = NO;
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
            [date release]; date = nil;
        }
    }
}

#pragma MovementButtonViewDelegate
- (void)buttonTouched:(id)sender
{
    MovementButton *button = (MovementButton*)sender;
    [_mapView setRegion:[RegionZoomData getRegion:button.region] animated:NO];
    [burrowZoomButtonView showViewAtFrame:(CGRect){
        self.view.frame.size.width-burrowZoomButtonView.frame.size.width,
        0-burrowZoomButtonView.frame.size.height,
        burrowZoomButtonView.frame.size
    }];
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

//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"RegionCentreLatitude: %f Longitude: %f",mapView.region.center.latitude,mapView.region.center.longitude);
//    NSLog(@"RegionSpanLattitudeDelta: %f LongitudeDelta: %f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
//}

@end
