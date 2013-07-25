//
//  MapViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "MapViewController.h"

#define HALIFAX_LATITUDE_CENTRE 44.6479 // This is the offical centre of Halifax.
#define HALIFAX_LATITUDE_MAX 44.695 // This is max latitude, we need to shift a bit, halifax is not a square city.
#define HALIFAX_LONGITUDE -63.5744

#define HALIFAX_ZOOM_MAX 37500

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(HALIFAX_LATITUDE_MAX,HALIFAX_LONGITUDE), HALIFAX_ZOOM_MAX, HALIFAX_ZOOM_MAX) animated:NO];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"BusStop";
    if ([annotation isKindOfClass:[BusStop class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
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

- (void)dealloc
{
    [super dealloc];
    [_mapView release]; _mapView = nil;
}
@end
