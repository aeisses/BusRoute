//
//  DisplayTypeView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "DisplayTypeView.h"

@interface DisplayTypeView (PrivateMethods)
- (void)enableButtons;
- (void)disableButtons;
@end;

@implementation DisplayTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)buttonTouched:(id)sender
{
    [_delegate displayTypeButtonPressed:sender];
}

- (void)hideViewAtFrame:(CGRect)frame
{
    [self disableButtons];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self enableButtons];
    }];
}

- (void)showViewAtFrame:(CGRect)frame
{
    [self disableButtons];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished){
        [self enableButtons];
    }];
}

#pragma Private Methods
- (void)enableButtons
{
    _stopButton.enabled = _routeButton.enabled = YES;
}

- (void)disableButtons
{
    _stopButton.enabled = _routeButton.enabled =  NO;
}
@end
