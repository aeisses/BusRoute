//
//  LegendView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-05.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "LegendView.h"

@interface LegendView (PrivateMethods)
- (void)enableAllButtons;
- (void)disableAllButtons;
@end;

@implementation LegendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdDown:)];
        longPress.numberOfTouchesRequired = 1;
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)holdDown:(UILongPressGestureRecognizer*)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint startingPoint = [longPressGesture locationInView:self.superview];
            diffPoint = (CGPoint){self.center.x - startingPoint.x, self.center.y - startingPoint.y};
            self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            [self disableAllButtons];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [longPressGesture locationInView:self.superview];
            self.center = (CGPoint){currentPoint.x + diffPoint.x, currentPoint.y + diffPoint.y};
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.backgroundColor = [UIColor colorWithRed:207.0f/255.0f green:255.0f/255.0f blue:141.0f/255.0f alpha:1.0f];
            [self enableAllButtons];
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (IBAction)touchButton:(id)sender;
{

}

- (IBAction)touchExitButton:(id)sender
{
    [_delegate exitLegendView];
}

#pragma Private Methods
- (void)enableAllButtons
{
    _exitButton.enabled = _noGoTime.enabled = _oneRoute.enabled = _twoRoute.enabled = _threeRoute.enabled = _fourRoute.enabled = _fiveRoute.enabled = _sixRoute.enabled = _sevenRoute.enabled = _eighteenRoute.enabled = _nineRoute.enabled = _tenRoute.enabled = _elevenRoute.enabled = _twelveRoute.enabled = _thirteenRoute.enabled = _fourteenRoute.enabled = _fifteenRoute.enabled = _sixteenRoute.enabled = _seventeenRoute.enabled = _eighteenRoute.enabled = _nineteenRoute.enabled = _twentyRoute.enabled = YES;
}

- (void)disableAllButtons
{
    _exitButton.enabled = _noGoTime.enabled = _oneRoute.enabled = _twoRoute.enabled = _threeRoute.enabled = _fourRoute.enabled = _fiveRoute.enabled = _sixRoute.enabled = _sevenRoute.enabled = _eighteenRoute.enabled = _nineRoute.enabled = _tenRoute.enabled = _elevenRoute.enabled = _twelveRoute.enabled = _thirteenRoute.enabled = _fourteenRoute.enabled = _fifteenRoute.enabled = _sixteenRoute.enabled = _seventeenRoute.enabled = _eighteenRoute.enabled = _nineteenRoute.enabled = _twentyRoute.enabled = NO;
}

@end
