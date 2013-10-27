//
//  SCKFacebookAuthentication+Login.m
//  SeaSick
//
//  Created by Itay Adler on 24/10/2013.
//
//

#import "SCKFacebookAuthentication+Login.h"
#import <MagicalRecord.h>

@implementation SCKFacebookAuthentication (Login)

+(void)login:(void (^)(SCKFacebookAuthentication *authentication, NSError *error))loginCallback
{
  [FBSession openActiveSessionWithReadPermissions:@[@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
    [FBSession setActiveSession:session];
    if (session.isOpen) {
      [[FBRequest requestForMe] startWithCompletionHandler:
       ^(FBRequestConnection *connection,
         NSDictionary<FBGraphUser> *user,
         NSError *error) {
           if (error) {
               loginCallback(NULL, error);
           } else {
               SCKFacebookAuthentication *auth = [SCKFacebookAuthentication MR_createEntity];
               auth.name = user[@"name"];
               auth.email = user[@"email"];
               loginCallback(auth, error);
           }

       }];
    }
  }];
}

-(void)logout
{
}

@end
