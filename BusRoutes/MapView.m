//
//  MapView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-22.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "MapView.h"

#define HALIFAX_LATITUDE_CENTRE 44.6479 // This is the offical centre of Halifax.
#define HALIFAX_LATITUDE_MAX 44.695 // This is max latitude, we need to shift a bit, halifax is not a square city.
#define HALIFAX_LONGITUDE -63.5744

#define HALIFAX_ZOOM_MAX 37500

@implementation MapView

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [super setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(HALIFAX_LATITUDE_MAX,HALIFAX_LONGITUDE), HALIFAX_ZOOM_MAX, HALIFAX_ZOOM_MAX) animated:NO];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}
 
@end
