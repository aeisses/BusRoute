//
//  KeyView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-09-01.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "KeyView.h"

@implementation KeyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUpKey
{
    isActiveLineShown = YES;
    isStagingLineShown = YES;
    isReverseLineShown = YES;
    [self showLines];
}

- (void)showActiveLine:(BOOL)boolVar
{
    isActiveLineShown = boolVar;
    [self showLines];
}

- (void)showReverseLine:(BOOL)boolVar
{
    isReverseLineShown = boolVar;
    [self showLines];
}

- (void)dealloc
{
    [_activeLabel release]; _activeLabel = nil;
    [_stagingLabel release]; _stagingLabel = nil;
    [_reverseLabel release]; _reverseLabel = nil;
    [_backGroundImage release]; _backGroundImage = nil;
    [_linesImageView release]; _linesImageView = nil;
    [super dealloc];
}

#pragma Private Methods
- (void)showLines
{
    _linesImageView.image = nil;
    if (isActiveLineShown)
        [self drawLineFrom:(CGPoint){15,28} To:(CGPoint){60,28} withColor:[UIColor redColor]];
    if (isStagingLineShown)
        [self drawLineFrom:(CGPoint){15,68} To:(CGPoint){60,68} withColor:[UIColor blueColor]];
    if (isReverseLineShown)
        [self drawLineFrom:(CGPoint){15,108} To:(CGPoint){60,108} withColor:[UIColor greenColor]];
}

- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to withColor:(UIColor *)colour
{
    const CGFloat* components = CGColorGetComponents(colour.CGColor);
    UIGraphicsBeginImageContext(self.frame.size);
    [_linesImageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), from.x, from.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), to.x, to.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0 );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), (float)components[0], (float)components[1], (float)components[2], 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    _linesImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [self setAlpha:1.0];
    UIGraphicsEndImageContext();
}
@end
