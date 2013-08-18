//
//  DrawingImageView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusRoute.h"

@interface DrawingImageView : UIImageView
{
    NSMutableArray *lines;
    NSMutableArray *points;
}

- (void)clearLines;
- (void)clearLine;
- (void)closeLine;
- (void)addLineFrom:(CGPoint)drawingLastPoint To:(CGPoint)drawingPoint;
- (void)removePoint:(CGPoint)removingPoint;
- (BusRoute*)createBusRoute:(MKMapView*)mapView;

@end

@interface DrawingImageView (PrivateMethods)
- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to;
@end
