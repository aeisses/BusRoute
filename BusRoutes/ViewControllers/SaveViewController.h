//
//  SaveViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveViewControllerDelegate <NSObject>
- (void)createRouteWithValue:(NSDictionary*)values;
@end

@interface SaveViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *exitButton;
@property (retain, nonatomic) IBOutlet UIButton *isReversedButton;
@property (retain, nonatomic) IBOutlet UIButton *createButton;
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextField *number;
@property (retain, nonatomic) IBOutlet UITextView *description;
@property (retain, nonatomic) id <SaveViewControllerDelegate> delegate;

- (IBAction)touchExitButton:(id)sender;
- (IBAction)touchIsReversedButton:(id)sender;
- (IBAction)touchCreateButton:(id)sender;

@end

@interface SaveViewController (PrivateMethods)
- (void)exitAndClearWindow;
@end