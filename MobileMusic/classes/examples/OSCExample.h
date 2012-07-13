//
//  OSCExample.h
//  MobileMusic
//
//  Created by Mark on 7/12/12.
//

#import <Foundation/Foundation.h>
#import "OSCHelper.h"

// this class is called OSCExample; it inherits from NSObject, and it will implement
// the OSCHelperDelegate protocol taht is defined in OSCHelper.h
@interface OSCExample : NSObject <OSCHelperDelegate>

// shared instance of OSCExample
+ (OSCExample *)sharedInstance;

// this will send an OSC message to yourself at localhost (127.0.0.1)
- (void)sendTestOSCmessageToMyself;

@end
