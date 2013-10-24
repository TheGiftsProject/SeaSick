//
//  SCKShipNode.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import "SCKShipNode.h"

#import "cocos2d.h"

@implementation SCKShipNode

- (id)init
{
    if (self = [super init]) {
        self.color = ccc4(255, 0, 0, 255);
    }
    return self;
}

-(void)draw
{
    glLineWidth(2.0f);
    ccDrawColor4B(self.color.r, self.color.g, self.color.b, self.color.a); // you suck, cc

   
    ccDrawLine( ccp(0, -1.0), ccp(-4.0,-8.0) );
    ccDrawLine( ccp(-4.0, -8.0), ccp(0, 8.0) );
    ccDrawLine( ccp(0, 8.0), ccp(4.0, -8.0) );
    ccDrawLine( ccp(4.0, -8.0), ccp(0,-1.0) );
}


@end
