//
//  UITouchWindow.m
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//
//  Borrows heavily from MagicUITouchWindow by Nick Kruge (Smule, Inc.)
//

#import "MobileMusicUITouchWindow.h"

@implementation MobileMusicUITouchWindow

@synthesize touchDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setMultipleTouchEnabled:YES];
        self.touchDelegate = nil;
    }
    
    return self;
}

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    // if any touch is on a UIControl class, such as a button, don't send anything just do the action
    for ( UITouch * t in event.allTouches )
    {
        // here is where we see if it inherits from UIControl and is actually enabled currently
        if ( [t.view.class isSubclassOfClass:[UIControl class]] && t.view.userInteractionEnabled )
            return;
    }
    
    // send the touch to the GL layer
    [touchDelegate handleTouches:event.allTouches withEvent:event];
}

@end
