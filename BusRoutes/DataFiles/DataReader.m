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
#define ESERVICENUMBER @"http://eservices.halifax.ca/GoTime/index.jsf?goTime="

@interface DataReader (PrivateMethods)
- (void)loadStopDataAndShow:(BOOL)show withSet:(NSSet*)set;
- (void)loadTerminalDataAndShow:(BOOL)show withSet:(NSSet*)set;
- (void)loadRouteDataAndShow:(BOOL)show;
@end;

@implementation DataReader

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
    [_delegate startProgressIndicator];
    [self loadStopDataAndShow:YES withSet:[NSSet set]];
    [self loadRouteDataAndShow:NO];
    [_delegate endProgressIndicator];
}

- (void)showBusStopsWithValue:(NSSet*)set
{
    [_delegate startProgressIndicator];
    [self loadStopDataAndShow:YES withSet:set];
    [_delegate endProgressIndicator];
}

- (void)showTerminalsWithValue:(NSSet*)set
{
    [_delegate startProgressIndicator];
    [self loadTerminalDataAndShow:YES withSet:set];
    [_delegate endProgressIndicator];
}

- (void)showRoutes
{
    [_delegate startProgressIndicator];
    [self loadRouteDataAndShow:YES];
    [_delegate endProgressIndicator];
}

- (void)dealloc
{
    [super dealloc];
    [_stops release];
    [_routes release];
    [stopsUrl release];
    [routesUrl release];
    _delegate = nil;
}

#pragma Private Methods
- (void)loadStopDataAndShow:(BOOL)show withSet:(NSSet*)set
{
    NSDictionary *dictonary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"plist"]];
    if (_stops != nil && show) {
        for (BusStop *busStop in _stops) {
            if (show && ([set anyObject] == nil || [set containsObject:[NSNumber numberWithInteger:[busStop.routes count]]]))
                [_delegate addBusStop:busStop];
        }
    } else if (_stops == nil) {
        KMLRoot *kmlStops = [KMLParser parseKMLAtURL:stopsUrl];
        if (kmlStops == nil)
            kmlStops = [KMLParser parseKMLAtPath:[[NSBundle mainBundle] pathForResource:@"Bus Stops" ofType:@"kml"]];
        NSMutableArray *mutableStops = [NSMutableArray array];
        for (KMLPlacemark *placemark in kmlStops.placemarks) {
            if (placemark.geometry && placemark.name) {
                BusStop *busStop = [[BusStop alloc] initWithTitle:placemark.name description:placemark.descriptionValue andLocation:(KMLPoint *)placemark.geometry];
                [mutableStops addObject:busStop];
                busStop.routes = (NSArray*)[dictonary objectForKey:[NSString stringWithFormat:@"%i",busStop.goTime]];
                if (show && ([set anyObject] == nil || [set containsObject:[NSNumber numberWithInteger:[busStop.routes count]]]))
                    [_delegate addBusStop:busStop];
                [busStop release];
            }
        }
        _stops = [[NSArray alloc] initWithArray:mutableStops];
    }
    [dictonary release];
}

- (void)loadTerminalDataAndShow:(BOOL)show withSet:(NSSet*)set
{
    for (BusStop *busStop in _stops) {
        if (show && ([set anyObject] == nil || [set containsObject:[NSNumber numberWithInteger:busStop.fcode]]))
            [_delegate addBusStop:busStop];
    }
}

- (void)loadRouteDataAndShow:(BOOL)show
{
    if (_routes != nil && show) {
        for (BusRoute *busRoute in _routes) {
            [_delegate addRoute:busRoute];
        }
    } else if (_routes == nil) {
        KMLRoot *kmlRoutes = [KMLParser parseKMLAtURL:routesUrl];
        if (!kmlRoutes)
            kmlRoutes = [KMLParser parseKMLAtPath:[[NSBundle mainBundle] pathForResource:@"Bus Routes" ofType:@"kml"]];
        NSMutableArray *mutableRoutes = [NSMutableArray array];
        for (KMLPlacemark *placemark in kmlRoutes.placemarks) {
            if (placemark.geometry && placemark.name) {
                BusRoute *busRoute = [[BusRoute alloc] initWithTitle:placemark.name description:placemark.descriptionValue andGeometries:(KMLMultiGeometry *)placemark.geometry];
                [mutableRoutes addObject:busRoute];
                if (show)
                    [_delegate addRoute:busRoute];
                [busRoute release];
            }
        }
        _routes = [[NSArray alloc] initWithArray:mutableRoutes];
    }
}

@end
