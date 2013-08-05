//
//  DisplayTypeView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayButton.h"

@protocol HudDisplayButtonViewDelegate <NSObject>
- (void)displayButtonPressed:(id)sender;
@end

@interface HudDisplayButtonsView : UIView
{
    BOOL isStopButtonEnabled;
    BOOL isRouteButtonEnabled;
}

@property (retain, nonatomic) IBOutlet DisplayButton *stopButton;
@property (retain, nonatomic) IBOutlet DisplayButton *routeButton;

@property (retain, nonatomic) id <HudDisplayButtonViewDelegate> delegate;

- (void)setButtons;
- (IBAction)buttonTouched:(id)sender;
- (void)enableButtons;
- (void)disableButtons;

@end
