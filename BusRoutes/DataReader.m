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
            [mutableStops addObject:[[BusStop alloc] initWithName:placemark.name description:placemark.descriptionValue andLocation:(KMLPoint *)placemark.geometry] ];
        }
    }
    _stops = [[NSArray alloc] initWithArray:mutableStops];
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
}
@end
