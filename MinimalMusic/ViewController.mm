//
//  ViewController.m
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ViewController.h"
#import "Audio.h"

@interface ViewController ()
{
    Audio audio;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    audio.start();
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)keyDown:(id)sender
{
    audio.keyDown();
}

- (IBAction)keyUp:(id)sender
{
    audio.keyUp();
}

@end
