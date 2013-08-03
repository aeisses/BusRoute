//
//  DisplayTypeView.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "HudDisplayButtonsView.h"

@interface HudDisplayButtonsView (PrivateMethods)

@end;

@implementation HudDisplayButtonsView

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
    isStopButtonEnabled = NO;
    isRouteButtonEnabled = YES;
    _stopButton.displayType = stops;
    _routeButton.displayType = routes;
}

- (IBAction)buttonTouched:(id)sender
{
    [_delegate displayButtonPressed:sender];
    if (isStopButtonEnabled) {
        isRouteButtonEnabled = YES;
        isStopButtonEnabled = NO;
    } else {
        isRouteButtonEnabled = NO;
        isStopButtonEnabled = YES;
    }
}

- (void)enableButtons
{
    _stopButton.enabled = isStopButtonEnabled;
    _routeButton.enabled = isRouteButtonEnabled;
}

- (void)disableButtons
{
    _stopButton.enabled = _routeButton.enabled =  NO;
}

- (void)dealloc
{
    [_stopButton release]; _stopButton = nil;
    [_routeButton release]; _routeButton = nil;
    [super dealloc];
}

@end
