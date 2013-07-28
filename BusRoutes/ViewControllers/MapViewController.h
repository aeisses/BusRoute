//
//  MapViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BusStop.h"
#import "RegionZoomData.h"
#import "BurrowZoomButtonsView.h"

#define WINDOWS_AUTO_CLOSE -30.0 // Seconds

@interface MapViewController : UIViewController <MKMapViewDelegate,MovementButtonViewDelegate>
{
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    BurrowZoomButtonsView *burrowZoomButtonView;
    UIActivityIndicatorView *activityIndicator;
    CADisplayLink *displayLink;
    NSDate *date;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

- (void)addBusStop:(BusStop*)busStop;
- (void)addProgressIndicator;
- (void)removeProgressIndicator;
- (void)enableGestures;
- (void)disableGestures;

@end
