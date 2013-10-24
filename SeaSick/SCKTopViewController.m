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
#import "SCKUser+CurrentUser.h"

@interface SCKTopViewController ()

@end

@implementation SCKTopViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  if ([SCKUser currentUser]) {
     [self performSegueWithIdentifier:@"mainSegue" sender:self];
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
