//
//  KDElement.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-21.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusStop.h"

@interface KDElement : NSObject

@property (readonly) double latitude;
@property (readonly) double longitude;
@property (copy, nonatomic) KDElement *left;
@property (copy, nonatomic) KDElement *right;

- (id)intiWithBusStop:(BusStop*)busStop;

@end
