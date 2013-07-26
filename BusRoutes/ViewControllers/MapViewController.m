//
//  MapViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "MapViewController.h"

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
        
        buttonView = [[[NSBundle mainBundle] loadNibNamed:@"MovementButtonView" owner:self options:nil] objectAtIndex:0];
        buttonView.delegate = self;
        buttonView.frame = (CGRect){
            self.view.frame.size.width-buttonView.frame.size.width,
            0-buttonView.frame.size.height,
            buttonView.frame.size};
        [buttonView setButtons];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    [self.view addSubview:buttonView];
}

- (void)swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture
{
    [buttonView showViewAtFrame:(CGRect){
        buttonView.frame.origin.x,
        0-buttonView.frame.size.height,
        buttonView.frame.size
    }];
}

- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture
{
    [buttonView showViewAtFrame:(CGRect){
        buttonView.frame.origin.x,
        0,
        buttonView.frame.size
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView setRegion:[RegionZoomData getRegion:HRM] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBusStop:(BusStop*)busStop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotation:busStop];
    });
}

- (void)dealloc
{
    [super dealloc];
    [_mapView release]; _mapView = nil;
    [buttonView release]; buttonView = nil;
    [swipeDown release]; swipeDown = nil;
    [swipeUp release]; swipeUp = nil;
}

#pragma MovementButtonViewDelegate
- (void)buttonTouched:(id)sender
{
    MovementButton *button = (MovementButton*)sender;
    [_mapView setRegion:[RegionZoomData getRegion:button.region] animated:YES];
    [buttonView showViewAtFrame:(CGRect){
        buttonView.frame.origin.x,
        0-buttonView.frame.size.height,
        buttonView.frame.size
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
