//
//  BusRoutesViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "BusRoutesViewController.h"

@interface HudZoomButtonsView (PrivateMethods)
- (void)showMapViewController;
@end;

@implementation BusRoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Load in data
    dataReader = [[DataReader alloc] init];
    dataReader.delegate = self;
    [self showMapViewController];
    __block DataReader *blockDataReader = dataReader;
    dispatch_queue_t loadDataQueue  = dispatch_queue_create("load data queue", NULL);
    dispatch_async(loadDataQueue, ^{
        [mapViewController addProgressIndicator];
        [blockDataReader loadKMLData];
    });
    dispatch_release(loadDataQueue);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)dealloc
{
    [super dealloc];
    [dataReader release]; dataReader = nil;
    [mapViewController release]; mapViewController = nil;
}

#pragma Private Methods
- (void)showMapViewController
{
    mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapViewController.delegate = self;
    [[self navigationController] pushViewController:mapViewController animated:NO];
}

#pragma DataReaderDelegate Methods
- (void)startProgressIndicator
{
    [mapViewController disableGestures];
    mapViewController.isDataLoading = YES;
}

- (void)endProgressIndicator
{
    mapViewController.isDataLoading = NO;
    [mapViewController removeProgressIndicator];
    [mapViewController enableGestures];
}

- (void)addBusStop:(BusStop*)busStop
{
    [mapViewController addBusStop:busStop];
}

-(void)addRoute:(BusRoute*)route;
{
    [mapViewController addRoute:route];
}

#pragma MapViewControllerDelegate Methods
- (NSArray*)getStops
{
    return dataReader.stops;
}

- (NSArray *)getRoutes
{
    return dataReader.routes;
}

- (void)showStopsWithValue:(NSInteger)value
{
    [dataReader showBusStopsWithValue:value];
}

- (void)showRoutes
{
    [dataReader showRoutes];
}

@end
