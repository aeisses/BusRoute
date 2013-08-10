//
//  TerminalNodeCell.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@interface TerminalNodeCell : NSObject

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *title;
@property (readonly) FCODE terminal;

- (id)initWithTerminal:(FCODE)terminalNode;

@end
