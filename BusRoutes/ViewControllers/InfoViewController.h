//
//  InfoViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-27.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@protocol InfoViewControllerDelegate <NSObject>
- (void)positiveButtonTouchedForInfo:(INFO)info;
@end

@interface InfoViewController : UIViewController

@property (assign) INFO info;
@property (retain, nonatomic) IBOutlet UIButton *exitButton;
@property (retain, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextView *textBody;
@property (retain, nonatomic) IBOutlet UIButton *positiveButton;
@property (retain, nonatomic) id <InfoViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andType:(INFO)info;
- (IBAction)touchExitButton:(id)sender;
- (IBAction)touchCheckBoxButton:(id)sender;
- (IBAction)touchPositiveButton:(id)sender;

@end
