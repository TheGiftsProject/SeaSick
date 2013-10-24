//
//  SCKAuthentication.h
//  SeaSick
//
//  Created by Itay Adler on 24/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCKUser;

@interface SCKAuthentication : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) SCKUser *user;

@end
