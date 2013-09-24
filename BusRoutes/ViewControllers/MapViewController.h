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
#import "NumericNodeTable.h"
#import "LocationsTable.h"
#import "TerminalTable.h"
#import "DrawingImageView.h"
#import "SaveViewController.h"
#import "PruneViewController.h"
#import "InfoViewController.h"

#define WINDOWS_AUTO_CLOSE -30.0 // Seconds

@protocol MapViewControllerDelegate <NSObject>
- (NSArray *)getStops;
- (NSArray *)getRoutes;
- (void)showStopsWithValue:(NSInteger)value isTerminal:(BOOL)isTerminal;
- (void)pruneRoutesMetroX:(BOOL)metroX andMetroLink:(BOOL)metroLink andExpressRoute:(BOOL)expressRoute;
- (void)showRoutes;
- (void)clearSets;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate,LocationsTableDelegate,PruneControllerDelegate,InfoViewControllerDelegate,SaveViewControllerDelegate>
{
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    UITapGestureRecognizer *touchDown;
    UIActivityIndicatorView *activityIndicator;
    CADisplayLink *displayLink;
    NSDate *date;
    int loadingBusStopCounter;
    int loadingBusRouteCounter;
    BOOL showNumberOfRoutesStops;
    BOOL showTerminals;
    BOOL isMoving;
    UIPopoverController *popOverController;
    BusStop *prevBusStop;
    BusStop *intermediateBusStop;
    MKAnnotationView *prevBusView;
    MKAnnotationView *intermediateBusView;
    DrawingImageView *drawingImageView;
    SaveViewController *saveViewController;
    int counter;
    UIButton *saveButton;
    UIButton *clearButton;
    UIButton *deleteButton;
    UIButton *createRoute;
    UIButton *reverseButton;
    BOOL isDrawing;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UIButton *zoomButton;
@property (assign) BOOL isDataLoading;
@property (retain, nonatomic) id <MapViewControllerDelegate> delegate;

- (IBAction)titleBarButtonTouched:(id)sender;
- (IBAction)touchZoomButton:(id)sender;
- (void)addBusStop:(BusStop*)busStop;
- (void)addRoute:(BusRoute*)route;
- (void)addProgressIndicator;
- (void)removeProgressIndicator;
@end

@interface MapViewController (PrivateMethods)
- (void)touchSaveButton;
- (void)touchClearButton;
- (void)touchCreateRouteButton;
- (void)touchDeleteButton;
- (void)swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture;
- (void)swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture;
- (void)mapTapped:(UITapGestureRecognizer*)tapGesture;
- (void)frameIntervalLoop:(CADisplayLink *)sender;
- (void)hideHudView;
- (void)showHudView;
- (void)enableGestures;
- (void)disableGestures;
- (NSArray*)filterArrayForStreetName:(NSString*)street;
@end;