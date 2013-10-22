//
//  SCKMyScene.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCKMyScene.h"

#import "Models/SCKGameState.h"
#import "Models/SCKShip.h"
#import "Models/SCKBullet.h"
#import <CoreMotion/CoreMotion.h>

@interface SCKMyScene()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) SKNode *cameraNode;
@property (nonatomic, strong) SKNode *containerNode;
@property (nonatomic, strong) SKNode *myShipNode;
@property (nonatomic, strong) SCKShip *myShip;
@property (nonatomic) NSTimeInterval lastUpdateCalled;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) CGPathRef shipPath;

@end

@implementation SCKMyScene

-(id)initWithSize:(CGSize)size andPlayerPerspective:(BOOL)playerPerspective {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        self.motionManager = [CMMotionManager new];
        self.playerPerspective = playerPerspective;

        if (self.playerPerspective)
        {
            [self.cameraNode addChild:self.containerNode];
            [self addChild:self.cameraNode];
            
            [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
                if (error) {
                    NSLog(@"Magnometer Error: %@", error);
                }
                else {
                    [self magnetometerUpdate:motion.magneticField.field];
                }
            }];
        }
        else {
            [self addChild:self.containerNode];
        }
        
    }
    return self;
}

- (SKNode *)cameraNode
{
    if (!_cameraNode) {
        _cameraNode = [SKNode new];
    }
    return _cameraNode;
}

- (SKNode *)containerNode
{
    if (!_containerNode) {
        _containerNode = [SKNode new];
    }
    return _containerNode;
}

- (void) magnetometerUpdate:(CMMagneticField)magnetometerData
{
    double heading = 0.0;
    double x = magnetometerData.x;
    double y = magnetometerData.y;
    
    if (y > 0) heading = M_PI_2 - atan(x/y);
    if (y < 0) heading = M_PI + M_PI_2 - atan(x/y);
    if (y == 0 && x < 0) heading = M_PI;
    if (y == 0 && x > 0) heading = 0.0;
    
    self.cameraNode.zRotation = heading;
    self.myShipNode.zRotation = -heading;
}

- (CGPathRef) shipPath
{
    if (!_shipPath) {
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathRef, NULL, 0.0, -1.0);
        CGPathAddLineToPoint(pathRef, NULL, -4, -8);
        CGPathAddLineToPoint(pathRef, NULL, 0, 8);
        CGPathAddLineToPoint(pathRef, NULL, 4, -8);
        CGPathCloseSubpath(pathRef);
        
        _shipPath = pathRef;
    }
    
    
    return _shipPath;
}

- (CGPoint) gamePointToCGPoint:(SCKPoint)pt
{
    return CGPointMake(pt.x * (float)self.size.width, (float)pt.y * self.size.height);
}

- (CGVector) gamePointToCGVector:(SCKPoint)pt
{
    return CGVectorMake(pt.x * (float)self.size.width, pt.y * (float)self.size.height);
}


- (void)setGameState:(SCKGameState *)gameState
{
    _gameState = gameState;
    
    [self.containerNode removeAllChildren];
    
    if (!self.myShip) {
        for (SCKShip *ship in self.gameState.ships) {
            if (ship.Id == self.gameState.playerShipId) {
                self.myShip = ship;
            }
        }
        
        if (!self.myShip) {
            return;
        }
    }
    
    for (SCKShip *ship in self.gameState.ships) {
        SKShapeNode *shipNode = [[SKShapeNode alloc] init];

        shipNode.strokeColor = [UIColor redColor];
        shipNode.path = [self shipPath];
        shipNode.lineWidth = 0.5;
        

        if (ship.Id == self.myShip.Id) {
            self.myShipNode = shipNode;
        }
        else {
            shipNode.position = [self gamePointToCGPoint:ship.position];
            [shipNode runAction:[SKAction repeatActionForever:[SKAction moveBy:[self gamePointToCGVector:ship.velocity] duration:1.0]]];
            [shipNode setZRotation:ship.direction - M_PI_2];
        }
        
        [self.containerNode addChild:shipNode];
    }
    
    //NSLog(@"SCK Scene got %d ships", self.gameState.ships.count);
    
    for (SCKBullet *bullet in self.gameState.bullets) {
        SKShapeNode *bulletNode = [[SKShapeNode alloc] init];
        
        bulletNode.strokeColor = [UIColor yellowColor];
        bulletNode.position = [self gamePointToCGPoint:bullet.position];
        bulletNode.path = CGPathCreateWithEllipseInRect(CGRectMake(-1, -1, 2, 2), NULL);
        bulletNode.lineWidth = 0.5;
        
        //[bulletNode runAction:[SKAction repeatActionForever:[SKAction moveBy:[self gamePointToCGVector:bullet.velocity] duration:1.0]]];
        [self.containerNode addChild:bulletNode];
    }
    
    //NSLog(@"SCK Scene got %d bullets", self.gameState.bullets.count);
    
    
}

#define ACCEL_COEFFICIENT 0.1

-(void)update:(CFTimeInterval)currentTime {

    NSTimeInterval timeSinceLastUpdate = currentTime - self.lastUpdateCalled;
    
    if (self.myShip) {
        CGVector accelVector = CGVectorMake(ACCEL_COEFFICIENT * cosf(self.myShip.direction), ACCEL_COEFFICIENT * sinf(self.myShip.direction));
        
        if (self.accelerating) {
            SCKPoint vel = self.myShip.velocity;
            vel.x += accelVector.dx * timeSinceLastUpdate;
            vel.y += accelVector.dy * timeSinceLastUpdate;
            
            self.myShip.velocity = vel;
        }

        SCKPoint pos = self.myShip.position;
        pos.x += self.myShip.velocity.x * timeSinceLastUpdate;
        pos.y += self.myShip.velocity.y * timeSinceLastUpdate;
        
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
        self.containerNode.position = CGPointMake(-self.myShipNode.position.x, -self.myShipNode.position.y);
        self.cameraNode.position = CGPointMake(self.size.width / 2.0 , 10.0);
    }
    else {
        self.containerNode.position = CGPointMake(0.0, 0.0);
    }
    
    self.lastUpdateCalled = currentTime;
}

- (BOOL)inAccelerationArea:(UITouch *)touch {
    CGPoint location = [touch locationInNode:self];
    
    return (location.x < (float)self.size.width / 2.0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {

        if ([self inAccelerationArea:touch]) {
            // accelerate
            self.accelerating = TRUE;
        }
        else {
            // fire
            [self.delegate fire];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if ([self inAccelerationArea:touch]) {
            // accelerate
            self.accelerating = NO;
        }
    }

}

@end
