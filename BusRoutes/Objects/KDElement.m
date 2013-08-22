//
//  KDElement.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-21.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "KDElement.h"

@implementation KDElement

- (id)intiWithBusStop:(BusStop*)busStop
{
    if (self = [super init]) {
        _longitude = busStop.coordinate.longitude;
        _latitude = busStop.coordinate.latitude;
        _left = nil;
        _right = nil;
    }
    return self;
}

- (void)dealloc
{
    if (_left) [_left release];
    if (_right) [_right release];
    [super dealloc];
}

@end
