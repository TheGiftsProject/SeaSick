//
//  SCKBulletNode.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import "SCKBulletNode.h"

@implementation SCKBulletNode

-(void)draw
{
    glLineWidth(2.0f);
    ccDrawColor4B(255, 255, 0, 255);
        
    ccDrawCircle(ccp(0.0, 0.0), 1.0, CC_DEGREES_TO_RADIANS(360), 6, NO);
}

@end
