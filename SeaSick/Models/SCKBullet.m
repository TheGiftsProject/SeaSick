//
//  SCKBullet.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import "SCKBullet.h"

@implementation SCKBullet

+(SCKBullet *)fromJSON:(NSDictionary *)bullet {
  SCKBullet *s = [SCKBullet new];
  s.Id = [((NSString*)bullet[@"id"]) integerValue];
  NSArray *velArr = (NSArray*)bullet[@"velocity"];
  NSArray *posArr = (NSArray*)bullet[@"position"];
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
  return arrayWrap.map(^SCKBullet *(NSDictionary *ship)  {
    return [self fromJSON:ship];
  }).unwrap;
}

@end
