//
//  DataReader.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReader : NSObject
{
    NSDictionary *busStopsJson;
}

- (id)init;

@property (nonatomic, retain, getter = getStops) NSArray *stops;

@end
