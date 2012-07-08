//
//  OutletsViewController.m
//  MobileMusic
//
//  Created by Mark on 7/7/12.
//

#import "OutletsViewController.h"

@interface OutletsViewController ()

@end

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    int selectedSegment = self.segmentedControl.selectedSegmentIndex;
    
    NSLog(@"[OutletsViewController] the selected segment is %d", selectedSegment);
}

- (IBAction)sliderValueChanged:(id)sender
{
    float sliderValue = self.slider.value;
    
    NSLog(@"[OutletsViewController] the slider value is %d", sliderValue);
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
