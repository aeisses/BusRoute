//
//  DrawingImageView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "DrawingImageView.h"

@implementation DrawingImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
        points = [[NSMutableArray alloc] initWithCapacity:0];
        lines = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [points release]; points = nil;
    [lines release]; lines = nil;
    [super dealloc];
}

- (void)clearLines
{
    [self clearLine];
    [lines release]; lines = nil;
    lines = [[NSMutableArray alloc] initWithCapacity:0];
    self.image = nil;
}

- (void)clearLine
{
    [points release]; points = nil;
    points = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)closeLine
{
    [lines addObject:points];
    [self clearLine];
}

- (void)addLineFrom:(CGPoint)drawingLastPoint To:(CGPoint)drawingPoint
{
    [self drawLineFrom:drawingLastPoint To:drawingPoint];
    if ([points count] == 0)
        [points addObject:[NSValue valueWithCGPoint:drawingLastPoint]];
    [points addObject:[NSValue valueWithCGPoint:drawingPoint]];
}

- (void)addBusStop:(BusStop*)busStop
{
    [annotations addObject:busStop];
}

- (void)removePoint:(CGPoint)removingPoint andBusStop:(BusStop*)busStop
{
    [annotations removeObject:busStop];
    self.image = nil;
    for (NSMutableArray *pointsArray in lines) {
        [pointsArray removeObject:[NSValue valueWithCGPoint:removingPoint]];
        CGPoint lastPoint = (CGPoint){0,0};
        for (NSValue *valuePoint in pointsArray) {
            if (lastPoint.x != 0 && lastPoint.y != 0) {
                CGPoint point = [valuePoint CGPointValue];
                [self drawLineFrom:lastPoint To:point];
            }
            lastPoint = [valuePoint CGPointValue];
        }
    }
}

- (BusRoute*)createBusRoute:(MKMapView*)mapView
{
    NSMutableArray *newLines = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *newPoints in lines) {
        CLLocationCoordinate2D *line = malloc(sizeof(CLLocationCoordinate2D) * [newPoints count]);
        for (int i = 0; i < [newPoints count]; i++) {
            line[i] = [mapView convertPoint:[(NSValue*)[newPoints objectAtIndex:i] CGPointValue] toCoordinateFromView:self];
        }
        [newLines insertObject:[MKPolyline polylineWithCoordinates:line count:[newPoints count]] atIndex:[newLines count]];
        free(line);
    }
    [self clearLines];
    return [[[BusRoute alloc] initWithLines:[NSArray arrayWithArray:newLines] andTitle:@""] autorelease];
}

#pragma Private Methods
- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), from.x, from.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), to.x, to.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0 );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    [self setAlpha:1.0];
    UIGraphicsEndImageContext();
}

@end
