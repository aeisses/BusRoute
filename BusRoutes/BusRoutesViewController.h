//
//  BusRoutesViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataReader.h"
#import "MapViewController.h"

@interface BusRoutesViewController : UIViewController
{
    DataReader *dataReader;
    MapViewController *mapViewController;
    UIActivityIndicatorView *activityIndicator;
}

@end
