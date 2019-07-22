//
//  AppDelegate.m
//  ObjectCBootpay
//
//  Created by YoonTaesup on 2019. 3. 14..
//  Copyright © 2019년 kr.co.bootpay. All rights reserved.
//

#import "AppDelegate.h"
#import "SwiftyBootpay-Swift.h"

@interface AppDelegate ()
@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Bootpay sharedInstance] appLaunch: @"5a52cc39396fa6449880c0f0"];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[Bootpay sharedInstance] sessionActive: false];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[Bootpay sharedInstance] sessionActive: true];
}

- (void)applicationWillTerminate:(UIApplication *)application { 
}


@end
