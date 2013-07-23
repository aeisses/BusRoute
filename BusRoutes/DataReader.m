//
//  DataReader.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//
#import "DataReader.h"

#define STOPDATAFILE @"stops"

@implementation DataReader

- (id)init
{
    if (self = [super init])
    {
        // Load in the data file
        NSError *error;
        NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:STOPDATAFILE ofType:@"json"]]];
        busStopsJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    return self;
}

-(NSArray*)getStops
{
    return (NSArray *)[busStopsJson objectForKey:@"data"];
}

@end
