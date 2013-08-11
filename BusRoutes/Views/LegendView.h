//
//  LegendView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-05.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegendElement.h"

#define MODIFIER 30
#define CELLWDITH 20

@protocol LegendViewDelegate <NSObject>
- (void)exitLegendView;
@end

@interface LegendView : UIView
{
    UILongPressGestureRecognizer *longPress;
    CGPoint diffPoint;
    NSMutableArray *elementArray;
}

@property (retain, nonatomic) IBOutlet UIButton *exitButton;

@property (retain, nonatomic) id <LegendViewDelegate> delegate;

- (IBAction)touchExitButton:(id)sender;
- (void)cleanLegend;
- (void)addLegendElement:(NSString *)title andImage:(UIImage*)image;

@end
