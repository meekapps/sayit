//
//  AppDelegate.m
//  Say It!
//
//  Created by Mike Keller on 10/1/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
  [self setupPreferences];
    
  MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController"
                                                                    bundle:nil];
  UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
  self.window.rootViewController = mainNC;
    
  self.window.tintColor = [UIColor sayitBlueColor];
  self.window.backgroundColor = [UIColor whiteColor];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void) setupPreferences {
  NSDictionary *defaults = @{@"rate": [NSNumber numberWithFloat:0.5f],
                             @"pitchMultiplier": [NSNumber numberWithFloat:1.0f],
                             @"text": @"Say It!"};
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
