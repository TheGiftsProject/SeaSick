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
  
  if(self.appDelegate.session.isOpen){
    self.loginToFacebookBtn.titleLabel.text = @"Logout";
    //[self performSegueWithIdentifier:@"loggedInSegue" sender:self];
  }

}
- (IBAction)loginClicked:(UIButton *)sender {
  // this button's job is to flip-flop the session from open to closed
  if (self.appDelegate.session.isOpen) {
    // if a user logs out explicitly, we delete any cached token information, and next
    // time they run the applicaiton they will be presented with log in UX again; most
    // users will simply close the app or switch away, without logging out; this will
    // cause the implicit cached-token login to occur on next launch of the application
    [self.appDelegate.session closeAndClearTokenInformation];
    self.loginToFacebookBtn.titleLabel.text = @"Login to Facebook";
    
  } else {
    self.loginToFacebookBtn.titleLabel.text = @"Log out";
    if (self.appDelegate.session.state != FBSessionStateCreated) {
      // Create a new, logged out session.
      self.appDelegate.session = [[FBSession alloc] init];
    }
    
    // if the session isn't open, let's open it now and present the login UX to the user
    [self.appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
      // and here we make sure to update our UX according to the new session state
      [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
    }];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if([sender isKindOfClass:[SCKLoginViewController class]]) {
    SCKViewController *viewController = [segue destinationViewController];
    //TODO: Set facebook name etc on the viewController since the FBSession should be accessible here..
  }
}

- (SCKAppDelegate *)appDelegate {
  if (!_appDelegate) {
    _appDelegate = [[UIApplication sharedApplication]delegate];
  }
  
  return _appDelegate;
}

@end
