//
//  SCKTopViewController.m
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import "SCKTopViewController.h"
#import "SCKLoginViewController.h"
#import "SCKViewController.h"
#import <FacebookSDK.h>

@interface SCKTopViewController ()

@end

@implementation SCKTopViewController

- (void)viewDidLoad {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [FBSession setActiveSession:[FBSession new]];
  FBSession *activeSession = [FBSession activeSession];
  if (activeSession.state == FBSessionStateCreatedTokenLoaded) {
    SCKLoginViewController *loginViewController = [[self viewControllers] firstObject];
    [loginViewController.view setHidden:true];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  FBSession *activeSession = [FBSession activeSession];
  if (activeSession.state == FBSessionStateCreatedTokenLoaded) {
    [activeSession openWithCompletionHandler:^(FBSession *session,
                                               FBSessionState status,
                                               NSError *error) {
      UIViewController *cont = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SCKViewController"];
      [self presentViewController:cont animated:NO completion:nil];
    }];
  }
}

@end
