//
//  SCKDebugViewController.m
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import "SCKDebugViewController.h"
#import <FacebookSDK.h>

@interface SCKDebugViewController ()

@end

@implementation SCKDebugViewController

- (IBAction)loginClicked:(UIButton *)sender {
  [[FBSession activeSession] closeAndClearTokenInformation];
  [FBSession setActiveSession:nil];
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
