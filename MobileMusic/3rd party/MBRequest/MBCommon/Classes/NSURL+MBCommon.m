//
//  NSURL+MBCommon.m
//  MBCommon
//
//  Created by Sebastian Celis on 3/1/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import "NSURL+MBCommon.h"

#import "NSDictionary+MBCommon.h"

@implementation NSURL (MBCommon)

+ (NSURL *)mb_URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)params
{
    if (params == nil || [params count] == 0)
    {
        return [NSURL URLWithString:baseString];
    }

    NSMutableString *urlString = [[NSMutableString alloc] initWithString:baseString];
    if (![baseString hasSuffix:@"&"] && ![baseString hasSuffix:@"?"])
    {
        NSRange range = [baseString rangeOfString:@"?"];
        [urlString appendString:(range.location == NSNotFound) ? @"?" : @"&"];
    }

    [urlString appendString:[params mb_URLParameterString]];
    NSURL *url = [NSURL URLWithString:urlString];
    [urlString release];
    return url;
}

@end
