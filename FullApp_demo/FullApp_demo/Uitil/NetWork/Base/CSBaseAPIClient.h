//
//  CSBaseAPIClient.h
//  CSBase
//
//  Created by lxm on 13-10-12.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "APIUrl.h"
typedef enum {
	Get = 0,
	Post,
	Put
} NetworkMethod;

typedef enum {
    NoCache = 0,
    Notice,
    Product,
    Unknown
}CachePolicy;

@interface CSBaseAPIClient : NSObject
@property(nonatomic, strong)AFHTTPClient *client;

+ (NSString *)getFullPathFromPath:(NSString *)path;


+ (id)sharedJsonClient;
//使用默认的缓存策略进行请求，即不进行缓存
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSMutableDictionary*)params
                 withMethodType:(int)NetworkMethod
                        success:(void (^)(id data))success
                        failure:(void (^)(NSError *error))failure __attribute__((deprecated));
//使用传入的缓存策略进行请求
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSMutableDictionary*)params
                 withMethodType:(int)NetworkMethod
                        success:(void (^)(id data))success
                        failure:(void (^)(NSError *error))failure
                withCachePolicy:(CachePolicy)cachePolicy;

+ (id)sharedXmlHTTPClient;
+ (id)sharedXmlClient;
- (void)requestXmlDataWithPath:(NSString *)aPath
                    withParams:(NSMutableDictionary*)params
                withMethodType:(int)NetworkMethod
                       success:(void (^)(id data))success
                       failure:(void (^)(NSError *error))failure;
@end
