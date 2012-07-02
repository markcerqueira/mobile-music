//
//  MMAccelerometerHelper.h
//  MobileMusic
//
//  Created by Mark on 7/1/12.
//

#import <Foundation/Foundation.h>


// queries to AccelerometerHelper will return these objects that
// contains relevant data
@interface AccelerometerData : NSObject

// typedef double UIAccelerationValue;
@property (nonatomic, readwrite, assign) UIAccelerationValue accelerationX;
@property (nonatomic, readwrite, assign) UIAccelerationValue accelerationY;
@property (nonatomic, readwrite, assign) UIAccelerationValue accelerationZ;

// typedef double NSTimeInterval;
@property (nonatomic, readwrite, assign) NSTimeInterval timestamp;

@end

// 
@interface AccelerometerHelper : NSObject<UIAccelerometerDelegate>

+ (AccelerometerHelper *)sharedInstance;

- (AccelerometerData *)accelerationData;

@end
