//
//  DrawingImageView.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawingImageViewDelegate <NSObject>
- (void)saveButtonTouched;
@end

@interface DrawingImageView : UIImageView
{
    UIButton *saveButton;
    UIButton *clearButton;
}

@property (retain, nonatomic) id <DrawingImageViewDelegate> delegate;

- (void)addLineFrom:(CGPoint)drawingLastPoint To:(CGPoint)drawingPoint;

@end
