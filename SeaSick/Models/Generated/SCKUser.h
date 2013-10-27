//
//  SCKUser.h
//  SeaSick
//
//  Created by Danni Friedland on 10/27/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCKAuthentication;

@interface SCKUser : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) SCKAuthentication *authentications;

@end
