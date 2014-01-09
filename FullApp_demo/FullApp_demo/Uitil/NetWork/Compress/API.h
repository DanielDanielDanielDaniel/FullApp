//
//  API.h
//  CSMBP
//
//  Created by apple on 11-8-19.
//  Copyright 2011年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
// ZIP
#import "ZipArchive.h"

#import "DESObject.h"

@interface API : NSObject {
    // ZIP
	ZipArchive					*zipArch_;

}
//NSData *data  = [postStr dataUsingEncoding:NSUTF8StringEncoding];
//NSString *backDataStr = [[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding];

-(NSData *) sendData:(NSString*)pstr;
-(NSData *) receiveData:(NSData*)pstr;

-(NSData *) encrypt:(NSString*)pstr;
-(NSData *) decrypt:(NSData*)pstr;



// 压缩
- (NSData *) zipFileAction:(NSData *)data;



// 根据得到的数据解压缩
- (NSData *) upZipFileAction:(NSData *)data;
@end
