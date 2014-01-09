//
//  CSBaseAPIClient.m
//  CSBase
//
//  Created by lxm on 13-10-12.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import "CSBaseAPIClient.h"
#import "CSBaseResponseData.h"
#import "API.h"
#import "SystemInfo.h"
#import "RequestCacheService.h"
@interface CSBaseAPIClient ()
+ (id)sharedJsonHTTPClient;
@end

@implementation CSBaseAPIClient

+ (NSString *)getFullPathFromPath:(NSString *)path
{
    NSString *sysInfo =[SystemInfo systemInfo];
    return [[NSString stringWithFormat:@"%@", [CSBase_BASE_PATH stringByAppendingString:sysInfo]] stringByAppendingString:path];
}

#pragma - mark JSON

+ (id)sharedJsonHTTPClient {
	static dispatch_once_t pred;
    static AFHTTPClient *shared_instance = nil;
	
    dispatch_once(&pred, ^{
		shared_instance = [[self alloc] init];
        shared_instance = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:CSBase_BASE_PATH]];
        [shared_instance registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [shared_instance setDefaultHeader:@"Accept" value:@"application/json"];
        shared_instance.parameterEncoding = AFJSONParameterEncoding;
        shared_instance.stringEncoding = NSUTF8StringEncoding;
    });
    
	return shared_instance;
}

+ (id)sharedJsonClient {
	static dispatch_once_t pred;
    static CSBaseAPIClient *shared_instance = nil;
	
    dispatch_once(&pred, ^{
		shared_instance = [[self alloc] init];
        shared_instance.client = [self sharedJsonHTTPClient];
    });
    
	return shared_instance;
}

/**
 *	json请求方法
 *
 *	@param	aPath	urlPath
 *	@param	params	body参数
 *	@param	NetworkMethod	Get Post
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSMutableDictionary*)params
                 withMethodType:(int)NetworkMethod
                        success:(void (^)(id data))success
                        failure:(void (^)(NSError *error))failure
{
    //默认执行无缓存的情况
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:NetworkMethod success:success failure:failure withCachePolicy:NoCache];
}

-(NSInteger)getCacheIntervalForPolicy:(CachePolicy)cachePolicy
{
    NSInteger cacheExpireInterval;
    if (cachePolicy == NoCache) {
        cacheExpireInterval = -1;
    } else if (cachePolicy == Notice) {
        //读取资讯的缓存设置
        NSNumber *stored = [[NSUserDefaults standardUserDefaults] objectForKey:@"notice"];
        if (stored != nil && stored.integerValue > 0) {
            cacheExpireInterval = stored.integerValue;
        } else {
            NSLog(@"未获取到资讯的缓存时间，采用默认3600秒");
            cacheExpireInterval = 3600;
        }
    } else if (cachePolicy == Product) {
        //读取产品的缓存设置
        NSNumber *stored = [[NSUserDefaults standardUserDefaults] objectForKey:@"product"];
        if (stored != nil && stored.integerValue > 0) {
            cacheExpireInterval = stored.integerValue;
        } else {
            NSLog(@"未获取到资讯的缓存时间，采用默认3600秒");
            cacheExpireInterval = 3600;
        }
    } else {
        cacheExpireInterval = 3600;
    }
    return cacheExpireInterval;
}

/**
 *	@brief	json请求方法
 *
 *	@param 	aPath 	请求的url
 *	@param 	params 	请求的参数
 *	@param 	NetworkMethod 	请求类型，Get、Post或者Put
 *	@param 	cachePolicy 	缓存策略，默认为不缓存
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSMutableDictionary*)params
                 withMethodType:(int)NetworkMethod
                        success:(void (^)(id data))success
                        failure:(void (^)(NSError *error))failure
                withCachePolicy:(CachePolicy)cachePolicy

{  
    //由于后台兼容性的问题,不能在这里统一插入语言和地区
    NSString *path = aPath;
    //获取缓存时间
    NSInteger cacheExpireInterval = [self getCacheIntervalForPolicy:cachePolicy];
    //模式为需要缓存，则进行读取缓存操作，Put方法不做缓存
    if (cacheExpireInterval > 0 && NetworkMethod != Put) {
        id cachedObject = [[RequestCacheService getService] checkCacheForURL:path AndParams:params AndExpireInterval:cacheExpireInterval];
        if (cachedObject) {
            NSLog(@"命中请求缓存，直接返回结果");
            dispatch_async(dispatch_get_main_queue(), ^{
                success(cachedObject);
            });
            return;
        }
    }
#ifdef SHOW_NETWORK_DEBUG
    NSLog(@"请求参数===>%@", params);
#endif
    //根据请求类型准备发送请求
    switch (NetworkMethod) {
        case Get:
        {
            [self.client getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef SHOW_NETWORK_DEBUG
                NSLog(@"响应的JSON===>%@",((AFJSONRequestOperation *)operation).responseJSON);
#endif
                //写入缓存
                if (cachePolicy != NoCache) {
                    [[RequestCacheService getService]cacheObject:((AFJSONRequestOperation *)operation).responseJSON ForURL:path AndParams:params];
                }
                //执行回调
                success(((AFJSONRequestOperation *)operation).responseJSON);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(error);
            }];
        }
            break;
        case Post:
        {
            [self.client postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef SHOW_NETWORK_DEBUG
                NSLog(@"响应的JSON===>%@",((AFJSONRequestOperation *)operation).responseJSON);
#endif
                //写入缓存
                if (cachePolicy != NoCache) {
                    [[RequestCacheService getService]cacheObject:((AFJSONRequestOperation *)operation).responseJSON ForURL:path AndParams:params];
                }
                //执行回调
                success(((AFJSONRequestOperation *)operation).responseJSON);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(error);
            }];
        }
            break;
        case Put:
        {
            [self.client putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //写入缓存
//                if (cachePolicy != NoCache) {
//                    [[RequestCacheService getService]cacheObject:((AFJSONRequestOperation *)operation).responseJSON ForURL:path AndParams:params];
//                }
                //执行回调
                success(((AFJSONRequestOperation *)operation).responseJSON);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(error);
            }];
        }
            break;
        default:
            break;
    }

}

#pragma - mark XML

+ (id)sharedXmlHTTPClient {
	static dispatch_once_t pred;
    static AFHTTPClient *shared_instance = nil;
	
    dispatch_once(&pred, ^{
		shared_instance = [[self alloc] init];
        shared_instance = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:CSBase_BASE_PATH]];
        [shared_instance registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [shared_instance setDefaultHeader:@"Accept" value:@"text/xml"];
        shared_instance.parameterEncoding = AFFormURLParameterEncoding;
    });
    
	return shared_instance;
}

+ (id)sharedXmlClient {
	static dispatch_once_t pred;
    static CSBaseAPIClient *shared_instance = nil;
	
    dispatch_once(&pred, ^{
		shared_instance = [[self alloc] init];
        shared_instance.client = [self sharedXmlHTTPClient];
    });
    
	return shared_instance;
}

/**
 *	xml请求方法
 *
 *	@param	aPath	urlPath
 *	@param	params	body参数
 *	@param	NetworkMethod	Get Post Put
 */
