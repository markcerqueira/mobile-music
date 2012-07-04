//
//  AudioControlViewControllerViewController.m
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import "AudioControlViewControllerViewController.h"
#import "MobileMusicCoreBridge.h"

@interface AudioControlViewControllerViewController ()

@end

@implementation AudioControlViewControllerViewController

@synthesize slider;

@synthesize volumeSlider;


- (void)viewDidUnload
{    
    [self setVolumeSlider:nil];
    [super viewDidUnload];

    self.slider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Actions

- (IBAction)sliderValueChanged:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    
    NSLog(@"[AudioControlViewController] slider value changed to %f", theSlider.value);
    
    [[MobileMusicCoreBridge sharedInstance] sliderValueChangedTo:theSlider.value];
}

- (IBAction)volumeSliderTouchDown:(id)sender
{
    NSLog(@"I am about to change stuff!");
}

- (IBAction)volumeSliderChanged:(id)sender
{
    float f = volumeSlider.value;
    
    UISlider *myVolumeSlider = (UISlider *)sender;
    float myValueFromSender = myVolumeSlider.value;
    
    NSLog(@"LOL: %f, %f", f, myValueFromSender);
}

@end
