//
//  KeyView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-09-01.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface KeyView : UIView
{
    BOOL isActiveLineShown;
    BOOL isReverseLineShown;
    BOOL isStagingLineShown;
}

@property (retain, nonatomic) IBOutlet UILabel *activeLabel;
@property (retain, nonatomic) IBOutlet UILabel *stagingLabel;
@property (retain, nonatomic) IBOutlet UILabel *reverseLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (retain, nonatomic) IBOutlet UIImageView *linesImageView;

- (void)setUpKey;
- (void)showActiveLine:(BOOL)boolVar;
- (void)showReverseLine:(BOOL)boolVar;

@end

@interface KeyView (PrivateMethods)
- (void)drawLineFrom:(CGPoint)from To:(CGPoint)to withColor:(UIColor*)colour;
- (void)showLines;
@end