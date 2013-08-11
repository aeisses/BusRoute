//
//  TerminalTable.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "TerminalTable.h"

@interface TerminalTable ()

@end

@implementation TerminalTable

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
    [super viewDidLoad];

    terminalArray = [[NSArray alloc] initWithObjects:
                     [[[TerminalNodeCell alloc] initWithTerminal:trbsin] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbsac] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbstmin] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbs] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbsshac] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbssh] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trpr] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbstmac] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbstm] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:trbsshin] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:tbrsml] autorelease],
                     [[[TerminalNodeCell alloc] initWithTerminal:fcodeall] autorelease],
                     nil];

    self.clearsSelectionOnViewWillAppear = NO;
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
    return [terminalArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = ((TerminalNodeCell*)[terminalArray objectAtIndex:indexPath.row]).title;
    cell.imageView.image = ((TerminalNodeCell*)[terminalArray objectAtIndex:indexPath.row]).image;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TerminalNodeCell *nodeCell = (TerminalNodeCell*)[terminalArray objectAtIndex:indexPath.row];
    if (nodeCell.terminal == fcodeall) {
        [_delegate touchedTerminalTableElement:-1];
        [_delegate clearLegend];
        for (int i=0; i<[terminalArray count]-1; i++) {
            TerminalNodeCell *cell = (TerminalNodeCell*)[terminalArray objectAtIndex:i];
            [_delegate addLegendElementWithTitle:cell.title andImage:cell.image];
        }
    } else {
        [_delegate touchedTerminalTableElement:indexPath.row];
        [_delegate addLegendElementWithTitle:nodeCell.title andImage:nodeCell.image];
    }
}

@end
