//
//  DoubanModel.h
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Class_properties.h"

@interface DoubanModel : NSObject

@property(strong,nonatomic)NSString *count;
@property(strong,nonatomic)NSString *start;
@property(strong,nonatomic)NSString *total;
@property(strong,nonatomic)NSArray *users;

+(DoubanModel *)shareDoubanService;

@end
