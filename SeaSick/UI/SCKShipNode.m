//
//  SCKShipNode.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import "SCKShipNode.h"
#import "SCKGameScene.h"

#import "cocos2d.h"

@interface SCKShipNode()
@property (nonatomic) BOOL immune;

@end

@implementation SCKShipNode
{
  BOOL _destroying;
  BOOL _killed;
}

- (id)initWithShip:(SCKShip*) ship andScene:(SCKGameScene *) scene
{
  if (self = [super init]) {
    self.ship = ship;
    self.scene = scene;
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
  if (_destroying) {
    ccDrawColor4B(255, 255, 255, 255);
    ccDrawLine( ccp(0, 3.0), ccp(0, 6.0) );
    ccDrawLine( ccp(2, 2), ccp(4, 4) );
    ccDrawLine( ccp(2, -2), ccp(4, -4) );
    
    ccDrawLine( ccp(0, -3), ccp(0, -6) );
    ccDrawLine( ccp(-2, -2), ccp(-4, -4) );
    ccDrawLine( ccp(-2, 2), ccp(-4, 4) );
  }
  else {
    
    ccColor4B shipColor = [self getColorForHealth:self.ship.health];
    ccDrawColor4B(shipColor.r, shipColor.g, shipColor.b, shipColor.a); // you suck, cc
    
    ccDrawLine( ccp(0, -1.0), ccp(-4.0,-8.0) );
    ccDrawLine( ccp(-4.0, -8.0), ccp(0, 8.0) );
    ccDrawLine( ccp(0, 8.0), ccp(4.0, -8.0) );
    ccDrawLine( ccp(4.0, -8.0), ccp(0,-1.0) );
  }
}

-(void)respawn
{
  self.visible = YES;
  _killed = NO;
}

-(void)destroy
{
  // Poof!
  _destroying = YES;
  _killed = YES;
 [self scheduleOnce:@selector(destroyed) delay:0.5f];
}

- (void) destroyed
{
  _destroying = NO;
  self.visible = NO;
}

- (void)setImmune:(BOOL)immune
{
  if (_immune != immune) {
    if (immune) {
      [self schedule:@selector(flash) interval:0.1f];
    }
    else {
      [self unschedule:@selector(flash)];
      self.visible = YES;
    }
  }
  
  _immune = immune;
}

- (void)flash
{
  self.visible = !self.visible;
}

- (void)setShip:(SCKShip *)ship
{
  _ship = ship;

  self.immune = ship.immune;

  if (!_killed && self.ship.health == 0) {
    [self destroy];
  }
  else if (_killed && ship.health != 0) {
    [self respawn];
  }

  

  self.position = [self.scene gamePointToCGPoint:ship.position];
  self.rotation = CC_RADIANS_TO_DEGREES(M_PI_2 - ship.direction);
}



@end
