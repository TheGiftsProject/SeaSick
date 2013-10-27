//
//  SCKLoginViewController.m
//  SeaSick
//
//  Created by Itay Adler on 22/10/2013.
//
//

#import "SCKLoginViewController.h"
#import <FacebookSDK.h>
#import "SCKFacebookAuthentication+Login.h"

@interface SCKLoginViewController ()

@end

@implementation SCKLoginViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:true];
  
  [FBSession setActiveSession:[FBSession new]];
  
  if([[FBSession activeSession] isOpen]){
    self.loginToFacebookBtn.titleLabel.text = @"Logout";
   [self dismissViewControllerAnimated:YES completion:nil];
  }

}
- (IBAction)loginClicked:(UIButton *)sender {
  
  [SCKFacebookAuthentication login:^(NSDictionary<FBGraphUser> *user, NSError *error) {
    SCKFacebookAuthentication *authentication = [SCKFacebookAuthentication new];
    authentication.name = user[@"name"];
    authentication.email = user[@"email"];
//    authentication.user = [SCKUser createUser];
  }];
  // this button's job is to flip-flop the session from open to closed
//  FBSession *activeSession = [FBSession activeSession];
//  if (activeSession.isOpen) {
//    [activeSession closeAndClearTokenInformation];
//    [FBSession setActiveSession:nil];
//    self.loginToFacebookBtn.titleLabel.text = @"Login to Facebook";
//    
//  } else {
//    if (activeSession.state != FBSessionStateCreated) {
//      // Create a new, logged out session.
//      activeSession = [[FBSession alloc] init];
//    }
  
     //[self dismissViewControllerAnimated:YES completion:nil];
//  }
}

@end
