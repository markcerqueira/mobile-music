//
//  ProgrammaticViewController.m
//  MobileMusic
//
//  Created by Mark on 7/5/12.
//

#import "ProgrammaticViewController.h"
#import "MobileMusicCoreBridge.h"

// nothing private to declare in this interface here
@interface ProgrammaticViewController ()

@end

// implementation!
@implementation ProgrammaticViewController

@synthesize myLabel;
@synthesize mySlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view
    //
    // Here we will add our slider/label programatically, saving references to them in case
    // we need to change them later
    
    // we are going to place/size all elements relative to the width and size of the screen
    // so get those values here
    float screenWidth = self.view.frame.size.width;
    float screenHeight = self.view.frame.size.height;
    
    // place object at 0,0 (top left corner) and make it the width of the screen and the height
    // 1/10th the height
    // this assignment here is similar to what happens when you connect an IBOutlet to an element
    // in an InterfaceBuilder file (you also specify size and position here)
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                             screenWidth, screenHeight/10)];
    
    // all the set up below is basically what you'd do in a .xib file if you were using
    // Interface builder
    
    // place center of the label on the center of the screen x-wise, 1/4th down from the top
    // of the screen
    self.myLabel.center = CGPointMake(screenWidth/2, screenHeight/4);
    
    // set text alignment of the label to center
    self.myLabel.textAlignment = UITextAlignmentCenter;
    
    // set text color to yellow
    self.myLabel.textColor = [UIColor yellowColor];
    
    // set label background to be clear
    self.myLabel.backgroundColor = [UIColor clearColor];
    
    // set default text
    self.myLabel.text = @"This view was built programmatically";
    
    // the label has not been added to our view just yet, it's just an object with a bunch
    // of properties modified
    // add it to the view of the view controller so it can be seen (if you are using Interface
    // Builder), this is the same as dragging it into the view
    [self.view addSubview:self.myLabel];
    
    // slider creation/setup - similar to above
    
    // the height of the slider (last value in CGRectMake) doesn't matter because the height of
    // a UISlider is fixed
    self.mySlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
    
    // if you ever want to hard-code values, you will likely want different hard-coded values for
    // iPhone vs iPad - you can figure out what family of device you are on like this
    //
    // this code will make the slider be farther down on the iPad when compared to iPhone
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        // on an iPad!
        self.mySlider.center = CGPointMake(screenWidth/2.0, 100);
    }
    else
    {
        // on an iPhone/iPod touch
        self.mySlider.center = CGPointMake(screenWidth/2.0, 5);
    }
    
    // set some properties we would normally set in Interface Builder
    // see the UISlider class reference for all the properties you can set/access!
    self.mySlider.minimumValue = 0.0;
    self.mySlider.maximumValue = 1.0;
    self.mySlider.value = 0.5;
    
    // add slider to view
    [self.view addSubview:self.mySlider];
    
    // now we want to be able to know when the slider value is updated - if using Interface Builder,
    // we'd define IBAction methods and then drag from the slider to File's Owner (this view controller)
    // to catch whatever changes we want - we can do all that programmatically with the addTarget method!
    
    // here, we are saying that our view controller is going to be a target for touch down events on our
    // slider - on those events, touchDownOnSlider: will be called
    // the : following touchDownOnSlider means we are going to pass one argument - which will be sender
    // the touchDownOnSlider method looks like: - (IBAction)touchDownOnSlider:(id)sender
    [self.mySlider addTarget:self action:@selector(touchDownOnSlider:) forControlEvents:UIControlEventTouchDown];
    
    // same idea for catching value changed notifications which will call back to:
    // - (IBAction)valueChangedOnSlider:(id)sender
    [self.mySlider addTarget:self action:@selector(valueChangedOnSlider:) forControlEvents:UIControlEventValueChanged];    
}

- (IBAction)touchDownOnSlider:(id)sender
{
    // we caught a touch down event! update the label
    self.myLabel.text = @"I feel you touching the slider above me!";
}

- (IBAction)valueChangedOnSlider:(id)sender
{
    // the slider is moving around! update the label!
    
    // sender is our slider, cast it!
    UISlider *theSenderSlider = (UISlider *)sender;
    
    // to print the value we can use our reference to it (self.mySlider) or the sender we just casted!
    self.myLabel.text = [NSString stringWithFormat:@"The value of the slider is: %f", theSenderSlider.value];
    
    // send our volume value to the bridge
    [[MobileMusicCoreBridge sharedInstance] volumeChanged:self.mySlider.value];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // release any retained subviews of the main view
    self.myLabel = nil;
    self.mySlider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
