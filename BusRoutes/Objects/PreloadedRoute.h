//
//  PreloadedRoute.h
//  BusRoutes
//
//  Created by Aaron Eisses on 2013-10-27.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreloadedRoute : NSObject

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSArray *forward;
@property (retain, nonatomic) NSArray *reverse;

- (id)initWithTitle:(NSString*)title forward:(NSArray*)forward andReverse:(NSArray*)reverse;

@end
