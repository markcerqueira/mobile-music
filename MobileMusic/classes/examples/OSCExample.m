//
//  OSCExample.m
//  MobileMusic
//
//  Created by Mark on 7/12/12.
//

#import "OSCExample.h"

@implementation OSCExample

+ (OSCExample *)sharedInstance
{
    static OSCExample *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[OSCExample alloc] init];
    });
    return shared;
}

- (void)sendTestOSCmessageToMyself
{
    OSCHelper *helper = [OSCHelper sharedInstance];
        
    // set ourself as the delegate
    // we will get callbacks from the OSCHelper via the methods defined
    // in the OSCHelperDelegate protocol in OSCHelper.h
    helper.delegate = self;
    
    // create input and output ports on same port so we get the message
    [helper createInputOnPortNumber:6449];
    [helper createOutputWithAdress:@"127.0.0.1" andPortNumber:6449];
    
    // create message
    [helper createMessageWithAddressPath:@"/osc/example"];
    
    // add data (our wrapper supports ints, floats and strings!)
    [helper addIntToMessage:arc4random() % 100];
    [helper addFloatToMessage:123.456];
    [helper addStringToMessage:@"Hello! This is a string in an OSC message"];
    
    // send the message
    [helper sendCreatedMessage];
}

#pragma mark - OSCHelperDelegate

- (void)OSCdataReceived:(NSArray *)array
{
    // fast enumerate over the values in array
    // id just means we are not sure if all the values in the array are of the same type
    // so it will just pull values out and store them in the generic id pointer
    for ( id value in array )
    {
        // did we get a number?
        if ( [value isKindOfClass:[NSNumber class]] )
        {
            if ( CFNumberIsFloatType((__bridge CFNumberRef)(NSNumber *)value) )
            {
                float f = [value floatValue];
                NSLog(@"[OSCExample] OSC FLOAT value received: %f", f);
            }
            else
            {
                int i = [value intValue];
                NSLog(@"[OSCExample] OSC INT value received: %d", i);
            }
        }
        else
        {
            NSString *str = (NSString *)value;
            NSLog(@"[OSCExample] OSC STRING value received: %@", str);
        }
    }
}

@end
