//
//  SCKGameScene.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//


#import "SCKGameScene.h"
#import "SCKShipNode.h"
#import "SCKBulletNode.h"
#import "Models/SCKShip.h"
#import "Models/SCKBullet.h"


@interface SCKGameScene()

@property (nonatomic, strong) SCKShip *myShip;
@property (nonatomic, strong) SCKShipNode *myShipNode;

@property (nonatomic) BOOL accelerating;

@end

@implementation SCKGameScene

- (id)init
{
    if (self = [super init]) {
        
        CCLayerColor *backgroundLayer = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 255, 255)];
        [self addChild:backgroundLayer];
        
        self.gameLayer = [[CCLayer alloc] init];
        [self addChild:self.gameLayer];
        
        [self scheduleUpdate];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    
    return self;
}

- (CGPoint) gamePointToCGPoint:(SCKPoint)pt
{
    return CGPointMake(pt.x * (float)self.boundingBox.size.width, (float)pt.y * self.boundingBox.size.height);
}


- (void)setGameState:(SCKGameState *)gameState
{
    _gameState = gameState;
    
    [self.gameLayer removeAllChildrenWithCleanup:YES];
    
    /*
    if (!self.myShip) {
        for (SCKShip *ship in self.gameState.ships) {
            if (ship.Id == self.gameState.playerShipId) {
                self.myShip = ship;
            }
        }
        
        if (!self.myShip) {
            return;
        }
    }*/
    
    for (SCKShip *ship in self.gameState.ships) {
        SCKShipNode *shipNode = [[SCKShipNode alloc] init];
        //NSLog(@"%d %f %f", ship.Id, ship.position.x, ship.position.y);
        shipNode.position = [self gamePointToCGPoint:ship.position];
        
        //[shipNode runAction:[SKAction repeatActionForever:[SKAction moveBy:[self gamePointToCGVector:ship.velocity] duration:1.0]]];
        [shipNode setRotation:CC_RADIANS_TO_DEGREES(ship.direction + M_PI_2)];
    
        
        [self.gameLayer addChild:shipNode];
    }
    
    //NSLog(@"SCK Scene got %d ships", self.gameState.ships.count);
    
    for (SCKBullet *bullet in self.gameState.bullets) {
        SCKBulletNode *bulletNode = [[SCKBulletNode alloc] init];
        
        bulletNode.position = [self gamePointToCGPoint:bullet.position];
        
        //[bulletNode runAction:[SKAction repeatActionForever:[SKAction moveBy:[self gamePointToCGVector:bullet.velocity] duration:1.0]]];
        [self.gameLayer addChild:bulletNode];
    }
    
    //NSLog(@"SCK Scene got %d bullets", self.gameState.bullets.count);
    
    
}

#define ACCEL_COEFFICIENT 1.0


-(void)update:(ccTime)delta {
    
    
    if (self.myShip) {
        CGVector accelVector = CGVectorMake(ACCEL_COEFFICIENT * cosf(self.myShip.direction), ACCEL_COEFFICIENT * sinf(self.myShip.direction));
        
        if (self.accelerating) {
            SCKPoint vel = self.myShip.velocity;
            vel.x += accelVector.dx * delta;
            vel.y += accelVector.dy * delta;
            
            self.myShip.velocity = vel;
        }
        
        SCKPoint pos = self.myShip.position;
        pos.x += self.myShip.velocity.x * delta;
        pos.y += self.myShip.velocity.y * delta;
        
        if (pos.x > 1.00) {
            pos.x -= 1.00;
        }
        if (pos.y > 1.00) {
            pos.y -= 1.00;
        }
        if (pos.x < 0.00) {
            pos.x += 1.00;
        }
        if (pos.y < 0.00) {
            pos.y += 1.00;
        }
        
        self.myShip.position = pos;
        
        //NSLog(@"Updating my ship's position: %f %f", self.myShip.position.x, self.myShip.position.y);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate myShipStateChanged:self.myShip];
        });
        
        self.myShipNode.position = [self gamePointToCGPoint:self.myShip.position];
    }
    
    if (self.playerPerspective) {
        /*self.containerNode.position = CGPointMake(-self.myShipNode.position.x, -self.myShipNode.position.y);
        self.cameraNode.position = CGPointMake(self.size.width / 2.0 , 10.0);*/
    }
    else {
        //self.containerNode.position = CGPointMake(0.0, 0.0);
    }
}


- (BOOL)inAccelerationArea:(UITouch *)touch {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    return (location.x < (float)self.boundingBox.size.width / 2.0);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if ([self inAccelerationArea:touch]) {
        // accelerate
        self.accelerating = TRUE;
    }
    else {
        // fire
        [self.delegate fire];
    }

    return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self inAccelerationArea:touch]) {
        // accelerate
        self.accelerating = NO;
    }
}

@end
