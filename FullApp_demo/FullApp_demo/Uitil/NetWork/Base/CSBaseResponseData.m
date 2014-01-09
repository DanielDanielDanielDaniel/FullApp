//
//  CSBaseResponseData.m
//  CSBase
//
//  Created by lxm on 13-10-14.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import "CSBaseResponseData.h"

@implementation CSBaseResponseData

/**
 *	测试数据
 *
 *	@return	Id
 */
+ (id)dataForTesting
{
    return @"TEST";
}

- (id)dataWithJson:(id)JSON
{
    if (JSON!=nil) {
//        id response = [JSON objectForKey:@"response"];
        self.returnCode = [JSON objectForKey:@"resultCount"];
        self.message = [JSON objectForKey:@"Msg"];
        self.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"results"]];
    }
    
    return self;
}

- (id)dataWithXml:(id)XML
{
    return nil;
}
@end
