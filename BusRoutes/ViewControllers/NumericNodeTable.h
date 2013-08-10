//
//  BusStopsViewController.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NumericNode.h"
#import "NumericNodeCell.h"

@protocol NumericNodeTableDelegate <NSObject>
- (void)touchedTableElement:(NSInteger)element;
@end

@interface NumericNodeTable : UITableViewController
{
    NSArray *nodeTypes;
}

@property (retain, nonatomic) id <NumericNodeTableDelegate> delegate;

@end
