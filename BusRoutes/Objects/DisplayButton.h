//
//  DisplayButton.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-03.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    stops,
    routes
} DISPLAYTYPE;

@interface DisplayButton : UIButton

@property (assign, nonatomic) DISPLAYTYPE displayType;

@end
