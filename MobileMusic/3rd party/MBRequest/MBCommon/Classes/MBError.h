//
//  MBError.h
//  MBCommon
//
//  Created by Sebastian Celis on 2/28/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MBErrorCodeCannotDecodeJSONError = 1,
    MBErrorCodeCannotEncodeJSONError
} MBErrorCode;

extern NSString * const MBErrorDomain;
extern NSString * const MBOriginalErrorKey;
