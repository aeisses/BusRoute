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
#import "HudView.h"
#import "StopsButton.h"
#import "LegendView.h"

#define WINDOWS_AUTO_CLOSE -30.0 // Seconds

@protocol MapViewControllerDelegate <NSObject>
- (NSArray *)getStops;
- (NSArray *)getRoutes;
- (void)showStopsWithValue:(NSInteger)value;
- (void)showRoutes;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate,HudViewDelegate,LegendViewDelegate>
{
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    UIActivityIndicatorView *activityIndicator;
    HudView *hudView;
    CADisplayLink *displayLink;
    NSDate *date;
    int loadingBusStopCounter;
    int loadingBusRouteCounter;
    BOOL showNumberOfRoutesStops;
    BOOL showTerminals;
    LegendView *legendView;
    NSInteger buttonSort;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign) BOOL isDataLoading;
@property (retain, nonatomic) id <MapViewControllerDelegate> delegate;

- (void)addBusStop:(BusStop*)busStop;
- (void)addRoute:(BusRoute*)route;
- (void)addProgressIndicator;
- (void)removeProgressIndicator;
- (void)enableGestures;
- (void)disableGestures;

@end
