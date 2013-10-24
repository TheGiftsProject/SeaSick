//
//  SCKFacebookAuthentication+Login.m
//  SeaSick
//
//  Created by Itay Adler on 24/10/2013.
//
//

#import "SCKFacebookAuthentication+Login.h"

@implementation SCKFacebookAuthentication (Login)

+(void)login:(void (^)(NSDictionary<FBGraphUser> *user, NSError *error))loginCallback
{
  [FBSession openActiveSessionWithReadPermissions:@[@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
    [FBSession setActiveSession:session];
    if (session.isOpen) {
      [[FBRequest requestForMe] startWithCompletionHandler:
       ^(FBRequestConnection *connection,
         NSDictionary<FBGraphUser> *user,
         NSError *error) {
           loginCallback(user, error);
       }];
    }
  }];
}

@end
