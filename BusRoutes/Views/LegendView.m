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
        elementArray = [[NSMutableArray alloc] initWithCapacity:0];
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

- (void)cleanLegend
{
    for (int i=0; i<elementArray.count; i++) {
        [((UIView*)[elementArray objectAtIndex:i]) removeFromSuperview];
    }
    [elementArray release];
    elementArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.frame = (CGRect){self.frame.origin.x,self.frame.origin.y,139,(CELLWDITH*elementArray.count)+MODIFIER+20};
}

- (void)addLegendElement:(NSString *)title andImage:(UIImage*)image
{
    LegendElement *element = [[LegendElement alloc] initWithFrame:(CGRect){0,(CELLWDITH*elementArray.count)+MODIFIER,139,20} andTitle:title andImage:image];
    [elementArray addObject:element];
    self.frame = (CGRect){self.frame.origin.x,self.frame.origin.y,139,(CELLWDITH*elementArray.count)+MODIFIER+20};
    [self addSubview:element];
    [element release];
}

- (IBAction)touchExitButton:(id)sender
{
    [_delegate exitLegendView];
}

- (void)dealloc
{
    [super dealloc];
    [elementArray release];
}

#pragma Private Methods
- (void)enableAllButtons
{
    _exitButton.enabled = YES;
}

- (void)disableAllButtons
{
    _exitButton.enabled = NO;
}

@end
