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
#import "BusRoute.h"

@protocol DataReaderDelegate <NSObject>
-(void)startProgressIndicator;
-(void)endProgressIndicator;
-(void)addBusStop:(BusStop*)busStop;
@end

@interface DataReader : NSObject
{
    NSURL *stopsUrl;
    NSURL *routesUrl;
}

- (id)init;
- (void)loadKMLData;

@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) id <DataReaderDelegate> delegate;

@end
