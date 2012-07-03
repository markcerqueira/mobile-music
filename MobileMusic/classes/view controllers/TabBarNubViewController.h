//
//  TabBarNubViewController.h
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import <UIKit/UIKit.h>

@interface TabBarNubViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (strong, nonatomic) IBOutlet UISlider *sliderLeft;
@property (strong, nonatomic) IBOutlet UISlider *sliderRight;

+ (TabBarNubViewController *)sharedInstance;

- (void)hideTabBar;

- (void)restoreTabBar;

@end

// a non-standard view frame requires a custom frame class to soak up touches properly
@interface TabBarView : UIView

@end

