//
//  NSString+MLExtensions.m
//  CSMBP
//
//  Created by apple on 11-8-20.
//  Copyright 2011年 Forever OpenSource Software Inc. All rights reserved.
//

#import "NSString+MLExtensions.h"

NSString *_mlfilterChars = @";/?:@&=+$,";

@implementation NSString (MLExtensions)

- (NSString *)urlencode
{
    NSString* str =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                            NULL, 
                                            (CFStringRef)self,
                                            NULL, 
                                            (CFStringRef)_mlfilterChars,
                                            kCFStringEncodingUTF8));
    NSString* ret = [str stringByReplacingOccurrencesOfString: @"%20" withString: @"+"];
        
    return ret;
}

@end