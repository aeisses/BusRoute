//
//  LegendView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-05.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LegendViewDelegate <NSObject>
- (void)showNumberOfRoutes:(NSInteger)num;
- (void)exitLegendView;
@end

@interface LegendView : UIView
{
    UILongPressGestureRecognizer *longPress;
    CGPoint diffPoint;
}

@property (retain, nonatomic) IBOutlet UIButton *noGoTime;
@property (retain, nonatomic) IBOutlet UIButton *oneRoute;
@property (retain, nonatomic) IBOutlet UIButton *twoRoute;
@property (retain, nonatomic) IBOutlet UIButton *threeRoute;
@property (retain, nonatomic) IBOutlet UIButton *fourRoute;
@property (retain, nonatomic) IBOutlet UIButton *fiveRoute;
@property (retain, nonatomic) IBOutlet UIButton *sixRoute;
@property (retain, nonatomic) IBOutlet UIButton *sevenRoute;
@property (retain, nonatomic) IBOutlet UIButton *eightRoute;
@property (retain, nonatomic) IBOutlet UIButton *nineRoute;
@property (retain, nonatomic) IBOutlet UIButton *tenRoute;
@property (retain, nonatomic) IBOutlet UIButton *elevenRoute;
@property (retain, nonatomic) IBOutlet UIButton *twelveRoute;
@property (retain, nonatomic) IBOutlet UIButton *thirteenRoute;
@property (retain, nonatomic) IBOutlet UIButton *fourteenRoute;
@property (retain, nonatomic) IBOutlet UIButton *fifteenRoute;
@property (retain, nonatomic) IBOutlet UIButton *sixteenRoute;
@property (retain, nonatomic) IBOutlet UIButton *seventeenRoute;
@property (retain, nonatomic) IBOutlet UIButton *eighteenRoute;
@property (retain, nonatomic) IBOutlet UIButton *nineteenRoute;
@property (retain, nonatomic) IBOutlet UIButton *twentyRoute;

@property (retain, nonatomic) IBOutlet UIButton *exitButton;

@property (retain, nonatomic) id <LegendViewDelegate> delegate;

- (IBAction)touchButton:(id)sender;
- (IBAction)touchExitButton:(id)sender;

@end
