//
//  User.h
//  SeaSick
//
//  Created by Itay Adler on 23/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * facebookEmail;
@property (nonatomic, retain) NSString * facebookName;
@property (nonatomic, retain) NSNumber * score;

@end
