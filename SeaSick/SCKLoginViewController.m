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
#import "SCKFacebookAuthentication+Login.h"
#import "SCKUser+CurrentUser.h"

@interface SCKLoginViewController ()
@property (nonatomic, strong) SCKAppDelegate *appDelegate;
@end

@implementation SCKLoginViewController

- (IBAction)loginClicked:(UIButton *)sender {
    [SCKFacebookAuthentication login:^(SCKAuthentication *auth, NSError *error) {
        SCKUser *user = [SCKUser createFromAuthentication:auth];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (SCKAppDelegate *)appDelegate {
  if (!_appDelegate) {
    _appDelegate = [[UIApplication sharedApplication]delegate];
  }
  
  return _appDelegate;
}

@end
