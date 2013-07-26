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
    
//    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicator.center = CGPointMake(100,100);
//    [activityIndicator hidesWhenStopped];
//    [self.view addSubview:activityIndicator];
//    [activityIndicator startAnimating];
    
    // Load in data
    dataReader = [[DataReader alloc] init];
    dataReader.delegate = self;
    [self showMapViewController];

    __block DataReader *blockDataReader = dataReader;
//    __block BusRoutesViewController *blockSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        __block DataReader* blockDataReader = dataReader;
//        dispatch_async(dispatch_get_main_queue(), ^{
            //            [activityIndicator stopAnimating];
//        });
        [blockDataReader loadKMLData];
//        NSLog(@"Count: %i",[blockDataReader.stops count]);
//        for (int i=0; i<[blockDataReader.stops count]-1; i++) {
//            NSLog(@"i: %i: BusStop: %@",i,[blockDataReader.stops objectAtIndex:i]);
//            dispatch_async(dispatch_get_main_queue(), ^{
///                [mapViewController addBusStop:[blockDataReader.stops objectAtIndex:i]];
//            });
//        }
    });
    
//    NSLog(@"Data: %@",[dataReader getStops]);
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
-(void)addBusStop:(BusStop*)busStop
{
    //    __block BusStop *blockBusStop = busStop;
    //    __block MapViewController *blockMapViewController = mapViewController;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [mapViewController addBusStop:busStop];
    //    });
}

@end
