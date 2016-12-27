//
//  GameCheck.h
//  my_first_app
//
//  Created by chengshuo on 15/2/9.
//  Copyright (c) 2015年 chengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@interface ColorMap : NSObject {
    NSMutableDictionary *CellColors;
}

- (id) init;

- (UIColor*) getcolor:(int)num;

@end
