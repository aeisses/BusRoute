//
//  InfoViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-18.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forInfo:(INFO)info
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _info = info;
        strings = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"]];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"String: %@",strings);
    NSDictionary *values;
    switch (_info) {
        case prune:
            values = [[NSDictionary alloc] initWithDictionary:[strings objectForKey:@"Prune"]];
            break;
    }
    NSLog(@"Value: %@",values);
    _viewTitle.text = [values objectForKey:@"Title"];
    _body.text = [values objectForKey:@"Description"];
    [values release];
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

- (IBAction)touchDontShowAgainButton:(id)sender
{
    _dontShowAgain.selected = YES;
    switch (self.info) {
        case prune:
            break;
    }
}

- (void)dealloc
{
    [strings release]; strings = nil;
    [_exitButton release]; _exitButton = nil;
    [_dontShowAgain release]; _dontShowAgain = nil;
    [_viewTitle release]; _viewTitle = nil;
    [_body release]; _body = nil;
    [super dealloc];
}

@end
