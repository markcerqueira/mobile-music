//
//  OutletsViewController.m
//  MobileMusic
//
//  Created by Mark on 7/7/12.
//

#import "OutletsViewController.h"

@interface OutletsViewController ()

@end

// this #define will determine how many times our updater function is called
#define UPDATER_CALLS_PER_SECOND .1

@implementation OutletsViewController

@synthesize slider;
@synthesize segmentedControl;
@synthesize buttonA;
@synthesize buttonB;
@synthesize buttonC;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.slider = nil;
    self.segmentedControl = nil;
    self.buttonA = nil;
    self.buttonB = nil;
    self.buttonC = nil;
    
    // invalidate/nil the timer is necessary
    if ( repeatTimer )
    {
        [repeatTimer invalidate];
        repeatTimer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
    // the method update will be called UPDATER_CALLS_PER_SECOND times per second repeatedly
    repeatTimer =  [NSTimer timerWithTimeInterval:UPDATER_CALLS_PER_SECOND
                                           target:self 
                                         selector:@selector(updater) 
                                         userInfo:nil 
                                          repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:repeatTimer forMode:NSRunLoopCommonModes];
}

- (void)updater
{
    NSLog(@"[OutletsViewController] updater method called!");
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    int selectedSegment = self.segmentedControl.selectedSegmentIndex;
    
    NSLog(@"[OutletsViewController] the selected segment is %d", selectedSegment);
}

- (IBAction)sliderValueChanged:(id)sender
{
    float sliderValue = self.slider.value;
    
    NSLog(@"[OutletsViewController] the slider value is %f", sliderValue);
}

- (IBAction)buttonATouchDown:(id)sender
{
    NSLog(@"[OutletsViewController] button A touched down");
}

- (IBAction)buttonBTouchDown:(id)sender
{
    NSLog(@"[OutletsViewController] button B touched down");
}

- (IBAction)buttonCTouchDown:(id)sender
{
    NSLog(@"[OutletsViewController] button C touched down");
}

@end
