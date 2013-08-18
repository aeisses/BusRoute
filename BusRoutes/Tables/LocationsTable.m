//
//  LocationsTableViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "LocationsTable.h"

@interface LocationsTable ()

@end

@implementation LocationsTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    locations = [[NSArray alloc] initWithObjects:
                 @"HRM",
                 @"Halifax",
                 @"Dartmouth",
                 @"Cole Harbour",
                 @"Sackville",
                 @"Bedford",
                 @"Clayton Park",
                 @"Fairview",
                 @"Spryfield",
                 @"Free Hand",
                 @"Lock Zoom",
                 nil];
    
    self.clearsSelectionOnViewWillAppear = NO;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [locations objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [_delegate touchedLocationTable:HRM];
            break;
        case 1:
            [_delegate touchedLocationTable:Halifax];
            break;
        case 2:
            [_delegate touchedLocationTable:Dartmouth];
            break;
        case 3:
            [_delegate touchedLocationTable:ColeHarbour];
            break;
        case 4:
            [_delegate touchedLocationTable:Sackville];
            break;
        case 5:
            [_delegate touchedLocationTable:Bedford];
            break;
        case 6:
            [_delegate touchedLocationTable:ClaytonPark];
            break;
        case 7:
            [_delegate touchedLocationTable:Fairview];
            break;
        case 8:
            [_delegate touchedLocationTable:Spryfield];
            break;
        case 9:
            [_delegate freeZoom];
            break;
        case 10:
            [_delegate lockZoom];
            break;
    }
}

@end
