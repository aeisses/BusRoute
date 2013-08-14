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
        [self setUserInteractionEnabled:YES];
        saveButton = [[UIButton alloc] initWithFrame:(CGRect){20,700,40,40}];
        [saveButton addTarget:self action:@selector(touchSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setImage:[UIImage imageNamed:@"saveButton.png"] forState:UIControlStateNormal];
        [self addSubview:saveButton];
        clearButton = [[UIButton alloc] initWithFrame:(CGRect){960,700,40,40}];
        [clearButton setImage:[UIImage imageNamed:@"clearButton.png"] forState:UIControlStateNormal];
        [self addSubview:clearButton];
        [clearButton addTarget:self action:@selector(touchClearButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchSaveButton:(id)sender
{
    [_delegate saveButtonTouched];
}

- (void)touchClearButton
{
    self.image = nil;
}

- (void)addLineFrom:(CGPoint)drawingLastPoint To:(CGPoint)drawingPoint
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawingLastPoint.x, drawingLastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), drawingPoint.x, drawingPoint.y);
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
