//
//  SCKFacebookAuthentication+Login.h
//  SeaSick
//
//  Created by Itay Adler on 24/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>
#import "SCKFacebookAuthentication.h"

@interface SCKFacebookAuthentication (Login)

+(void)login:(void (^)(SCKFacebookAuthentication *authentication, NSError *error))loginCallback;
-(void)logout;
//+(void)logout;

@end
