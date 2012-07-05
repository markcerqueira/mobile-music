//
//  MotionHelper.h
//  MobileMusic
//
//  Created by Mark on 7/5/12.
//

// A nice little wrapper around the CoreMotion MotitionManager
// Full class reference can be found here:
// https://developer.apple.com/library/ios/#documentation/CoreMotion/Reference/CMMotionManager_Class/Reference/Reference.html

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MotionHelper : NSObject
{
    CMMotionManager *motionManager;
    NSTimer *dataCollectionTimer;
}

@property (strong, nonatomic) CMMagnetometerData *magnetometerData;
@property (strong, nonatomic) CMAccelerometerData *accelerometerData;
@property (strong, nonatomic) CMGyroData *gyroData;

// returns the MotionHelper singleton
+ (MotionHelper *)sharedInstance;

- (void)startCollectingMotionData;

- (void)stopCollectingMotionData;

@end
