//
//  Utils.m
//  BusRoutes
//
//  Created by Aaron Eisses on 13-08-07.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import "Utils.h"

@implementation Utils

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
