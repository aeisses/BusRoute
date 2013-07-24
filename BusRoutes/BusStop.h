//
//  BusStop.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-23.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KML/KML.h>

typedef enum {
    trbsin,
    trbsac,
    trbssnac,
    trbs,
    trbsshac,
    trbssh,
    trpr,
    trbstmac,
    trbstm,
    trbsshin
} FCODE;

typedef enum {
    transit,
    hastus
} SOURCE;

typedef enum {
    DV,
    IN,
    XY,
    GP
} SACC;

@interface BusStop : NSObject
{
    NSString *stopDescription;
}

-(id)initWithName:(NSString *)name description:(NSString*)description andLocation:(KMLPoint*)location;

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) KMLPoint *location;
@property (assign, nonatomic) NSInteger objectId;
@property (assign, nonatomic) FCODE fcode;
@property (assign, nonatomic) SOURCE source;
@property (assign, nonatomic) SACC sacc;
@property (retain, nonatomic) NSDate *date;
@property (assign, nonatomic) NSInteger gotime;
@property (retain, nonatomic) NSString *address;

@end
