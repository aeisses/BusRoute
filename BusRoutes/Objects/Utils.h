//
//  Utils.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface Utils : NSObject

+ (UIImage*)getImageForNumericNode:(NUMERICNODE)numericNode;
+ (NSString*)getTitleForNumericNode:(NUMERICNODE)numericNode;

@end
