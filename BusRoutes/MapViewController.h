//
//  MapViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStop.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

-(void)addBusStop:(BusStop*)busStop;

@end
