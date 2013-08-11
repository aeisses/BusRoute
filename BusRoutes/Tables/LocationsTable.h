//
//  LocationsTableViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionZoomData.h"

@protocol LocationsTableDelegate <NSObject>
- (void)touchedLocationTable:(REGION)region;
- (void)freeZoom;
@end

@interface LocationsTable : UITableViewController
{
    NSArray *locations;
}

@property (retain, nonatomic) id <LocationsTableDelegate> delegate;

@end