- (void)requestXmlDataWithPath:(NSString *)aPath
                    withParams:(NSMutableDictionary*)params
                withMethodType:(int)NetworkMethod
                       success:(void (^)(id data))success
                       failure:(void (^)(NSError *error))failure
{
    if (USE_TEST_DATA_MODE) {
        CSBaseResponseData *responseData =[CSBaseResponseData dataForTesting];
        success(responseData);
        return;
    }
    /*1.1 获取数据*/
    NSString* aStr = [[NSString alloc] initWithData:[params objectForKey:@"data"] encoding:NSUTF8StringEncoding];
    
    /*1.2 压缩*/
    API *api = [[API alloc] init];
    NSData *data = [api sendData:aStr];
    
    /*1.3 组装URL*/
    NSString *path = [CSBaseAPIClient getFullPathFromPath:aPath];
    NSURL *url = [NSURL URLWithString:path];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = nil;
    switch (NetworkMethod){
        case Get:
            request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
            break;
        case Post:
            request = [httpClient requestWithMethod:@"POST" path:path parameters:nil];
            break;
        case Put:
            request = [httpClient requestWithMethod:@"PUT" path:path parameters:nil];
            break;
        default:
            request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
            break;
    }
    [request setValue: @"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.f];
    [request setHTTPBody:data];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*2.1 获取数据*/
        NSData *dataTemp = operation.responseData;
        
        /*2.2 解压缩*/
        API *compress = [[API alloc] init];
        dataTemp = [compress receiveData:dataTemp];
        
        /*2.3 转utf8*/
        NSString *responseString = [[NSString alloc] initWithData:dataTemp encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        dataTemp = [responseString dataUsingEncoding: NSUTF8StringEncoding];
        
        //2.4 判断数据完整性 FIXME
        int returnCode = API_Sucess_Code;
        if ([@"" isEqualToString:responseString]) {
            returnCode = API_Server_Error_Code;
        }
        /*
         #define API_Sucess_Code                     200
         #define API_IDType_Error_Code               400
         #define API_NotAuthorized_Error_Code        401
         #define API_PayMent_Required_Error_Code     402
         #define API_Forbidden_Error_Code            403
         #define API_RequestURL_NotFound_Error_Code  404
         #define API_Server_Error_Code               500
         #define API_Not_Implemented_Error_Code      501
         
         Code	Message
         200	OK / Success
         400	ID or  data must be numeric
         401	Not authorized
         402	Payment Required
         403	Forbidden
         404	The request URL was not found
         500	The server encountered an error when processing your request
         501	The requested function is not implemented
         */
        /*2.5 返回NSXMLParser*/
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:dataTemp];
        
        switch (returnCode) {
            case API_Sucess_Code: {
                success(xmlParser);
                break;
            }
                
            case API_IDType_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"ID or  data must be numeric" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
                
            case API_NotAuthorized_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"Not authorized" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
            case API_PayMent_Required_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"Payment Required" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
            case API_Forbidden_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"Forbidden" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
            case API_RequestURL_NotFound_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"The request URL was not found" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
            case API_Server_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"The server encountered an error when processing your request" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
            case API_Not_Implemented_Error_Code: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"The requested function is not implemented" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
                
            default: {
                NSError *err = [NSError errorWithDomain:CSBase_ERROR_DEMAIN code:returnCode userInfo:[NSDictionary dictionaryWithObject:@"Unknow error" forKey:NSLocalizedDescriptionKey]];
                failure(err);
                break;
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    
}

@end
