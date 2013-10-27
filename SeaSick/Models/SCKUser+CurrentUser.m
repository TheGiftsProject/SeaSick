//
//  NSObject+SCKUser_CurrentUser.m
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import <MagicalRecord.h>
#import "SCKUser+CurrentUser.h"
#import "SCKUser.h"
#import "SCKFacebookAuthentication+Login.h"

@implementation SCKUser (CurrentUser)


static SCKUser *_currentUser;

- (NSString *)email
{
    return ((SCKAuthentication *)[[self authentications] anyObject]).email;
}

- (NSString *)name
{
    return ((SCKAuthentication *)[[self authentications] anyObject]).name;
}
+ (void) clearCurrentUser
{
    _currentUser = NULL;
}

+ (SCKUser *)currentUser
{
    if (!_currentUser) {
        _currentUser = [SCKUser MR_findFirst];
    }
    return _currentUser;
}

+ (SCKUser *)createFromAuthentication:(SCKAuthentication *)authentication
{
    SCKUser *user = [SCKUser MR_createEntity];
    [user addAuthenticationsObject:authentication];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return user;
}

- (void)logout
{
//    [[self authentications] enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//        SCKFacebookAuthentication *auth = (SCKFacebookAuthentication *)obj;
//        [auth logout];
//    }];
    [self MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [[self class] clearCurrentUser];
}

@end
