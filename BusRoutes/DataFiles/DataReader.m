//
//  DataReader.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//
#import "DataReader.h"

#define KMLBUSSTOPSURL @"https://www.halifaxopendata.ca/api/geospatial/xus8-fjzt?method=export&format=KML"
#define KMLBUSROUTEURL @"https://www.halifaxopendata.ca/api/geospatial/y3cf-ivzs?method=export&format=KML"

@interface DataReader (PrivateMethods)
- (void)loadStopDataAndShow:(BOOL)show;
- (void)loadRouteDataAndShow:(BOOL)show;
@end;

@implementation DataReader

@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        stopsUrl = [[NSURL alloc] initWithString:KMLBUSSTOPSURL];
        routesUrl = [[NSURL alloc] initWithString:KMLBUSROUTEURL];
    }
    return self;
}

- (void)loadKMLData
{
    [delegate startProgressIndicator];
    [self loadStopDataAndShow:YES];
    [self loadRouteDataAndShow:YES];
    [delegate endProgressIndicator];
}

- (void)showBusStops
{
    [delegate startProgressIndicator];
    [self loadStopDataAndShow:YES];
    [delegate endProgressIndicator];
}

- (void)showRoutes
{
    [delegate startProgressIndicator];
    [self loadRouteDataAndShow:YES];
    [delegate endProgressIndicator];
}

- (void)dealloc
{
    [super dealloc];
    [_stops release];
    [_routes release];
    [stopsUrl release];
    [routesUrl release];
    delegate = nil;
}

#pragma Private Methods
- (void)loadStopDataAndShow:(BOOL)show
{
    if (_stops != nil && show) {
        for (BusStop *busStop in _stops) {
            [delegate addBusStop:busStop];
        }
    } else if (_stops == nil) {
        KMLRoot *kmlStops = [KMLParser parseKMLAtURL:stopsUrl];
        NSMutableArray *mutableStops = [NSMutableArray array];
        for (KMLPlacemark *placemark in kmlStops.placemarks) {
            if (placemark.geometry && placemark.name) {
                BusStop *busStop = [[BusStop alloc] initWithTitle:placemark.name description:placemark.descriptionValue andLocation:(KMLPoint *)placemark.geometry];
                [mutableStops addObject:busStop];
                if (show)
                    [delegate addBusStop:busStop];
                [busStop release];
            }
        }
        _stops = [[NSArray alloc] initWithArray:mutableStops];
    }
}

- (void)loadRouteDataAndShow:(BOOL)show
{
    if (_routes != nil && show) {
        
    } else if (_routes == nil) {
        KMLRoot *kmlRoutes = [KMLParser parseKMLAtURL:routesUrl];
        NSMutableArray *mutableRoutes = [NSMutableArray array];
        for (KMLPlacemark *placemark in kmlRoutes.placemarks) {
            if (placemark.geometry && placemark.name) {
                BusRoute *busRoute = [[BusRoute alloc] initWithTitle:placemark.name description:placemark.descriptionValue andGeometries:(KMLMultiGeometry *)placemark.geometry];
                [mutableRoutes addObject:busRoute];
                if (show)
                    [delegate addRoute:busRoute];
                [busRoute release];
            }
        }
        _routes = [[NSArray alloc] initWithArray:mutableRoutes];
    }
}

@end
