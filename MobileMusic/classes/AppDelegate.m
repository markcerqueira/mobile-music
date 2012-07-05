//
//  AppDelegate.m
//  MobileMusic
//
//  Created by Mark on 6/20/12.
//  Copyright (c) 2012 Tronic 2012. All rights reserved.
//

#import "AppDelegate.h"

#import "MobileMusicUITouchWindow.h"
#import "GLViewController.h"
#import "AudioControlViewController.h"
#import "MobileMusicCoreBridge.h"
#import "AccelerometerHelper.h"
#import "LocationHelper.h"
#import "NetworkingExample.h"
#import "TabBarNubViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) MobileMusicUITouchWindow *touchWindow;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) GLViewController *GLviewController;
 
@end


@implementation AppDelegate

@synthesize touchWindow;
@synthesize navigationController;
@synthesize GLviewController;

- (void)setUpNavigationStack
{
    // create our custom window that will pass touches nicely between UIKit and GL (MobileMusicUITouchWindow)
    self.touchWindow = [[MobileMusicUITouchWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // allocate our GL view controller
    self.GLviewController = [[GLViewController alloc] init];
    
    // allocate our UIKit-based audio control dashboard
    AudioControlViewController *audioControlVC = [[AudioControlViewController alloc] init];
    
    // setup navigation view controller with audio control view controller at the root
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:audioControlVC];
    
    // add the tab-bar control to the navigation controllers view
    [self.navigationController.view addSubview:[TabBarNubViewController sharedInstance].view];
    
    // setting the frame of a view repositions it in the window
    // in this case, we are moving the tab bar to the bottom of the screen
    [TabBarNubViewController sharedInstance].view.frame = CGRectMake( 0, 
                                                                     self.touchWindow.frame.size.height, 
                                                                     self.touchWindow.frame.size.width,
                                                                     self.touchWindow.frame.size.height );
    
    // hide navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    // the navigation controller will be the root view of the whole app (Window is the top-most UI property)
    self.touchWindow.rootViewController = self.navigationController;
    
    // add the GL view controller then push it to the back (this means the GL view will be below everything else)
    // to see the GL layer, views above it need to be clear/transparent!
    [self.touchWindow addSubview:[self.GLviewController view]];
    [self.touchWindow sendSubviewToBack:[self.GLviewController view]];
    
    // show the window - if you do not call this you may not see anything!
    [self.touchWindow makeKeyAndVisible];
    
    // route touches to the GL view controller
    [self.touchWindow setTouchDelegate:self.GLviewController];
    
}

// override point for customization after application launch
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // this will set up all our initial view controllers
    [self setUpNavigationStack];
    
    // initialize helpers
    [AccelerometerHelper sharedInstance];
    [LocationHelper sharedInstance];
    
    // initialize audio!
    [[MobileMusicCoreBridge sharedInstance] initializeAudio];
    
    // example network call that fetches 2 tweets
    [NetworkingExample returnLatestTopTweets:2];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[MobileMusicCoreBridge sharedInstance] terminateAudio];
}

@end
