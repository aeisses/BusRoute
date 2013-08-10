//
//  NumericNodeCell.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface NumericNodeCell : NSObject

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *title;
@property (readonly) NUMERICNODE node;

- (id)initWithNumericNode:(NUMERICNODE)numericNode;

@end
