//
//  NSString+MBCommon.m
//  MBCommon
//
//  Created by Sebastian Celis on 3/1/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import "NSString+MBCommon.h"

@implementation NSString (MBCommon)

- (NSString *)mb_URLEncodedString
{
    NSString *s = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (CFStringRef)self,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                      kCFStringEncodingUTF8);
    return [s autorelease];
}

@end
