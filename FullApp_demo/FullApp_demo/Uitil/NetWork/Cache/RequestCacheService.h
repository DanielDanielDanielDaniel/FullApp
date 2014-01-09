//
//  RequestCacheService.h
//  CSBase
//
//  Created by SunShine on 13-12-5.
//  Copyright (c) 2013年 csair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCacheService : NSObject

+(RequestCacheService*)getService;
//检查缓存，如果存在并未过期则返回缓存的对象
-(id)checkCacheForURL:(NSString *)url AndParams:(NSDictionary *)params AndExpireInterval:(NSInteger)expireSeconds;
//将对象写入缓存
-(void)cacheObject:(id)response ForURL:(NSString *)url AndParams:(NSDictionary *)params;
//清理目录中的文件
-(void)cleanCache;
//读取缓存配置
-(void)loadCacheConfigFromServer;
@end
