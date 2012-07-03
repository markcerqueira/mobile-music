//
//  MobileMusicCoreBridge.h
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

/* 
 * The core bridge provides a single place to bridge the Objective-C layer
 * with the C/C++ layer of your code. With a bridge, it becomes easier to 
 * call into Objective-C classes from C++ classes and vice versa.
 *
 * This will help cut down on the Objective-C++ files (.mm) you will need
 * and centralize all the potential ugliness.
 */

#ifdef __OBJC__

@interface MobileMusicCoreBridge : NSObject

// returns the bridge singleton
+ (MobileMusicCoreBridge *)sharedInstance;

// start the audio!
- (void)initializeAudio;

// call on app termination to clean up audio
- (void)terminateAudio;

- (void)sliderValueChangedTo:(float)sliderValue;

@end

#endif


// bridge for the core
#ifdef __cplusplus

class MMAudio;

class MMCoreBridge
{
private:
    MMAudio *mmAudio;
    
public:
    bool startAudio();
};

#endif
