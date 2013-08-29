//
//  InfoViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-18.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "PruneViewController.h"

@implementation PruneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    NSDictionary *strings = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"]];
    NSDictionary *values = [[NSDictionary alloc] initWithDictionary:[strings objectForKey:@"Prune"]];
    _viewTitle.text = [values objectForKey:@"Title"];
    _body.text = [values objectForKey:@"Description"];
    [values release];
    [strings release];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchExitButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)touchPruneButton:(id)sender
{
    [_delegate pruneRoutesMetroX:_metroXButton.selected andMetroLink:_metroLinkButton.selected andExpressRoute:_expressRouteButton.selected];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)touchRemoveRoutesButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
}

- (void)dealloc
{
    [_exitButton release]; _exitButton = nil;
    [_pruneButton release]; _pruneButton = nil;
    [_metroXButton release]; _metroXButton = nil;
    [_metroLinkButton release]; _metroLinkButton = nil;
    [_expressRouteButton release]; _expressRouteButton = nil;
    [_dontShowAgain release]; _dontShowAgain = nil;
    [_viewTitle release]; _viewTitle = nil;
    [_body release]; _body = nil;
    _delegate = nil;
    [super dealloc];
}

@end