//
//  MapViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStop.h"
#import "RegionZoomData.h"
#import "BurrowZoomButtonsView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,MovementButtonViewDelegate>
{
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    BurrowZoomButtonsView *burrowZoomButtonView;
    UIActivityIndicatorView *activityIndicator;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

- (void)addBusStop:(BusStop*)busStop;
- (void)addProgressIndicator;
- (void)removeProgressIndicator;
- (void)enableGestures;
- (void)disableGestures;

@end
