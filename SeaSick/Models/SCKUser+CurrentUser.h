//
//  NSObject+SCKUser_CurrentUser.h
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import <Foundation/Foundation.h>
#import "SCKUser.h"

@interface SCKUser (CurrentUser)

+(SCKUser *)currentUser;
+(SCKUser *)createUser:(NSString *)name withEmail:(NSString *)email;

@end
