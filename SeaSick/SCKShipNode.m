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

-(void)draw
{
    glLineWidth(2.0f);
    ccDrawColor4B(255, 0, 0, 255);

   
    ccDrawLine( ccp(0, -1.0), ccp(-4.0,-8.0) );
    ccDrawLine( ccp(-4.0, -8.0), ccp(0, 8.0) );
    ccDrawLine( ccp(0, 8.0), ccp(4.0, -8.0) );
    ccDrawLine( ccp(4.0, -8.0), ccp(0,-1.0) );
}

@end
