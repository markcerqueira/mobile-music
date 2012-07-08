//
//  OutletsViewController.h
//  MobileMusic
//
//  Created by Mark on 7/7/12.
//

#import <UIKit/UIKit.h>

@interface OutletsViewController : UIViewController
{
    NSTimer *repeatTimer;
}

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) IBOutlet UIButton *buttonA;
@property (nonatomic, strong) IBOutlet UIButton *buttonB;
@property (nonatomic, strong) IBOutlet UIButton *buttonC;

@end
