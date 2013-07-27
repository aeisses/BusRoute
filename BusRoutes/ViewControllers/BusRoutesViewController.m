//
//  BusRoutesViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "BusRoutesViewController.h"

@interface MovementButtonView (PrivateMethods)
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [blockDataReader loadKMLData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
//        buttonView.frame = (CGRect){768-150,buttonView.frame.origin.y,buttonView.frame.size};
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        buttonView.frame = (CGRect){1024-150,buttonView.frame.origin.y,buttonView.frame.size};
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        buttonView.frame = (CGRect){1024-150,buttonView.frame.origin.y,buttonView.frame.size};
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//        buttonView.frame = (CGRect){768-150,buttonView.frame.origin.y,buttonView.frame.size};
    }
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
    [[self navigationController] pushViewController:mapViewController animated:NO];
}

#pragma DataReaderDelegate Methods
-(void)startProgressIndicator
{
    [mapViewController disableGestures];
    [mapViewController addProgressIndicator];
}

-(void)endProgressIndicator
{
    [mapViewController removeProgressIndicator];
    [mapViewController enableGestures];
}

-(void)addBusStop:(BusStop*)busStop
{
    [mapViewController addBusStop:busStop];
}

@end
