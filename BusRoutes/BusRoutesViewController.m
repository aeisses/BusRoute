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
    
    // Load in data
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dataReader = [[DataReader alloc] init];
//    });
    
    mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [self showMapViewController];
    NSLog(@"Data: %@",[dataReader getStops]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
