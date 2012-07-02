//
//  MMAccelerometerHelper.m
//  MobileMusic
//
//  Created by Mark on 7/1/12.
//

#import "AccelerometerHelper.h"

@implementation AccelerometerData 

@synthesize accelerationX;
@synthesize accelerationY;
@synthesize accelerationZ;

@synthesize timestamp;

@end


@implementation AccelerometerHelper
{
    UIAccelerationValue x;
    UIAccelerationValue y;
    UIAccelerationValue z;
    
    NSTimeInterval time;
}

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        // add ourselves as a delegate of the accelerometer
        // this will cause the method below to be called when acceleration data is available
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    }
    
    return self;
}

- (void)dealloc
{
    // remove ourselves as the delegate if we are deallocated so we don't continue
    // getting called back to
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];    
}

+ (AccelerometerHelper *)sharedInstance
{
    static AccelerometerHelper *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[AccelerometerHelper alloc] init];
    });
    return shared;
}

- (AccelerometerData *)accelerationData
{
    // create and return acceleration data from cached data
    AccelerometerData *data = [[AccelerometerData alloc] init];
    
    data.accelerationX = x;
    data.accelerationY = y;
    data.accelerationZ = z;
    
    data.timestamp = time;
    
    return data;
}

#pragma mark - UIAccelerometerDelegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    // cache the most recent acceleration data
    x = acceleration.x;
    y = acceleration.y;
    z = acceleration.z;
    
    time = acceleration.timestamp;
    
    NSLog(@"[AccelerometerHelper] acceleration data received: %f, %f, %f at time %f", x, y, z, time);
}

@end
