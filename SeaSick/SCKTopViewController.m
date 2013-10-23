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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  [FBSession setActiveSession:[FBSession new]];
  FBSession *activeSession = [FBSession activeSession];
  if (activeSession.state == FBSessionStateCreatedTokenLoaded) {
    FBSession *activeSession = [FBSession activeSession];
    if (activeSession.state == FBSessionStateCreatedTokenLoaded) {
      [activeSession openWithCompletionHandler:^(FBSession *session,
                                                 FBSessionState status,
                                                 NSError *error) {
         [self performSegueWithIdentifier:@"mainSegue" sender:self];
      }];
    }
  } else {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
  }
}

@end
