//
//  APIUrl.h
//  CSBase
//
//  Created by lxm on 13-10-12.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

/*业务逻辑所有api接口请求都放这里*/

#import <Foundation/Foundation.h>


#define USE_TEST_DATA_MODE 0


#define Test_Version                         1

#define Product_Version                      0

//API Return Code

#define API_Sucess_Code                     200
#define API_IDType_Error_Code               400
#define API_NotAuthorized_Error_Code        401
#define API_PayMent_Required_Error_Code     402
#define API_Forbidden_Error_Code            403
#define API_RequestURL_NotFound_Error_Code  404
#define API_Server_Error_Code               500
#define API_Not_Implemented_Error_Code      501

/*UAT Version*/

#if Test_Version

#define CSBase_ERROR_DEMAIN                     @""
#define CSBase_BASE_URL                         @"http://serverurl"
#define CSBase_BASE_PATH                        @""

//启动
#define CSBase_PATH_VERSIONCHECK              @"/versioncheck"

#endif

/* Product Version */
#if Product_Version

#define CSBase_ERROR_DEMAIN                     @""
#define CSBase_BASE_URL                         @"http://serverurl"
#define CSBase_BASE_PATH                        @"/api"

//启动
#define CSBase_PATH_VERSIONCHECK              @"/versioncheck"
#endif

