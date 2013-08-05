//
//  HudStopsButtonsView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-03.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HudStopsButtonViewDelegate <NSObject>
- (void)stopsButtonPressed:(id)sender;
@end

@interface HudStopsButtonsView : UIView
{
    
}

@property (retain, nonatomic) IBOutlet UIButton *button;

@property (retain, nonatomic) id <HudStopsButtonViewDelegate> delegate;

- (void)setButtons;

@end
