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
#import "MBProgressHUD.h"

@interface SCKTopViewController ()

@end

@implementation SCKTopViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  [FBSession setActiveSession:[FBSession new]];
  FBSession *activeSession = [FBSession activeSession];
  if (activeSession.state == FBSessionStateCreatedTokenLoaded) {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Fetching user data";
    FBSession *activeSession = [FBSession activeSession];
    if (activeSession.state == FBSessionStateCreatedTokenLoaded) {
      [activeSession openWithCompletionHandler:^(FBSession *session,
                                                 FBSessionState status,
                                                 NSError *error) {
        [FBSession setActiveSession:session];
        if (session.isOpen) {
          [[FBRequest requestForMe] startWithCompletionHandler:
           ^(FBRequestConnection *connection,
             NSDictionary<FBGraphUser> *user,
             NSError *error) {
             if (!error) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               [self performSegueWithIdentifier:@"mainSegue" sender:user];
             }
           }];
        }
      }];
    }
  } else {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  SCKViewController *viewController = [segue destinationViewController];
  if ([sender isKindOfClass:[NSDictionary class]]) {
    if ([sender conformsToProtocol:@protocol(FBGraphUser)]) {
      NSDictionary<FBGraphUser> *user = (NSDictionary<FBGraphUser> *)sender;
      viewController.playerName = user.name;
    }
  }

}

@end
