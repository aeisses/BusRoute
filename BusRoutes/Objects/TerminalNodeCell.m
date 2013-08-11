//
//  TerminalNodeCell.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "TerminalNodeCell.h"

@implementation TerminalNodeCell

- (id)initWithTerminal:(FCODE)terminalNode
{
    self = [super init];
    if (self) {
        _image = [Utils getImageForTerminal:terminalNode];
        _title = [Utils getTitleForTerminal:terminalNode];
        _terminal = terminalNode;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_image release]; _image = nil;
    [_title release]; _title = nil;
}

@end
