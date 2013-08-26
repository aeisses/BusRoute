//
//  InfoViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-18.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@interface InfoViewController : UIViewController
{
    NSDictionary *strings;
}

@property (retain, nonatomic) IBOutlet UIButton *exitButton;
@property (retain, nonatomic) IBOutlet UIButton *pruneButton;
@property (retain, nonatomic) IBOutlet UIButton *metroXButton;
@property (retain, nonatomic) IBOutlet UIButton *metroLinkButton;
@property (retain, nonatomic) IBOutlet UIButton *expressRouteButton;
@property (retain, nonatomic) IBOutlet UIButton *dontShowAgain;
@property (retain, nonatomic) IBOutlet UILabel *viewTitle;
@property (retain, nonatomic) IBOutlet UITextView *body;
@property (readwrite, nonatomic) INFO info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forInfo:(INFO)info;
- (IBAction)touchExitButton:(id)sender;
- (IBAction)touchPruneButton:(id)sender;
- (IBAction)touchRemoveRoutesButton:(id)sender;
- (IBAction)touchDontShowAgainButton:(id)sender;

@end

@interface InfoViewController (PrivateMethods)
@end