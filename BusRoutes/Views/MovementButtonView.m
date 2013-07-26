//
//  MovementButtonView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-25.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "MovementButtonView.h"

// TODO: This might get changed to a ViewController

@interface MovementButtonView (PrivateMethods)
- (void)enableButtons;
- (void)disableButtons;
@end;

@implementation MovementButtonView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setButtons
{
    _hrm.region = HRM;
    _halifax.region = Halifax;
    _dartmouth.region = Dartmouth;
    _coleharbour.region = Coleharbour;
    _sackville.region = Sackville;
    _bedford.region = Bedford;
    _claytonpark.region = Claytonpark;
    _fairview.region = Fairview;
    _spryfield.region = Spryfield;
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

- (IBAction)touchUp:(id)sender
{
    [_delegate buttonTouched:sender];
}

- (void)dealloc
{
    [_hrm release]; _hrm = nil;
    [_halifax release]; _halifax = nil;
    [_dartmouth release]; _dartmouth = nil;
    [_coleharbour release]; _coleharbour = nil;
    [_sackville release]; _sackville = nil;
    [_bedford release]; _bedford = nil;
    [_claytonpark release]; _claytonpark = nil;
    [_fairview release]; _fairview = nil;
    [_spryfield release]; _spryfield = nil;
    _delegate = nil;
    [super dealloc];
}

#pragma Private Methods
- (void)enableButtons
{
    _hrm.enabled = _halifax.enabled = _dartmouth.enabled =
    _coleharbour.enabled = _sackville.enabled = _bedford.enabled =
    _claytonpark.enabled = _fairview.enabled = _spryfield.enabled = YES;
}

- (void)disableButtons
{
    _hrm.enabled = _halifax.enabled = _dartmouth.enabled =
    _coleharbour.enabled = _sackville.enabled = _bedford.enabled =
    _claytonpark.enabled = _fairview.enabled = _spryfield.enabled = NO;
}

@end
