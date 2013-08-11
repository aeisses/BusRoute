//
//  LegendElement.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegendElement : UIView

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *title;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title andImage:(UIImage*)image;

@end
