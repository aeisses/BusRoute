//
//  Utils.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIImage*)getImageForTerminal:(FCODE)terminal
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"terminal%i@2x.png",terminal]];
}

+ (NSString*)getTitleForTerminal:(FCODE)terminal
{
    switch (terminal) {
        case trbsin:
            return @"Bus Stop Inaccessible";
            break;
        case trbsac:
            return @"Bus Stop Accessible";
            break;
        case trbstmin:
            return @"Bus Terminal Inaccessible";
            break;
        case trbs:
            return @"Bus Stop Non-Standard";
            break;
        case trbsshac:
            return @"Bus Stop Shelter Accessible";
            break;
        case trbssh:
            return @"Bus Stop Shelter Non-Standard";
            break;
        case trpr:
            return @"Park and Ride";
            break;
        case trbstmac:
            return @"Bus Terminal Accessible";
            break;
        case trbstm:
            return @"Bus Terminal Non-Standard";
            break;
        case trbsshin:
            return @"Bus Stop Shelter Inaccessible";
            break;
        case tbrsml:
            return @"Metro Link";
            break;
        case fcodeall:
            return @"All Terminals";
            break;
    }
    return @"";
}

+ (UIImage*)getImageForNumericNode:(NUMERICNODE)numericNode
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"dot%i@2x.png",numericNode]];
}

+ (NSString*)getTitleForNumericNode:(NUMERICNODE)numericNode
{
    switch (numericNode) {
        case zero:
            return @"No Routes Per Stop";
            break;
        case one:
            return @"One Routes Per Stop";
            break;
        case two:
            return @"Two Routes Per Stop";
            break;
        case three:
            return @"Three Routes Pre Stop";
            break;
        case four:
            return @"Four Routes Per Stop";
            break;
        case five:
            return @"Five Routes Per Stop";
            break;
        case six:
            return @"Six Routes Per Stop";
            break;
        case seven:
            return @"Seven Routes Per Stop";
            break;
        case eight:
            return @"Eight Routes Per Stop";
            break;
        case nine:
            return @"Nine Routes Per Stop";
            break;
        case ten:
            return @"Ten Routes Per Stop";
            break;
        case eleven:
            return @"Eleven Routes Per Stop";
            break;
        case twelve:
            return @"Twelve Routes Per Stop";
            break;
        case thirteen:
            return @"Thirteen Routes Per Stop";
            break;
        case fourteen:
            return @"Fourteen Routes Per Stop";
            break;
        case fifteen:
            return @"Fifteen Routes Per Stop";
            break;
        case sixteen:
            return @"Sixteen Routes Per Stop";
            break;
        case seventeen:
            return @"Seventeen Routes Per Stop";
            break;
        case eighteen:
            return @"Eighteen Routes Per Stop";
            break;
        case nineteen:
            return @"Nineteen Routes Per Stop";
            break;
        case twenty:
            return @"Twenty Routes Per Stop";
            break;
        case all:
            return @"All Stops";
            break;
        case none:
            return @"No Stops";
            break;
    }
    return @"";
}

@end
