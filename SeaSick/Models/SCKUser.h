//
//  SCKUser.h
//  SeaSick
//
//  Created by Itay Adler on 24/10/2013.
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
