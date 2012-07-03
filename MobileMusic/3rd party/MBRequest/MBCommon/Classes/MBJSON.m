//
//  MBJSON.m
//  MBCommon
//
//  Created by Sebastian Celis on 2/28/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import "MBJSON.h"

#import "MBError.h"
#import "MBLocalization.h"

typedef enum {
    MBJSONLibraryNone,
    MBJSONLibraryApple,
    MBJSONLibraryJSONKit,
    MBJSONLibrarySBJSON
} MBJSONLibrary;

static MBJSONLibrary _jsonLibrary = MBJSONLibraryNone;
static Class _jsonClass = nil;

void MBJSONDetermineJSONLibrary()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([NSData instancesRespondToSelector:@selector(objectFromJSONDataWithParseOptions:error:)])
        {
            _jsonLibrary = MBJSONLibraryJSONKit;
        }
        else if ([NSData instancesRespondToSelector:@selector(JSONValue)])
        {
            _jsonLibrary = MBJSONLibrarySBJSON;
        }
        else
        {
            Class c = NSClassFromString(@"NSJSONSerialization");
            if (c)
            {
                _jsonLibrary = MBJSONLibraryApple;
                _jsonClass = c;
            }
        }

        if (_jsonLibrary == MBJSONLibraryNone)
        {
            [NSException raise:NSInternalInconsistencyException format:@"Unable to find a valid JSON library. Please target iOS 5, Lion, or include JSONKit or SBJSON in your project."];
        }
    });
}

id MBJSONObjectFromData(NSData *data, NSError **error)
{
    MBJSONDetermineJSONLibrary();

    id object = nil;
    NSError *myError = nil;
    NSError **myErrorPtr = &myError;
    switch (_jsonLibrary)
    {
        case MBJSONLibraryApple:
        {
            SEL selector = @selector(JSONObjectWithData:options:error:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_jsonClass methodSignatureForSelector:selector]];
            invocation.target = _jsonClass;
            invocation.selector = selector;

            [invocation setArgument:&data atIndex:2];
            NSUInteger options = 0;
            [invocation setArgument:&options atIndex:3];
            [invocation setArgument:&myErrorPtr atIndex:4];

            [invocation invoke];
            [invocation getReturnValue:&object];
            break;
        }
        case MBJSONLibraryJSONKit:
        {
            SEL selector = @selector(objectFromJSONDataWithParseOptions:error:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:selector]];
            invocation.target = data;
            invocation.selector = selector;

            NSUInteger options = 0;
            [invocation setArgument:&options atIndex:2];
            [invocation setArgument:&myErrorPtr atIndex:3];

            [invocation invoke];
            [invocation getReturnValue:&object];
            break;
        }
        case MBJSONLibrarySBJSON:
        {
            SEL selector = @selector(JSONValue);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:selector]];
            invocation.target = data;
            invocation.selector = selector;

            [invocation invoke];
            [invocation getReturnValue:&object];
            break;
        }
        default:
            break;
    }

    if (object == nil && error != NULL)
    {
        NSString *msg = MBLocalizedString(@"cannot_decode_json_data", @"Unable to decode JSON data.");
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
        if (myError != nil)
        {
            [userInfo setObject:myError forKey:MBOriginalErrorKey];
        }
        *error = [NSError errorWithDomain:MBErrorDomain code:MBErrorCodeCannotDecodeJSONError userInfo:userInfo];
    }

    return object;
}

NSData *MBJSONDataFromObject(id object, NSError **error)
{
    MBJSONDetermineJSONLibrary();

    NSData *data = nil;
    NSError *myError = nil;
    NSError **myErrorPtr = &myError;
    switch (_jsonLibrary)
    {
        case MBJSONLibraryApple:
        {
            SEL selector = @selector(dataWithJSONObject:options:error:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_jsonClass methodSignatureForSelector:selector]];
            invocation.target = _jsonClass;
            invocation.selector = selector;

            [invocation setArgument:&object atIndex:2];
            NSUInteger options = 0;
            [invocation setArgument:&options atIndex:3];
            [invocation setArgument:&myErrorPtr atIndex:4];

            [invocation invoke];
            [invocation getReturnValue:&data];
            break;
        }
        case MBJSONLibraryJSONKit:
        {
            SEL selector = @selector(JSONDataWithOptions:error:);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
            invocation.target = object;
            invocation.selector = selector;

            NSUInteger options = 0;
            [invocation setArgument:&options atIndex:2];
            [invocation setArgument:&myErrorPtr atIndex:3];

            [invocation invoke];
            [invocation getReturnValue:&data];
            break;
        }
        case MBJSONLibrarySBJSON:
        {
            NSString *string = nil;
            SEL selector = @selector(JSONRepresentation);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
            invocation.target = object;
            invocation.selector = selector;

            [invocation invoke];
            [invocation getReturnValue:&string];
            data = [string dataUsingEncoding:NSUTF8StringEncoding];
            break;
        }
        default:
            break;
    }

    if (data == nil && error != NULL)
    {
        NSString *msg = MBLocalizedString(@"cannot_encode_json_data", @"Unable to encode JSON data.");
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
        if (myError != nil)
        {
            [userInfo setObject:myError forKey:MBOriginalErrorKey];
        }
        *error = [NSError errorWithDomain:MBErrorDomain code:MBErrorCodeCannotEncodeJSONError userInfo:userInfo];
    }

    return data;
}
