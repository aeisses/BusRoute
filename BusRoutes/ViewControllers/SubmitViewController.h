//
//  SubmitViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 2013-10-27.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubmitViewControllerDelegate <NSObject>

@end

@interface SubmitViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *exitButton;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) id <SubmitViewControllerDelegate> delegate;

- (IBAction)exitButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;

@end
