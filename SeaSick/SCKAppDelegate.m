//
//  SCKAppDelegate.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import "SCKAppDelegate.h"
#import "SCKLoginViewController.h"
#import "SCKViewController.h"
#import <SimpleAudioEngine.h>


@implementation SCKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:0.3];
  [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"background.mp3" loop:YES];
  
  return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  // attempt to extract a token from the url
  return [FBAppCall handleOpenURL:url
                sourceApplication:sourceApplication
                      withSession:[FBSession activeSession]];
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
  [[CCDirector sharedDirector] pause];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
  
    [FBAppCall handleDidBecomeActiveWithSession:[FBSession activeSession]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FBSession activeSession] close];
}

@end
