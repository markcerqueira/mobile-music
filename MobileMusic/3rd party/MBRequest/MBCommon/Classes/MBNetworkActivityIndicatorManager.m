//
//  MBNetworkActivityIndicatorManager.m
//  MBCommon
//
//  Created by Sebastian Celis on 3/5/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import "MBNetworkActivityIndicatorManager.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED

#import <UIKit/UIKit.h>


@interface MBNetworkActivityIndicatorManager ()
@property (nonatomic, assign) NSInteger networkActivityCounter;
@end


@implementation MBNetworkActivityIndicatorManager

@synthesize enabled = _enabled;
@synthesize networkActivityCounter = _networkActivityCounter;

#pragma mark - Object Lifecycle

- (id)init
{
    if ((self = [super init]))
    {
        _enabled = YES;
    }
    
    return self;
}

+ (MBNetworkActivityIndicatorManager *)sharedManager
{
    static dispatch_once_t pred;
    static MBNetworkActivityIndicatorManager *singleton = nil;
    dispatch_once(&pred, ^{ singleton = [[self alloc] init]; });
    return singleton;
}

#pragma mark - Public Methods

- (void)networkActivityStarted
{
    if ([self isEnabled])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_networkActivityCounter == 0)
            {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            }
            _networkActivityCounter++;
        });
    }
}

- (void)networkActivityStopped
{
    if ([self isEnabled])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_networkActivityCounter == 1)
            {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            _networkActivityCounter = _networkActivityCounter - 1;
        });
    }
}

@end

#endif
