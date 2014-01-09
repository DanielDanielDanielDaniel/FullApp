//
//  CSBaseAPIManager.m
//  CSBase
//
//  Created by lxm on 13-10-12.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import "CSBaseAPIManager.h"
#import "CSBaseResponseData.h"
static CSBaseAPIManager *shared_manager = nil;

@implementation CSBaseAPIManager
+ (CSBaseAPIManager *)sharedManager {
    static dispatch_once_t pred;
	dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
	return shared_manager;
}

- (void)requestJsonDataSuccess:(void (^)(id data))success
               failure:(void (^)(NSError *error))failure{
    [[CSBaseAPIClient sharedJsonClient] requestJsonDataWithPath:@"" withParams:nil withMethodType:Get success:^(id responseJSON) {
//        success(data);
        [self handleResponse:responseJSON success:success failure:failure];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestXmlDataSuccess:(void (^)(id data))success
                  failure:(void (^)(NSError *error))failure
{
    return;
}

-(void)handleResponse:(id)responseJSON success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    // 解析 json dictionary to data object
    CSBaseResponseData *responseData =[[CSBaseResponseData alloc] dataWithJson:responseJSON];
    // 3.2 Check return code and return.
    int returnCode = [responseData.returnCode intValue];
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
    switch (returnCode) {
        case 1: {
            success(responseData.dataArray);
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
}
@end
