//
//  SCKFacebookAuthentication+Login.h
//  SeaSick
//
//  Created by Itay Adler on 24/10/2013.
//
//

#import <Foundation/Foundation.h>
#import "SCKFacebookAuthentication.h"
#import <FacebookSDK.h>

@interface SCKFacebookAuthentication (Login)

+(void)login:(void (^)(NSDictionary<FBGraphUser> *user, NSError *error))loginCallback;
//+(void)logout;

@end
