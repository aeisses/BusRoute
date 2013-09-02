//
//  SaveViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-13.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController ()

@end

@implementation SaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchExitButton:(id)sender
{
    [self exitAndClearWindow];
}

- (IBAction)touchIsReversedButton:(id)sender
{
    _isReversedButton.selected = !_isReversedButton.selected;
}

- (IBAction)touchCreateButton:(id)sender
{
    if ([_name.text isEqualToString:@""] || [_number.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"A Route has to have a Name and a Number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSArray *objects = [[NSArray alloc] initWithObjects:_name.text,_number.text,_description.text,[NSNumber numberWithBool:_isReversedButton.selected],nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"Name",@"Number",@"Description",@"isReverse",nil];
    NSDictionary *values = [[NSDictionary alloc] initWithObjects:objects
                                                         forKeys:keys];
    [objects release];
    [keys release];
    [_delegate createRouteWithValue:values];
    [values release];
    [self exitAndClearWindow];
}

- (void)dealloc
{
    [_exitButton release]; _exitButton = nil;
    [_isReversedButton release]; _isReversedButton = nil;
    [_createButton release]; _createButton = nil;
    [_name release]; _name = nil;
    [_number release]; _number = nil;
    [_description release]; _description = nil;
    _delegate = nil;
    [super dealloc];
}

#pragma Private Methods
- (void)exitAndClearWindow
{
    __block typeof(self) block_self = self;
    [self dismissViewControllerAnimated:YES completion:^{
        block_self.name.text = @"";
        block_self.number.text = @"";
        block_self.description.text = @"";
    }];
}

@end
