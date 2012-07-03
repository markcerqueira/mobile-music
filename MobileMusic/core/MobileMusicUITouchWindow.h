//
//  UITouchWindow.h
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//
//  Borrows heavily from MagicUITouchWindow by Nick Kruge (Smule, Inc.)
//
//  the window is overriden to allow more graceful touch handling
//  it could be done instead on the specific view controllers that need to send touches to the GL
//  controller, but this way we can have it always on and do not have to think about it
//

#import <UIKit/UIKit.h>

@protocol MagicTouchDelegate;

@interface MobileMusicUITouchWindow : UIWindow

@property (nonatomic, assign) id<MagicTouchDelegate> touchDelegate;

@end

@protocol MagicTouchDelegate <NSObject>

@required
- (void)handleTouches:(NSSet *)touches withEvent:(UIEvent *)event;

@end
