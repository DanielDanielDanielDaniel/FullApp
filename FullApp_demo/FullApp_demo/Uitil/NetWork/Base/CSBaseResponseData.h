//
//  CSBaseResponseData.h
//  CSBase
//
//  Created by lxm on 13-10-14.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseAPIClient.h"

@interface CSBaseResponseData : NSObject

/**
 *	假定json的固定模式是 response :{Code:{},Msg:{}}
 *  FIXME lxm
 */
@property(strong , nonatomic)NSString *message;
@property(strong, nonatomic)NSString *returnCode;
@property(strong, nonatomic)NSArray *dataArray;

/**
 *	测试数据
 *
 *	@return	Id
 */
+ (id)dataForTesting;

/**
 *	Http请求返回数据 过滤
 *
 *	@param	JSON	接口返回数据
 *
 *	@return	返回业务数据
 */
- (id)dataWithJson:(id)JSON;

/**
 *	<#Description#>
 *
 *	@param	XML	<#XML description#>
 *
 *	@return	<#return value description#>
 */
- (id)dataWithXml:(id)XML;
@end
