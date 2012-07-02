//
//  LocationHelper.h
//  MobileMusic
//
//  Created by Mark on 7/1/12.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject

// returns the LocationHelper singleton
+ (LocationHelper *)sharedInstance;

// returns the last valid location
// a CLLocationCoordinate2D struct contains a latitude and longitude
// variable of type double
- (CLLocationCoordinate2D)location;

// returns the last valid heading in degrees (i.e. a double ranging from 0 to 359.9)
// the CLHeading struct contains a CLLocationDirection (double) called magneticHeading
- (CLHeading *)heading;

@end
