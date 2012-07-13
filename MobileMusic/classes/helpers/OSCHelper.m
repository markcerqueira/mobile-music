//
//  OSCHelper.m
//  MobileMusic
//
//  Created by Mark on 7/12/12.
//

#import "OSCHelper.h"
#import "OSCManager.h"
#import "OSCConstants.h"

// private interface declaration
@interface OSCHelper ()

@property (nonatomic, strong) OSCManager *oscManager;
@property (nonatomic, strong) OSCOutPort *outPort;

@property (nonatomic, strong) OSCMessage *message;

@end

@implementation OSCHelper

@synthesize delegate;

@synthesize oscManager;
@synthesize outPort;

@synthesize message;

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        // create our OSCManager instance that will be shared
        self.oscManager = [[OSCManager alloc] init];
        
        // set up our helper as the delegate
        [self.oscManager setDelegate:self];
    }
    
    return self;
}

+ (OSCHelper *)sharedInstance
{
    static OSCHelper *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[OSCHelper alloc] init];
    });
    return shared;
}

- (void)createInputOnPortNumber:(NSInteger)inputPortNumber
{
    [self.oscManager createNewInputForPort:inputPortNumber];
}

- (void)createOutputWithAdress:(NSString *)outgoingAddress andPortNumber:(NSInteger)outputPortNumber
{
    self.outPort = [[OSCOutPort alloc] initWithAddress:outgoingAddress andPort:outputPortNumber];
}

#pragma mark Message Creation / Sending

- (void)createMessageWithAddressPath:(NSString *)addressPath;
{
    if ( self.message )
    {
        self.message = nil;
    }

    self.message = [OSCMessage createWithAddress:addressPath];
    
    if ( self.message == nil )
    {
        NSLog(@"[OSCHelper] error creating OSC input port!");
    }
}

- (void)addIntToMessage:(NSInteger)intValue
{
    [self.message addInt:intValue];
}

- (void)addFloatToMessage:(float)floatVal
{
    [self.message addFloat:floatVal];
}

- (void)addStringToMessage:(NSString *)stringValue
{
    [self.message addString:stringValue];
}

- (void)sendCreatedMessage
{
    // send the message...
    [self.outPort sendThisMessage:self.message];
    
    // ...then clear the message so it can be re-used later
    self.message = nil;
}

#pragma mark - OSCManagerDelegate

- (void)addOSCvalue:(OSCValue *)value toArray:(NSMutableArray *)array
{
    switch ( value.type )
    {
        case OSCValInt:
        {
            [array addObject:[NSNumber numberWithInt:[value intValue]]];
            break;
        }
        case OSCValFloat:
        {
            [array addObject:[NSNumber numberWithFloat:[value floatValue]]];
            break;
        }
        case OSCValString:
        {
            [array addObject:[value stringValue]];
            break;
        }
    } 
}

- (void)receivedOSCMessage:(OSCMessage *)msg
{
    // value retrieval is a little tricky - if you send one value in your message, it can be accessed
    // at msg.value, but if you send multiple values it can be accessed at msg.valueArray which
    // returns an array of your value
    //
    // if you send multiple values, but access msg.value, you will get ONLY the first value sent
    
    NSLog(@"[OSCHelper] OSC message received");
    
    // first, see if we got multiple values by checking msg.valueArray
    NSMutableArray *values = msg.valueArray;
    
    NSMutableArray *returnValues = [NSMutableArray array];
    
    // we got multiple values!
    if ( values )
    {    
        for ( OSCValue *oscValue in values )
        {
            [self addOSCvalue:oscValue toArray:returnValues];
        }
    }
    else
    {
        // otherwise we just got one value - pull it out
        
        // get the value
        OSCValue *value = msg.value;
        
        [self addOSCvalue:value toArray:returnValues];
    }
    
    // ensure the delegate is not nil and that the delegate responds properly to the selector
    if ( self.delegate && [self.delegate respondsToSelector:@selector(OSCdataReceived:)] )
    {
        [self.delegate OSCdataReceived:returnValues];
    }
}

@end
