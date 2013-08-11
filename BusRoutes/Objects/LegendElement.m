//
//  LegendElement.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "LegendElement.h"

@implementation LegendElement

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _title = title;
        _image = image;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
        imageView.frame = (CGRect){10,5,10,10};
        [self addSubview:imageView];
        [imageView release];
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){25,0,115,20}];
        label.text = _title;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [label release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_title release];
    [_image release];
}

@end
