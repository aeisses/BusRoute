//
//  HudStopsButtonsView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-03.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "HudStopsButtonsView.h"

@implementation HudStopsButtonsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setButtons
{
    _button.stopType = duplication;
    _legend.stopType = legend;
}

- (IBAction)touchButton:(id)sender
{
    [_delegate stopsButtonPressed:sender];
}

@end
