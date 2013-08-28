//
//  InfoViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-18.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@protocol PruneControllerDelegate <NSObject>
- (void)pruneRoutesMetroX:(BOOL)metroX andMetroLink:(BOOL)metroLink andExpressRoute:(BOOL)expressRoute;
@end

@interface PruneViewController : UIViewController
{
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
@property (retain, nonatomic) id <PruneControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)touchExitButton:(id)sender;
- (IBAction)touchPruneButton:(id)sender;
- (IBAction)touchRemoveRoutesButton:(id)sender;

@end

@interface PruneViewController (PrivateMethods)
@end