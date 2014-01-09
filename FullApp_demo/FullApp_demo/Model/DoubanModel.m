//
//  DoubanModel.m
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import "DoubanModel.h"

static DoubanModel *singlton = nil;
@implementation DoubanModel

+(DoubanModel *)shareDoubanService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlton = [DoubanModel new];
    });
    return singlton;
}

@end
