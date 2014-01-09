//
//  RequestCacheService.m
//  CSBase
//
//  Created by SunShine on 13-12-5.
//  Copyright (c) 2013年 csair. All rights reserved.
//

#import "RequestCacheService.h"
#import "NSString+MD5Addition.h"
#import "CSBaseAPIClient.h"

#define BASE_SERVER_URL @""
#define CACHE_CONFIG_URL [BASE_SERVER_URL stringByAppendingString:@"/webservice/cache.do"]

@implementation RequestCacheService

+(RequestCacheService*)getService
{
    static RequestCacheService *singlton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlton = [RequestCacheService new];
    });
    return singlton;
}

//检查缓存，如果存在并未过期则返回缓存的对象
-(id)checkCacheForURL:(NSString *)url AndParams:(NSDictionary *)params AndExpireInterval:(NSInteger)expireSeconds
{
    NSString *cacheFilePath = [[self getCacheDirectory] stringByAppendingPathComponent:[self caculateCacheFilePathForURL:url AndParams:params]];
#ifdef SHOW_NETWORK_DEBUG
    NSLog(@"请求缓存--计算出的缓存文件路径为:%@", cacheFilePath);
#endif
    NSDate *fileDate = [self getLastCacheTimeForPath:cacheFilePath];
#ifdef SHOW_NETWORK_DEBUG
    NSLog(@"请求缓存--获取到的缓存时间为:%@", fileDate);
#endif
    if ([self checkExpireForDate:fileDate WithInterval:expireSeconds]) {
        //缓存过期了，返回空
        return nil;
    } else {
        //缓存没过期，尝试读取
        NSData *fileData = [NSData dataWithContentsOfFile:cacheFilePath];
        if (fileData) {
//            NSString *cachedStr = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            //转换对象
            NSError *error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
            if (error) {
#ifdef SHOW_NETWORK_DEBUG
                NSLog(@"请求缓存--读取缓存的内容时发生异常:%@", error);
#endif
                return nil;
            } else {
                return result;
            }
        } else {
#ifdef SHOW_NETWORK_DEBUG
            NSLog(@"请求缓存--读取缓存内容失败");
#endif
            return nil;
        }
    }
}

//将对象写入缓存
-(void)cacheObject:(id)response ForURL:(NSString *)url AndParams:(NSDictionary *)params
{
    if (response == nil || response == (id)[NSNull null]) {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"请求缓存--获取的响应为空,跳过写入缓存");
#endif
        return;
    }
    NSString *cacheFilePath = [[self getCacheDirectory] stringByAppendingPathComponent:[self caculateCacheFilePathForURL:url AndParams:params]];
    //序列化内容
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"请求缓存--写入缓存时序列化失败:%@", error);
#endif
        return;
    }
    NSError *writeError = nil;
    [jsonData writeToFile:cacheFilePath options:NSDataWritingAtomic error:&writeError];
    if (writeError) {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"请求缓存--写入缓存时IO操作失败:%@", writeError);
#endif
    }
}

//读取缓存配置
-(void)loadCacheConfigFromServer
{
    NSMutableDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"appType", nil];//2代表iOS
    [[CSBaseAPIClient sharedJsonClient] requestJsonDataWithPath:CACHE_CONFIG_URL withParams:params withMethodType:Post success:^(id data) {
        NSNumber *notice = [data objectForKey:@"notice"];
        NSNumber *product = [data objectForKey:@"product"];
        NSLog(@"从服务器更新到缓存设置，notice缓存时间%@，product缓存时间%@", notice, product);
        //获取的缓存是小时，这里转换为秒
        notice = [NSNumber numberWithInteger:notice.integerValue * 3600];
        product = [NSNumber numberWithInteger:product.integerValue * 3600];
        //保存缓存设置
        [[NSUserDefaults standardUserDefaults] setObject:notice forKey:@"notice"];
        [[NSUserDefaults standardUserDefaults] setObject:product forKey:@"product"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSError *error) {
        //
        NSLog(@"获取缓存配置失败:%@", error);
    } withCachePolicy:NoCache];
}

//清理目录中的文件
-(void)cleanCache
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *cacheDirectory = [self getCacheDirectory];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cacheDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        [fileManager removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:filename]
                                error:NULL];
    }
}

#pragma mark - Private Method
//获取缓存文件的目录
-(NSString *)getCacheDirectory
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RequestCache"];
    //检查文件夹是否存在
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        //文件夹存在
    } else {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"缓存文件夹不存在，准备创建");
#endif
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

//计算缓存的文件名
-(NSString *)caculateCacheFilePathForURL:(NSString *)url AndParams:(NSDictionary *)params
{
    NSError *error = nil;
    NSLog(@"params:%@",params);
//    params = [[NSDictionary alloc]initWithObjectsAndKeys:@"hello",@"world", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"请求缓存--无法正常的处理请求参数，%@", error);
#endif
        return nil;
    }
    NSString *paramsStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#ifdef SHOW_NETWORK_DEBUG
    NSLog(@"请求缓存--序列化的请求参数为：%@", paramsStr);
#endif
    NSString *result = [[url stringByAppendingFormat:@"?%@", paramsStr] stringFromMD5];
#ifdef SHOW_NETWORK_DEBUG
    NSLog(@"请求缓存--计算出的缓存文件名为：%@", result);
#endif
    return result;
}

//获取文件的修改时间
-(NSDate *)getLastCacheTimeForPath:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL existFlag = [fileManager fileExistsAtPath:path];
    if (!existFlag) {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"请求缓存--缓存文件不存在：%@", path);
#endif
        return nil;
    }
    NSDictionary* attributes = [fileManager attributesOfItemAtPath:path error:nil];
    if (attributes) {
        NSDate *date = (NSDate*)[attributes objectForKey:NSFileModificationDate];
        return date;
    } else {
#ifdef SHOW_NETWORK_DEBUG
        NSLog(@"请求缓存--缓存文件无法获取文件属性：%@", path);
#endif
        return nil;
    }
}

//检查缓存时间是否过期
-(BOOL)checkExpireForDate:(NSDate *)cacheDate WithInterval:(NSInteger)seconds
{
    NSDate *expectedDate = [NSDate dateWithTimeIntervalSinceNow:(0-seconds)];
    if (cacheDate == nil || [cacheDate compare:expectedDate] == NSOrderedAscending) {
        //没有缓存时间或者缓存时间早于预计的到期时间，认为过期
        return YES;
    } else {
        //没过期
        return NO;
    }
}
@end
