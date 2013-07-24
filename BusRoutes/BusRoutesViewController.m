//
//  BusRoutesViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "BusRoutesViewController.h"

@interface BusRoutesViewController ()

@end

@implementation BusRoutesViewController

- (void)showMapViewController
{
    [[self navigationController] pushViewController:mapViewController animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicator.center = CGPointMake(100,100);
//    [activityIndicator hidesWhenStopped];
//    [self.view addSubview:activityIndicator];
//    [activityIndicator startAnimating];
    
    // Load in data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dataReader = [[DataReader alloc] init];
        [dataReader loadKMLData];
        dispatch_async(dispatch_get_main_queue(), ^{
            mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
//            [activityIndicator stopAnimating];
            [self showMapViewController];
        });
    });
    
//    NSLog(@"Data: %@",[dataReader getStops]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [dataReader release]; dataReader = nil;
    [mapViewController release]; mapViewController = nil;
}
@end
