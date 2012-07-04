//
//  MobileMusicCoreBridge.mm
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import "MobileMusicCoreBridge.h"
#import "MMAudio.h"
#import "Flare.h"
#import "FlareSound.h"

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

- (void)sliderValueChangedTo:(float)sliderValue
{
    // call into the audio-layer here with something
    Flare::setBreathingRate(1.0/(0.5+(1-sliderValue)*3.5));
}

- (void)volumeChanged:(float)volume
{
    // go Spencer!
    MMAudio::instance()->m_masterGain = volume;
}

- (void)segmentedControlValueChangedTo:(int)segControlValue
{
    FlareSound::SoundMode mode;
    switch(segControlValue)
    {
        case 0:
            mode = FlareSound::BLIT_MODE;
            break;
        case 1:
            mode = FlareSound::BANDEDWG_MODE;
            break;
        case 2:
            mode = FlareSound::WAVFILE_MODE;
            break;
        case 3:
            mode = FlareSound::NOISE_MODE;
            break;
    }
    
    FlareSound::setGlobalSoundMode(mode);
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
