//
//  NSObject+SCKUser_CurrentUser.m
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import "SCKUser+CurrentUser.h"

@implementation SCKUser (CurrentUser)

static SCKUser *_currentUser;

+(SCKUser *)currentUser {
  if (!_currentUser) {
    _currentUser = [SCKUser MR_findFirst];
  }
  
  return _currentUser;
}

+(SCKUser *)createUser:(NSString *)name withEmail:(NSString *)email {
  SCKUser *user = [SCKUser MR_createEntity];
  user.name = name;
  user.email = email;
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
  return user;
}

@end
