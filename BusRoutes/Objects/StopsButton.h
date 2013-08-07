//
//  StopsButton.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-05.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    duplication,
    legend,
    terminal
} STOPTYPE;

@interface StopsButton : UIButton

@property (assign, nonatomic) STOPTYPE stopType;
@end
