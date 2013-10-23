//
//  SCKShip.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import "SCKShip.h"

@implementation SCKShip

+(SCKShip *)fromJSON:(NSDictionary *)ship {
  SCKShip *s = [SCKShip new];
  s.Id = [((NSString*)ship[@"id"]) integerValue];
  s.score = [((NSString*)ship[@"score"]) integerValue];
  s.health = [((NSString*)ship[@"health"]) integerValue];
    s.direction =[((NSString*)ship[@"direction"]) floatValue];
  NSArray *velArr = (NSArray*)ship[@"velocity"];
  NSArray *posArr = (NSArray*)ship[@"position"];
  SCKPoint vel;
  vel.x = [((NSString*)velArr[0]) floatValue];
  vel.y = [((NSString*)velArr[1]) floatValue];
  s.velocity = vel;
  SCKPoint pos;
  pos.x = [((NSString*)posArr[0]) floatValue];
  pos.y = [((NSString*)posArr[1]) floatValue];
  s.position = pos;
  return s;
}

+(NSArray *)fromJSONArray:(NSArray *)jsonArray {
  USArrayWrapper *arrayWrap = _.array(jsonArray);
  return arrayWrap.map(^SCKShip *(NSDictionary *ship)  {
    return [self fromJSON:ship];
  }).unwrap;
}

-(NSDictionary*)toJSONDictionary {
  NSDictionary *dict = [NSMutableDictionary new];
  [dict setValue:[NSNumber numberWithInt:self.Id] forKey:@"id"];
  [dict setValue:[NSNumber numberWithInt:self.score] forKey:@"score"];
  [dict setValue:[NSNumber numberWithInt:self.health] forKey:@"health"];
  [dict setValue:@[[NSNumber numberWithInt:self.velocity.x], [NSNumber numberWithInt:self.velocity.y]] forKey:@"velocity"];
  [dict setValue:@[[NSNumber numberWithInt:self.position.x], [NSNumber numberWithInt:self.position.y]] forKey:@"position"];
  return dict;
}

@end
