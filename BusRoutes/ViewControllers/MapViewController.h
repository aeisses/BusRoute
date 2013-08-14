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
#import "StopsButton.h"
#import "LegendView.h"
#import "NumericNodeTable.h"
#import "LocationsTable.h"
#import "TerminalTable.h"
#import "DrawingImageView.h"
#import "SaveViewController.h"

#define WINDOWS_AUTO_CLOSE -30.0 // Seconds

@protocol MapViewControllerDelegate <NSObject>
- (NSArray *)getStops;
- (NSArray *)getRoutes;
- (void)showStopsWithValue:(NSInteger)value isTerminal:(BOOL)isTerminal;
- (void)showRoutes;
- (void)clearSets;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate,LegendViewDelegate,NumericNodeTableDelegate,LocationsTableDelegate,TerminalTableDelegate,DrawingImageViewDelegate>
{
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    UITapGestureRecognizer *touchDown;
    UIPanGestureRecognizer *pan;
    UIActivityIndicatorView *activityIndicator;
    CADisplayLink *displayLink;
    NSDate *date;
    int loadingBusStopCounter;
    int loadingBusRouteCounter;
    BOOL showNumberOfRoutesStops;
    BOOL showTerminals;
    LegendView *legendView;
    UIPopoverController *popOverController;
    CGPoint drawingLastPoint;
    CGPoint drawingPoint;
    DrawingImageView *drawingImageView;
    SaveViewController *saveViewController;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (assign) BOOL isDataLoading;
@property (retain, nonatomic) id <MapViewControllerDelegate> delegate;

- (IBAction)titleBarButtonTouched:(id)sender;
- (void)addBusStop:(BusStop*)busStop;
- (void)addRoute:(BusRoute*)route;
- (void)addProgressIndicator;
- (void)removeProgressIndicator;
@end

@interface MapViewController (PrivateMethods)
- (void)swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture;
- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture;
- (void)mapTapped:(UITapGestureRecognizer*)tapGesture;
- (void)frameIntervalLoop:(CADisplayLink *)sender;
- (void)hideHudView;
- (void)showHudView;
- (void)enableGestures;
- (void)disableGestures;
@end;