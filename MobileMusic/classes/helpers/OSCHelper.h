//
//  OSCHelper.h
//  MobileMusic
//
//  Created by Mark on 7/12/12.
//

// A little wrapper around the VVOSCManager
// Allows you to send and receive OSC messages!
// Documentation for OSCManager and its dependencies: http://vidvox.com/rays_oddsnends/vvosc_doc/index.html

#import <Foundation/Foundation.h>

// this delegate protocol will define what methods a delegate of OSCHelper should respond to
// in this case, our OSCHelper will always package data into an NSArray and send it back to the delegate
// your delegate should implement the OSCdataReceived: where it can process the data as it sees fit!
// values in the array will either be NSNumbers (for ints and floats) or NSStrings
@protocol OSCHelperDelegate <NSObject>

- (void)OSCdataReceived:(NSArray *)array;

@end

// defining what OSCHelper does
@interface OSCHelper : NSObject

// the singleton accessor
+ (OSCHelper *)sharedInstance;

// creates a port that will listen for OSC messages on the specified port
- (void)createInputOnPortNumber:(NSInteger)inputPortNumber;

// creates a port that will send OSC messages over the specified port with the specified addressPath
- (void)createOutputWithAdress:(NSString *)outgoingAddress andPortNumber:(NSInteger)outputPortNumber;

// message creation - how to create/send OSC messages
// to create a message, call createMessageWithAddressPath...
- (void)createMessageWithAddressPath:(NSString *)addressPath;

// ...then add whatever data you'd like using...
- (void)addIntToMessage:(NSInteger)intVal;
- (void)addFloatToMessage:(float)floatVal;
- (void)addStringToMessage:(NSString *)stringValue;

// ...when done, call sendCreatedMessage - this sends the message
- (void)sendCreatedMessage;

// id<OSCHelperDelegate> means some class (id is like a generic, void *) pointer that is going to 
// implement the OSCHelperDelegate protocol defined above
@property (nonatomic, assign) id<OSCHelperDelegate> delegate;

@end
