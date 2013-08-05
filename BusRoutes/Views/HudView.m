//
//  HudView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-02.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "HudView.h"

@implementation HudView

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        zoomButtonsView = [[[[NSBundle mainBundle] loadNibNamed:@"HudZoomButtonsView" owner:self options:nil] objectAtIndex:0] retain];
        zoomButtonsView.delegate = self;
        zoomButtonsView.frame = (CGRect){
            self.frame.size.width-zoomButtonsView.frame.size.width,
            HEIGHT_ZERO,
            zoomButtonsView.frame.size};
        [zoomButtonsView setButtons];
        [self addSubview:zoomButtonsView];
        
        dislpayButtonsView = [[[[NSBundle mainBundle] loadNibNamed:@"HudDisplayButtonsView" owner:self options:nil] objectAtIndex:0] retain];
        dislpayButtonsView.delegate = self;
        dislpayButtonsView.frame = (CGRect){
            WIDTH_ZERO,
            HEIGHT_ZERO,
            dislpayButtonsView.frame.size
        };
        [dislpayButtonsView setButtons];
        [self addSubview:dislpayButtonsView];
        
        stopsButtonsView = [[[[NSBundle mainBundle] loadNibNamed:@"HudStopsButtonsView" owner:self options:nil] objectAtIndex:0] retain];
        stopsButtonsView.delegate = self;
        stopsButtonsView.center = (CGPoint){self.frame.size.width/2,50};
        [stopsButtonsView setButtons];
        [self addSubview:stopsButtonsView];
    }
    return self;
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self setImage:[UIImage imageNamed:@"landscapeHudView"]];
        if (self.hidden) {
            self.frame = (CGRect){0,0,1024,500};
        } else {
            self.frame = (CGRect){0,-500,1024,500};
        }
        stopsButtonsView.center = (CGPoint){LANDSCAPE_WIDTH/2,50};
        zoomButtonsView.frame = (CGRect){
            LANDSCAPE_WIDTH-150,
            zoomButtonsView.frame.origin.y,
            zoomButtonsView.frame.size};
    } else if (orientation == UIInterfaceOrientationPortrait) {
        [self setImage:[UIImage imageNamed:@"portraitHudView"]];
        if (self.hidden) {
            self.frame = (CGRect){0,0,768,500};
        } else {
            self.frame = (CGRect){0,-500,768,500};
        }
        stopsButtonsView.center = (CGPoint){PORTRAIT_WIDTH/2,50};
        zoomButtonsView.frame = (CGRect){
            PORTRAIT_WIDTH-150,
            zoomButtonsView.frame.origin.y,
            zoomButtonsView.frame.size};
    }
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = (CGRect){
            self.frame.origin.x,
            HEIGHT_ZERO-self.frame.size.height,
            self.frame.size
        };
    } completion:^(BOOL finished) {
        [zoomButtonsView disableButtons];
        [dislpayButtonsView disableButtons];
    }];
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = (CGRect){
            self.frame.origin.x,
            HEIGHT_ZERO,
            self.frame.size
        };
    } completion:^(BOOL finished) {
        [zoomButtonsView enableButtons];
        [dislpayButtonsView enableButtons];
    }];
}

- (void)dealloc
{
    [zoomButtonsView release]; zoomButtonsView = nil;
    [dislpayButtonsView release]; dislpayButtonsView = nil;
    [stopsButtonsView release]; stopsButtonsView = nil;
    [super dealloc];
}

#pragma HudZoomButtonsViewDelegate Methods
- (void)zoomButtonTouched:(id)sender
{
    [_delegate zoomButtonTouched:sender];
}

#pragma HudDisplayButtonViewDelegate Methods
- (void)displayButtonPressed:(id)sender
{
    [_delegate displayButtonPressed:sender];
}

#pragma HudStopsButtonViewDelegate Methods
- (void)stopsButtonPressed:(id)sender
{
    [_delegate stopsButtonPressed:sender];
}

@end
