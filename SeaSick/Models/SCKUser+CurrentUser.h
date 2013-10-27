//
//  NSObject+SCKUser_CurrentUser.h
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import <Foundation/Foundation.h>
#import "SCKUser.h"
#import "SCKAuthentication.h"

@interface SCKUser (CurrentUser)

@property (nonatomic, retain, readonly) NSString *email;
@property (nonatomic, retain, readonly) NSString *name;

+ (SCKUser *)currentUser;
+ (SCKUser *)createFromAuthentication:(SCKAuthentication *)authentication;
+ (void)clearCurrentUser;
- (void)logout;

@end
