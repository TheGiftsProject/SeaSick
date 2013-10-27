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

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *authentications;
@end

@interface SCKUser (CoreDataGeneratedAccessors)

- (void)addAuthenticationsObject:(SCKAuthentication *)value;
- (void)removeAuthenticationsObject:(SCKAuthentication *)value;
- (void)addAuthentications:(NSSet *)values;
- (void)removeAuthentications:(NSSet *)values;

@end
