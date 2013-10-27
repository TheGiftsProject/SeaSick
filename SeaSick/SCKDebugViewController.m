//
//  SCKDebugViewController.m
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import "SCKDebugViewController.h"
#import "SCKUser+CurrentUser.h"

@interface SCKDebugViewController ()

@end

@implementation SCKDebugViewController

- (IBAction)loginClicked:(UIButton *)sender {
    [[SCKUser currentUser] logout];
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
