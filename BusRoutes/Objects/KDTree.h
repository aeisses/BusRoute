//
//  KDTree.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-20.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDElement.h"
#import "BusStop.h"

#define MAX_DIMENSION 3

@interface KDTree : NSObject
{
    KDElement *root;
    NSMutableArray *array;
}

- (id)initKDNodeWithBusStop:(BusStop*)busStop;
- (id)initKDNodeWithBusStops:(NSArray*)array;
- (void)addBusStop:(BusStop*)busStop;
- (void)removeBusStop:(BusStop*)busStop;
- (BusStop*)nearestBusStop:(BusStop*)busStop;

@end
