//
//  DataReader.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//
#import "DataReader.h"

#define STOPDATAFILE @"stops"
#define STOPSGEODATAFILE @"Bus Stops"
#define KMLBUSSTOPSURL @"https://www.halifaxopendata.ca/api/geospatial/xus8-fjzt?method=export&format=KML"

@implementation DataReader

@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        url = [[NSURL alloc] initWithString:KMLBUSSTOPSURL];
        _stops = [NSArray array];
    }
    return self;
}

- (void)loadKMLData
{
    KMLRoot *kml = [KMLParser parseKMLAtURL:url];
    NSMutableArray *mutableStops = [NSMutableArray array];
    for (KMLPlacemark *placemark in kml.placemarks) {
        if (placemark.geometry && placemark.name) {
            BusStop *busStop = [[BusStop alloc] initWithTitle:placemark.name description:placemark.descriptionValue andLocation:(KMLPoint *)placemark.geometry];
            [mutableStops addObject:busStop];
            [delegate addBusStop:busStop];
            [busStop release];
        }
    }
    _stops = [[NSArray alloc] initWithArray:mutableStops];
    NSLog(@"Finished Loading Data");
}

- (NSArray*)getStops
{
    return _stops;
}

- (void)dealloc
{
    [super dealloc];
    [_stops release];
    [url release];
    delegate = nil;
}
@end
