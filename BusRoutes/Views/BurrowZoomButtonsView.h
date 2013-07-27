//
//  MovementButtonView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-25.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovementButton.h"

@protocol MovementButtonViewDelegate <NSObject>
- (void)buttonTouched:(id)sender;
@end

@interface BurrowZoomButtonsView : UIView

@property (retain, nonatomic) IBOutlet MovementButton *hrm;
@property (retain, nonatomic) IBOutlet MovementButton *halifax;
@property (retain, nonatomic) IBOutlet MovementButton *dartmouth;
@property (retain, nonatomic) IBOutlet MovementButton *coleHarbour;
@property (retain, nonatomic) IBOutlet MovementButton *sackville;
@property (retain, nonatomic) IBOutlet MovementButton *bedford;
@property (retain, nonatomic) IBOutlet MovementButton *claytonPark;
@property (retain, nonatomic) IBOutlet MovementButton *fairview;
@property (retain, nonatomic) IBOutlet MovementButton *spryfield;

@property (retain, nonatomic) id <MovementButtonViewDelegate> delegate;

- (void)setButtons;
- (void)hideViewAtFrame:(CGRect)frame;
- (void)showViewAtFrame:(CGRect)frame;
- (IBAction)touchUp:(id)sender;

@end
