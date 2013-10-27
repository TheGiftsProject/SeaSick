//
//  SCKShip.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import "SCKActor.h"

@interface SCKShip : SCKActor

@property (nonatomic) float direction; // In Radians

@property (nonatomic) int health;
@property (nonatomic) int score;
@property (nonatomic) BOOL immune;

+(SCKShip*)fromJSON:(NSDictionary *)json;
+(NSArray*)fromJSONArray:(NSArray *)jsonArray;
-(NSDictionary*)toJSONDictionary;

@end
