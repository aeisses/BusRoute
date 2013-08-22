//
//  KDTree.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-20.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "KDTree.h"

@implementation KDTree

- (id)initKDNodeWithBusStop:(BusStop*)busStop
{
    if (self = [super init]) {

    }
    return self;
}

- (id)initKDNodeWithBusStops:(NSArray*)array
{
    if (self = [super init]) {
//        NSMutableArray *theArray = [[NSMutableArray alloc] initWithArray:array];
//        int median = [self findMedia:theArray];
    }
    return self;
}

- (void)addBusStop:(BusStop*)busStop
{
    
}

- (int)findMedian:(NSMutableArray*)array
{
//    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"coordinates.latitude" ascending:YES] autorelease];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray;
//    sortedArray = [drinkDetails sortedArrayUsingDescriptors:sortDescriptors];
    return 0;
}
 
- (void)removeBusStop:(BusStop*)busStop
{
    
}

- (BusStop*)nearestBusStop:(BusStop*)busStop
{
    return nil;
}

- (void)dealloc
{
    [super dealloc];
}
@end
