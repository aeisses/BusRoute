//
//  HudView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-02.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HudZoomButtonsView.h"
#import "HudDisplayButtonsView.h"
#import "HudStopsButtonsView.h"

#define LANDSCAPE_WIDTH 1024
#define PORTRAIT_WIDTH  768
#define HEIGHT_ZERO     0
#define WIDTH_ZERO      0

@protocol HudViewDelegate <NSObject>
- (void)zoomButtonTouched:(id)sender;
- (void)displayButtonPressed:(id)sender;
- (void)stopsButtonPressed:(id)sender;
@end

@interface HudView : UIImageView <HudDisplayButtonViewDelegate,HudZoomButtonsViewDelegate,HudStopsButtonViewDelegate>
{
    HudDisplayButtonsView *dislpayButtonsView;
    HudZoomButtonsView *zoomButtonsView;
    HudStopsButtonsView *stopsButtonsView;
}

@property (retain, nonatomic) id <HudViewDelegate> delegate;

- (void)setOrientation:(UIInterfaceOrientation)orientation;
- (void)hide;
- (void)show;

@end
