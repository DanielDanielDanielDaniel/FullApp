//
//  CSBaseAPIManager.h
//  CSBase
//
//  Created by lxm on 13-10-12.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseAPIClient.h"
@interface CSBaseAPIManager : NSObject
+ (CSBaseAPIManager *)sharedManager;

- (void)requestJsonDataSuccess:(void (^)(id data))success
                   failure:(void (^)(NSError *error))failure;

- (void)requestXmlDataSuccess:(void (^)(id data))success
                   failure:(void (^)(NSError *error))failure;

@end