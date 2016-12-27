//
//  GameCheck.m
//  my_first_app
//
//  Created by chengshuo on 15/2/9.
//  Copyright (c) 2015年 chengshuo. All rights reserved.
//

#import "ColorMap.h"
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation ColorMap

- (id) init {
    self=[super init];
    CellColors=[[NSMutableDictionary alloc]init];
    [CellColors setObject:RGB(0, 0, 0) forKey:[NSNumber numberWithInt:-1]];
    [CellColors setObject:RGB(255, 123, 0) forKey:[NSNumber numberWithInt:2]];
    [CellColors setObject:RGB(64, 230, 164) forKey:[NSNumber numberWithInt:4]];
    [CellColors setObject:RGB(64, 130, 230) forKey:[NSNumber numberWithInt:8]];
    [CellColors setObject:RGB(106, 64, 230) forKey:[NSNumber numberWithInt:16]];
    [CellColors setObject:RGB(120, 22, 172) forKey:[NSNumber numberWithInt:32]];
    [CellColors setObject:RGB(130, 3, 3) forKey:[NSNumber numberWithInt:64]];
    [CellColors setObject:RGB(201, 250, 77) forKey:[NSNumber numberWithInt:128]];
    [CellColors setObject:RGB(168, 117, 245) forKey:[NSNumber numberWithInt:256]];
    [CellColors setObject:RGB(6, 164, 100) forKey:[NSNumber numberWithInt:512]];
    [CellColors setObject:RGB(40, 142, 16) forKey:[NSNumber numberWithInt:1024]];
    [CellColors setObject:RGB(255, 0, 0) forKey:[NSNumber numberWithInt:2048]];
    return self;
}

-(UIColor *)getcolor:(int)num {
    return [CellColors objectForKey:[NSNumber numberWithInt:num]];
}

@end
