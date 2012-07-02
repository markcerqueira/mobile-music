//
//  LocationHelper.m
//  MobileMusic
//
//  Created by Mark on 7/1/12.
//

#import "LocationHelper.h"

@interface LocationHelper () <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D lastLocation;
    CLHeading *lastHeading;
}

- (void)turnOffLocationTracking;
- (void)turnOnLocationTracking;

@end


@implementation LocationHelper

+ (LocationHelper *)sharedInstance
{
    static LocationHelper *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[LocationHelper alloc] init];
    });
    return shared;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // sign up for app delegate notifications to turn location tracking on and off when the app
        // is backgrounded and brought back from background
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(turnOffLocationTracking)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(turnOnLocationTracking)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(turnOffLocationTracking)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(turnOffLocationTracking)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        // turn on location tracking!
        [self turnOnLocationTracking];
    }
    
    return self;
}

- (CLLocationCoordinate2D)location
{
    return lastLocation;
}

- (CLHeading *)heading
{
    return lastHeading;
}

#pragma mark - Private Functions

- (void)turnOffLocationTracking
{
    [locationManager stopUpdatingLocation];
}

- (void)turnOnLocationTracking
{
    [locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{        
    lastLocation = newLocation.coordinate;
    
    // NSLog(@"[LocationHelper] location updated to: %f, %f", lastLocation.latitude, lastLocation.longitude);
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    lastHeading = newHeading;
    
    NSLog(@"[LocationHelper] heading updated to: %f", lastHeading.magneticHeading);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"[LocationHelper] not able to retrieve location with error: %@", [error localizedDescription]);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"[LocationHelper] authorization status changed to: %d", status);
}

@end
