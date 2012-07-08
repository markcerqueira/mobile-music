//
//  TabBarNubViewController.m
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import "TabBarNubViewController.h"

#ifdef MOBILE_MUSIC
#import "MobileMusicCoreBridge.h"
#endif

@interface TabBarView ()

@property (nonatomic, readwrite, assign) TabBarNubViewController *tabBarNubViewController;
@property (nonatomic, readwrite, retain) UIButton *hideShowButton;

@end

@implementation TabBarView

@synthesize tabBarNubViewController;
@synthesize hideShowButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self insertSubview:button atIndex:0];
        
        // add the button to exceed the bounds of the custom view
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            button.frame = CGRectMake(344, -40, 80, 60);
        }
        else
        {
            button.frame = CGRectMake(130, -30, 60, 60);
        }
        
        self.userInteractionEnabled = YES;
        
        self.hideShowButton = button;
        [self.hideShowButton addTarget:self action:@selector(hideShowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // this soaks up touches beyond the frame of the view if they are within the toggle button's frame
    if ( CGRectContainsPoint(self.frame, point) || CGRectContainsPoint(self.hideShowButton.frame, point) )
        return YES;
    
    return [super pointInside:point withEvent:event];
}

- (void)hideShowButtonPressed:(id)sender
{
    [self.tabBarNubViewController performSelector:@selector(toggleTabBarShown:) withObject:sender];    
}

@end

#pragma mark - TabBarNubViewController

@interface TabBarNubViewController ()
{
    BOOL exposed;
}

@end

@implementation TabBarNubViewController

@synthesize onOffSwitch;
@synthesize segmentedController;
@synthesize sliderLeft;
@synthesize sliderRight;

+ (TabBarNubViewController *)sharedInstance
{
    static TabBarNubViewController *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[TabBarNubViewController alloc] init];
    });
    
    return shared;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    exposed = NO;
    
    [(TabBarView *)self.view setTabBarNubViewController:self];
}

- (void)moveTabBarIntoPlace
{
    if ( exposed )
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation( 0.0 , -150.0 );
            
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            self.view.transform = CGAffineTransformIdentity;
            
        } completion:nil];
    }
}

- (IBAction)toggleTabBarShown:(id)sender
{
    exposed = !exposed;
    
    [self moveTabBarIntoPlace];
}

- (void)exposeTabBarIfNeeded
{
    if ( exposed ) 
        return;
    
    self.view.transform = CGAffineTransformIdentity;
    
    exposed = YES;
    
    [self moveTabBarIntoPlace];
}

- (void)hideTabBar
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation( 0.0 , 100.0 );
        
    } completion:nil];
}

- (void)restoreTabBar
{
    [self moveTabBarIntoPlace];
}

#pragma mark - Actions

- (IBAction)switchToggled:(id)sender
{
    UISwitch *theSwitch = (UISwitch *)sender;
    
    BOOL on = theSwitch.on;
    
    NSLog(@"[TabBarNubViewController] switch is %@", on ? @"ON" : @"OFF");
}

- (IBAction)segmentedControllerValueChanged:(id)sender
{
    UISegmentedControl *theSegmentedControl = (UISegmentedControl *)sender;
    
    int selectedComponent = theSegmentedControl.selectedSegmentIndex;
    
    NSLog(@"[TabBarNubViewController] selected segment is %d", selectedComponent);
    
#ifdef MOBILE_MUSIC
    [[MobileMusicCoreBridge sharedInstance] segmentedControlValueChangedTo:selectedComponent];
#endif
}

- (IBAction)sliderLeftChanged:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    
    NSLog(@"[AudioControlViewController] left slider value changed to %f", theSlider.value);
}

- (IBAction)sliderRightChanged:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    
    NSLog(@"[AudioControlViewController] right slider value changed to %f", theSlider.value);
}

@end
