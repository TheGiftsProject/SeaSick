//
//  SCKAuthentication.h
//  SeaSick
//
//  Created by Danni Friedland on 10/27/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCKUser;

@interface SCKAuthentication : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SCKUser *user;

@end
