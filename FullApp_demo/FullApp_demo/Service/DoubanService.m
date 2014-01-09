//
//  DoubanService.m
//  FullApp_demo
//
//  Created by Pepper's mpro on 1/9/14.
//  Copyright (c) 2014 foreveross. All rights reserved.
//

#import "DoubanService.h"
#import "DoubanModel.h"

@implementation DoubanService

-(void)demoRequest:(void(^)(NSString *sucess))sucess
           failure:(void(^)(NSString *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"hello",@"world", nil];
    CSBaseAPIClient *clientHttp = [CSBaseAPIClient sharedJsonClient];
    [clientHttp requestJsonDataWithPath:TEST_URL withParams:params withMethodType:Get success:^(id data){
        NSLog(@"ooo");
        /////反射数据源,自动赋值
        DoubanModel *cp = [DoubanModel shareDoubanService];
        [cp reflectDataFromOtherObject:data];
        /////
        NSLog(@"count:%@",cp.count);
        NSLog(@"%@",[[cp.users objectAtIndex:0]class]);
        NSLog(@"%@",[[cp.users objectAtIndex:0]objectForKey:@"alt"]);
        /////
        if([data isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"%@",data);
            sucess(@"sucess");
        }
        
    } failure:^(NSError *error){
        failure(@"请求网络失败,请稍后重试");
    } withCachePolicy:Notice];
}


@end
