//
//  MovementButtonView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-25.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "BurrowZoomButtonsView.h"

@interface BurrowZoomButtonsView (PrivateMethods)
- (void)enableButtons;
- (void)disableButtons;
@end;

@implementation BurrowZoomButtonsView

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
    _coleHarbour.region = ColeHarbour;
    _sackville.region = Sackville;
    _bedford.region = Bedford;
    _claytonPark.region = ClaytonPark;
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
    [_delegate burrowZoomButtonTouched:sender];
}

- (void)dealloc
{
    [_hrm release]; _hrm = nil;
    [_halifax release]; _halifax = nil;
    [_dartmouth release]; _dartmouth = nil;
    [_coleHarbour release]; _coleHarbour = nil;
    [_sackville release]; _sackville = nil;
    [_bedford release]; _bedford = nil;
    [_claytonPark release]; _claytonPark = nil;
    [_fairview release]; _fairview = nil;
    [_spryfield release]; _spryfield = nil;
    _delegate = nil;
    [super dealloc];
}

#pragma Private Methods
- (void)enableButtons
{
    _hrm.enabled = _halifax.enabled = _dartmouth.enabled =
    _coleHarbour.enabled = _sackville.enabled = _bedford.enabled =
    _claytonPark.enabled = _fairview.enabled = _spryfield.enabled = YES;
}

- (void)disableButtons
{
    _hrm.enabled = _halifax.enabled = _dartmouth.enabled =
    _coleHarbour.enabled = _sackville.enabled = _bedford.enabled =
    _claytonPark.enabled = _fairview.enabled = _spryfield.enabled = NO;
}

@end
