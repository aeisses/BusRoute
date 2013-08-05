//
//  MovementButtonView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-25.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovementButton.h"

@protocol HudZoomButtonsViewDelegate <NSObject>
- (void)zoomButtonTouched:(id)sender;
@end

@interface HudZoomButtonsView : UIView

@property (retain, nonatomic) IBOutlet MovementButton *hrm;
@property (retain, nonatomic) IBOutlet MovementButton *halifax;
@property (retain, nonatomic) IBOutlet MovementButton *dartmouth;
@property (retain, nonatomic) IBOutlet MovementButton *coleHarbour;
@property (retain, nonatomic) IBOutlet MovementButton *sackville;
@property (retain, nonatomic) IBOutlet MovementButton *bedford;
@property (retain, nonatomic) IBOutlet MovementButton *claytonPark;
@property (retain, nonatomic) IBOutlet MovementButton *fairview;
@property (retain, nonatomic) IBOutlet MovementButton *spryfield;

@property (retain, nonatomic) id <HudZoomButtonsViewDelegate> delegate;

- (void)setButtons;
- (IBAction)touchUp:(id)sender;
- (void)enableButtons;
- (void)disableButtons;

@end
