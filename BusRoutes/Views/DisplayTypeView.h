//
//  DisplayTypeView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisplayTypeViewDelegate <NSObject>
- (void)displayTypeButtonPressed:(id)sender;
@end

@interface DisplayTypeView : UIView

@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UIButton *routeButton;

@property (retain, nonatomic) id <DisplayTypeViewDelegate> delegate;

- (void)setButtons;
- (void)hideViewAtFrame:(CGRect)frame;
- (void)showViewAtFrame:(CGRect)frame;
- (IBAction)buttonTouched:(id)sender;

@end
