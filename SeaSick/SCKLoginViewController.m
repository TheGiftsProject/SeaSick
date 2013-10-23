//
//  SCKLoginViewController.m
//  SeaSick
//
//  Created by Itay Adler on 22/10/2013.
//
//

#import "SCKLoginViewController.h"
#import "SCKAppDelegate.h"
#import "SCKViewController.h"

@interface SCKLoginViewController ()
@property (nonatomic, strong) SCKAppDelegate *appDelegate;
@end

@implementation SCKLoginViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:true];
  
  if([[FBSession activeSession] isOpen]){
    self.loginToFacebookBtn.titleLabel.text = @"Logout";
    [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
  }

}
- (IBAction)loginClicked:(UIButton *)sender {
  // this button's job is to flip-flop the session from open to closed
  FBSession *activeSession = [FBSession activeSession];
  if (activeSession.isOpen) {
    // if a user logs out explicitly, we delete any cached token information, and next
    // time they run the applicaiton they will be presented with log in UX again; most
    // users will simply close the app or switch away, without logging out; this will
    // cause the implicit cached-token login to occur on next launch of the application
    [activeSession closeAndClearTokenInformation];
    self.loginToFacebookBtn.titleLabel.text = @"Login to Facebook";
    
  } else {
    self.loginToFacebookBtn.titleLabel.text = @"Log out";
    if (activeSession.state != FBSessionStateCreated) {
      // Create a new, logged out session.
      activeSession = [[FBSession alloc] init];
    }
    
    // if the session isn't open, let's open it now and present the login UX to the user
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
             [self performSegueWithIdentifier:@"loggedInSegue" sender:user];
           }
         }];
      }
    }];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if([sender isKindOfClass:[SCKLoginViewController class]]) {
    SCKViewController *viewController = [segue destinationViewController];
    NSDictionary<FBGraphUser> *user = (NSDictionary<FBGraphUser> *)sender;
    viewController.playerName = user.name;
  }
}

- (SCKAppDelegate *)appDelegate {
  if (!_appDelegate) {
    _appDelegate = [[UIApplication sharedApplication]delegate];
  }
  
  return _appDelegate;
}

@end
