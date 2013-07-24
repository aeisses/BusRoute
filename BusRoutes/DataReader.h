//
//  DataReader.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KML/KML.h>
#import "BusStop.h"

@interface DataReader : NSObject
{
    NSURL *url;
}

- (id)init;
- (void)loadKMLData;

@property (nonatomic, retain) NSArray *stops;

@end
