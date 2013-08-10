//
//  NumericNodeCell.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "NumericNodeCell.h"

@implementation NumericNodeCell

- (id)initWithNumericNode:(NUMERICNODE)numericNode
{
    self = [super init];
    if (self) {
        _image = [Utils getImageForNumericNode:numericNode];
        _title = [Utils getTitleForNumericNode:numericNode];
        _node = numericNode;
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
