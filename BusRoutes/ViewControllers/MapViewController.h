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
#import "BusRoute.h"
#import "RegionZoomData.h"
#import "BurrowZoomButtonsView.h"
#import "DisplayTypeView.h"

#define WINDOWS_AUTO_CLOSE -30.0 // Seconds

@protocol MapViewControllerDelegate <NSObject>
- (NSArray *)getStops;
- (NSArray *)getRoutes;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate,MovementButtonViewDelegate,DisplayTypeViewDelegate>
{
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    BurrowZoomButtonsView *burrowZoomButtonView;
    DisplayTypeView *displayTypeView;
    UIActivityIndicatorView *activityIndicator;
    CADisplayLink *displayLink;
    NSDate *date;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (retain, nonatomic) id <MapViewControllerDelegate> delegate;

- (void)addBusStop:(BusStop*)busStop;
- (void)addProgressIndicator;
- (void)removeProgressIndicator;
- (void)enableGestures;
- (void)disableGestures;

@end
