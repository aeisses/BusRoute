//
//  PreloadedRoute.m
//  BusRoutes
//
//  Created by Aaron Eisses on 2013-10-27.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "PreloadedRoute.h"

@implementation PreloadedRoute

- (id)initWithTitle:(NSString*)title forward:(NSArray*)forward andReverse:(NSArray*)reverse
{
    if (self = [super init])
    {
        _title = [title retain];
        _forward = [forward retain];
        _reverse = [reverse retain];
    }
    return self;
}

- (void)dealloc
{
    [_title release]; _title = nil;
    [_forward release]; _forward = nil;
    [_reverse release]; _reverse = nil;
    [super dealloc];
}

@end
