//
//  DoubanService.h
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseAPIClient.h"

#define TEST_URL @"https://api.douban.com/v2/event/10069638/wishers"

@interface DoubanService : NSObject

-(void)demoRequest:(void(^)(NSString *sucess))sucess
           failure:(void(^)(NSString *error))failure;

@end
