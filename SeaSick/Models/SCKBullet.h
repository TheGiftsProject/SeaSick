//
//  SCKBullet.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import "SCKActor.h"

@interface SCKBullet : SCKActor

+(SCKBullet*)fromJSON:(NSDictionary *)json;
+(NSArray*)fromJSONArray:(NSArray *)jsonArray;

@end
