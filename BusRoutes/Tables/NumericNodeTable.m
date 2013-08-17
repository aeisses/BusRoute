//
//  BusStopsViewController.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "NumericNodeTable.h"

@interface NumericNodeTable ()

@end

@implementation NumericNodeTable

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
	// Do any additional setup after loading the view.
    nodeTypes = [[NSArray alloc] initWithObjects:
                 [[[NumericNodeCell alloc] initWithNumericNode:zero] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:one] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:two] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:three] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:four] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:five] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:six] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:seven] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:eight] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:nine] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:ten] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:eleven] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:twelve] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:thirteen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:fourteen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:fifteen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:sixteen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:seventeen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:eighteen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:nineteen] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:twenty] autorelease],
                 [[[NumericNodeCell alloc] initWithNumericNode:all] autorelease],
                 nil];

    self.clearsSelectionOnViewWillAppear = NO;
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nodeTypes count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = ((NumericNodeCell*)[nodeTypes objectAtIndex:indexPath.row]).title;
    cell.imageView.image = ((NumericNodeCell*)[nodeTypes objectAtIndex:indexPath.row]).image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NumericNodeCell *nodeCell = (NumericNodeCell*)[nodeTypes objectAtIndex:indexPath.row];
    if (nodeCell.node == all) {
        [_delegate touchedTableElement:-1];
        [_delegate clearLegend];
        for (int i=0; i<[nodeTypes count]-1; i++) {
            NumericNodeCell *cell = (NumericNodeCell*)[nodeTypes objectAtIndex:i];
            [_delegate addLegendElementWithTitle:cell.title andImage:cell.image];
        }
    } else {
        [_delegate touchedTableElement:indexPath.row];
        [_delegate addLegendElementWithTitle:nodeCell.title andImage:nodeCell.image];
    }
}

- (void)dealloc
{
    [super dealloc];
    [nodeTypes release];
}

@end
