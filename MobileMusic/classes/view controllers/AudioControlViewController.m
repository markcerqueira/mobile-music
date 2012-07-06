//
//  AudioControlViewController.m
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import "AudioControlViewController.h"
#import "MobileMusicCoreBridge.h"

@implementation AudioControlViewController

@synthesize slider;
@synthesize volumeSlider;

- (void)viewDidUnload
{        
    // release references to outlets
    [self setSlider:nil];
    [self setVolumeSlider:nil];
    
    [super viewDidUnload];
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
    NSLog(@"[AudioControlViewController] touch down detected on volume slider");
}

- (IBAction)volumeSliderChanged:(id)sender
{
    // if we did not have an IBOutlet to the volumeSlider, we could get it from sender (sender is the object
    // that dispatched the action - in this case the slider)
    float valueFromOutlet = volumeSlider.value;
    
    UISlider *myVolumeSlider = (UISlider *)sender;
    float valueFromSender = myVolumeSlider.value;
    
    // valueFromOutlet and valueFromSender will be the same because sender == volumeSlider!
    
    NSLog(@"[AudioControlViewController] from outlet: %f, from sender: %f", valueFromOutlet, valueFromSender);
    
    // send our volume value to the bridge
    [[MobileMusicCoreBridge sharedInstance] volumeChanged:valueFromOutlet];
}

@end
