//
//  API.m
//  CSMBP
//
//  Created by apple on 11-8-19.
//  Copyright 2011年 Forever OpenSource Software Inc. All rights reserved.
//
#define ENCRYPT_KEY @"This is a secret keynews"
#import "API.h"


@implementation API

- (id) init {
    if (self = [super init]) {
		
				
	}
	return self;
}

- (void)dealloc {
	
}


-(NSData *) sendData:(NSString*)pstr
{
    // 加密
	NSData *data = [DESObject doEncryptWithString:pstr key:ENCRYPT_KEY];
	
	// 压缩
	data = [self zipFileAction:data];
    return data;
}

-(NSData *) receiveData:(NSData*)data
{	
	
	NSString *dataAsStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog(@"htmlContent===1%@", dataAsStr);
	if (dataAsStr == nil) {
		// 解压
		NSData *backData = [self upZipFileAction:data];
		NSString *backDataStr = [[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding];
//		NSLog(@"htmlContent===2%@", backDataStr);
        backData = [DESObject doDecryptWithData:backData keyStr:ENCRYPT_KEY];
        return backData;

    }
    else
        return nil;
}

-(NSData *) encrypt:(NSString*)pstr
{
    // 加密
	NSData *data = [DESObject doEncryptWithString:pstr key:ENCRYPT_KEY];
    return data;
}
-(NSData *) decrypt:(NSData*)pstr
{
    NSData *backData = [DESObject doDecryptWithData:pstr keyStr:ENCRYPT_KEY];
    return backData;
}
/////////////////////////////////////////////////////////////
#pragma mark ==== Zip ====
/////////////////////////////////////////////////////////////
- (void) zipEnd:(NSData *)data {
	
	// data 是一个压缩的数据
	
	
}


- (NSData *) zipFileThreadFunc:(NSData *)data {	
	//NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"zipServletservice.zip"];    
    if ([fileManager fileExistsAtPath:path] == YES)
    {
        [fileManager removeItemAtPath:path error:&error];
    }
	
    BOOL b = [zipArch_ CreateZipFile2:path];
    if(!b){
        //NSLog(@"Error: zipArch_ CreateZipFile2 failed.");
        return nil;
    }
    
	// 先成一个没有压缩的文件
	[zipArch_ addFileDataToZip:data newname:@"zipServletservice.data"];
	
	[zipArch_ CloseZipFile2];
	
	NSData *zipData = [NSData dataWithContentsOfFile:path];	
	return zipData;
	//[self performSelectorOnMainThread:@selector(zipEnd:) withObject:zipData waitUntilDone:NO];
    
	//[thePool release];	 
}


- (NSData *) zipFileAction:(NSData *)data {
	
	if (zipArch_ == nil) {
		zipArch_ = [[ZipArchive alloc] init];
	}
	
	return [self zipFileThreadFunc:data];
}





/////////////////////////////////////////////////////////////
#pragma mark ==== unzip ====
/////////////////////////////////////////////////////////////
- (void) unZipEnd:(NSData *)data {
	
//	[self parserJsonWithData:data];
//	[self doneDataToTarget];
}

- (NSData *) unZipFileThreadFunc:(NSData *)data {
	
	
	//NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"unZipServletservice.zip"]; 
	if ([fileManager fileExistsAtPath:path] == YES)
	{
		[fileManager removeItemAtPath:path error:nil];
        
	}
	// 生成文件
	[data writeToFile:path atomically:YES];
	
	BOOL b = [zipArch_ UnzipOpenFile:path];
	if (b) {
		[zipArch_ UnzipFileTo:documentsDirectory overWrite:YES];
	}
	
	// 得到解压缩后的数据
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"servletservice"]; 
	NSData *upZipData = [NSData dataWithContentsOfFile:dataPath];
    
    if ([fileManager fileExistsAtPath:dataPath] == YES)
	{
		[fileManager removeItemAtPath:dataPath error:nil];
        
	}
    
	[zipArch_ UnzipCloseFile];
	//[self performSelectorOnMainThread:@selector(unZipEnd:) withObject:upZipData waitUntilDone:NO];
	
	return upZipData;
	//[thePool release];
}

- (NSData *) upZipFileAction:(NSData *)data {
	
	if (zipArch_ == nil) {
		zipArch_ = [[ZipArchive alloc] init];
	}
	
	return [self unZipFileThreadFunc:data];
	
}

@end
