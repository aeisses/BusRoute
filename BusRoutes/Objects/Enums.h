//
//  Enums.h
//  BusRoutes
//
//  Created by Aaron Eisses on 13-07-28.
//  Copyright (c) 2013 Aaron Eisses. All rights reserved.
//

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

typedef enum {
    weekday_limited
} CLASS;