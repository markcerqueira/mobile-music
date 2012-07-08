//
//  MotionHelper.m
//  MobileMusic
//
//  Created by Mark on 7/5/12.
//

#import "MotionHelper.h"

@implementation MotionHelper

@synthesize magnetometerData;
@synthesize gyroData;
@synthesize accelerometerData;

+ (MotionHelper *)sharedInstance
{
    static MotionHelper *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[MotionHelper alloc] init];
    });
    return shared;
}

- (void)startAccelerometer
{
    if ( motionManager.accelerometerAvailable )
    {
        [motionManager startAccelerometerUpdates];
        
        NSLog(@"[MotionHelper] accelerometer updates started");
    }
    else
    {
        NSLog(@"[MotionHelper] accelerometer not available");
    }
}

- (void)startGyroscope
{
    if ( motionManager.gyroAvailable )
    {
        [motionManager startGyroUpdates];
        
        NSLog(@"[MotionHelper] gyroscope updates started");
    }
    else
    {
        NSLog(@"[MotionHelper] gyroscope not available");
    }
}

- (void)startMagnetometer
{
    if ( motionManager.magnetometerAvailable )
    {
        [motionManager startMagnetometerUpdates];
        
        NSLog(@"[MotionHelper] magnetometer updates started");
    }
    else
    {
        NSLog(@"[MotionHelper] magnetometer not available");
    }
}

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        // allocate our motion manager instance
        motionManager = [[CMMotionManager alloc] init];
                
        [self performSelector:@selector(updateMotionData) withObject:nil afterDelay:0.1f]; 
    }
    
    return self;
}

- (void)updateMotionData
{ 
    self.accelerometerData = motionManager.accelerometerData;
    self.gyroData = motionManager.gyroData;
    self.magnetometerData = motionManager.magnetometerData;
    
    // NSLog(@"[MotionHelper] accelerometer data is %f, %f, %f", self.accelerometerData.acceleration.x, self.accelerometerData.acceleration.y, self.accelerometerData.acceleration.z);
    // NSLog(@"[MotionHelper] gyroscope data is %f, %f, %f", self.gyroData.rotationRate.x, self.gyroData.rotationRate.y, self.gyroData.rotationRate.z);
    // NSLog(@"[MotionHelper] magnetometer data is %f, %f, %f", self.magnetometerData.magneticField.x, self.magnetometerData.magneticField.y, self.magnetometerData.magneticField.z);
}

#pragma mark - Public Functions

- (void)startCollectingMotionData
{
    [self startAccelerometer];
    [self startGyroscope];
    [self startMagnetometer];
    
    dataCollectionTimer =  [NSTimer timerWithTimeInterval:0.01 // 100 times per second
                                                   target:self 
                                                 selector:@selector(updateMotionData) 
                                                 userInfo:nil 
                                                  repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:dataCollectionTimer forMode:NSRunLoopCommonModes];
}

- (void)stopCollectingMotionData
{
    [dataCollectionTimer invalidate];
    dataCollectionTimer = nil;
}

@end
