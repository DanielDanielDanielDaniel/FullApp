//
//  SystemInfo.h
//  CSBase
//
//  Created by Mr Right on 13-10-11.
//  Copyright (c) 2013年 lxm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemInfo : NSObject

//@property(nonatomic,strong)NSString *appVersion;
//@property(nonatomic,strong)NSString *systemVersion;
//@property(nonatomic,strong)NSString *pushToken;

+(NSString*)appVersion;
+(NSString*)systemVersion;
+(NSString*)pushToke;
+(NSString*)uniqueDeviceIdentifier;

+(NSString*)systemInfo;

@end
