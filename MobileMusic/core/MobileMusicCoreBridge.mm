//
//  MobileMusicCoreBridge.mm
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import "MobileMusicCoreBridge.h"
#import "MMAudio.h"

@interface MobileMusicCoreBridge ()
{
    MMCoreBridge *coreBridge;
}
@end

@implementation MobileMusicCoreBridge

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        coreBridge = new MMCoreBridge();
    }
    
    return self;
}

+ (MobileMusicCoreBridge *)sharedInstance
{
    static MobileMusicCoreBridge *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[MobileMusicCoreBridge alloc] init];
    });
    
    return shared;
}

- (void)initializeAudio
{    
    coreBridge->startAudio();
}

- (void)terminateAudio
{
    delete coreBridge;
}

@end

#pragma mark - C++ Bridge

#ifdef __cplusplus

bool MMCoreBridge::startAudio()
{
    mmAudio = MMAudio::instance();
    mmAudio->start();
    
    return true;
}

#endif
