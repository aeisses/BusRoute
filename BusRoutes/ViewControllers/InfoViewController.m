//
//  InfoViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-27.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andType:(INFO)info
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _info = info;
    }
    return self;
}

- (void)viewDidLoad
{
    switch (_info) {
        case reverse:
        {
            _titleLabel.text = @"Reverse";
            _textBody.text = @"Most bus routes move in both directions, this function will attempt to take the existing bus route and reverse it, find the stops on the other side of the road. If you choose to do this action please check the route closely to make sure all the correct stops have been added and not incorrect stops have been added.";
            [_positiveButton setTitle:@"Reverse" forState:UIControlStateNormal];
        }
            break;
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchExitButton:(id)sender
{
    if (_checkBoxButton.selected) {
        switch (_info) {
            case reverse:
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ReverseInfoWindow"];
                break;
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)touchCheckBoxButton:(id)sender
{
    _checkBoxButton.selected = !_checkBoxButton.selected;
}

- (IBAction)touchPositiveButton:(id)sender
{
    if (_checkBoxButton.selected) {
        switch (_info) {
            case reverse:
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ReverseInfoWindow"];
                break;
        }
    }
    [_delegate positiveButtonTouchedForInfo:_info];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)dealloc
{
    [_exitButton release]; _exitButton = nil;
    [_checkBoxButton release]; _checkBoxButton = nil;
    [_titleLabel release]; _titleLabel = nil;
    [_textBody release]; _textBody = nil;
    [_positiveButton release]; _positiveButton = nil;
    _delegate = nil;
    [super dealloc];
}

@end
