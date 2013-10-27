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

- (id)initWithShip:(SCKShip*) ship
{
    if (self = [super init]) {
        self.ship = ship;
    }
    return self;
}

- (ccColor4B)getColorForHealth:(int)health {
    if (self.isMyShip) {
        // my ship is always white, health will be indicated in the health bar
        return ccc4(255, 255, 255, 255);
    } else {
        switch (health) {
            // green -> yellow -> red
            case 5:
                return ccc4(0,   255, 0, 255);
            case 4:
                return ccc4(128, 255, 0, 255);
            case 3:
                return ccc4(255, 255, 0, 255);
            case 2:
                return ccc4(255, 128, 0, 255);
            case 1:
                return ccc4(255, 0,   0, 255);
            default:
                return ccc4(0, 255, 255, 255); // turquoise to indicate error, note that zero
                                               // falls back here since ships with zero health should
                                               // never be displayed
        }
    }
}

-(void)draw
{
    glLineWidth(2.0f);
    ccColor4B shipColor = [self getColorForHealth:self.ship.health];
    ccDrawColor4B(shipColor.r, shipColor.g, shipColor.b, shipColor.a); // you suck, cc
    
    
   
    ccDrawLine( ccp(0, -1.0), ccp(-4.0,-8.0) );
    ccDrawLine( ccp(-4.0, -8.0), ccp(0, 8.0) );
    ccDrawLine( ccp(0, 8.0), ccp(4.0, -8.0) );
    ccDrawLine( ccp(4.0, -8.0), ccp(0,-1.0) );
}


@end
