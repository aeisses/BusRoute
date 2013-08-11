//
//  TerminalTable.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-10.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalNodeCell.h"

@protocol TerminalTableDelegate <NSObject>
- (void)touchedTerminalTableElement:(NSInteger)element;
- (void)addLegendElementWithTitle:(NSString *)title andImage:(UIImage*)image;
- (void)clearLegend;
@end

@interface TerminalTable : UITableViewController
{
    NSArray *terminalArray;
}

@property (retain, nonatomic) id <TerminalTableDelegate> delegate;

@end
