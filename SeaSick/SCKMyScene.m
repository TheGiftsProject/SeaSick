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
@property (nonatomic, strong) SKNode *myShip;

@end

@implementation SCKMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        self.motionManager = [CMMotionManager new];

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
    self.myShip.zRotation = -heading;
}

- (CGMutablePathRef) shipPath
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 0.0, -1.0);
    CGPathAddLineToPoint(pathRef, NULL, -4, -8);
    CGPathAddLineToPoint(pathRef, NULL, 0, 8);
    CGPathAddLineToPoint(pathRef, NULL, 4, -8);
    CGPathCloseSubpath(pathRef);
    
    return pathRef;
}

- (CGPoint) gamePointToCGPoint:(SCKPoint)pt
{
    return CGPointMake(pt.x * self.size.width, pt.y * self.size.height);
}

- (CGVector) gamePointToCGVector:(SCKPoint)pt
{
    return CGVectorMake(pt.x * self.size.width, pt.y * self.size.height);
}


- (void)setGameState:(SCKGameState *)gameState
{
    _gameState = gameState;
    
    // Add nodes accordingly
    
    [self.containerNode removeAllChildren]; // bwahahaha
    
    for (SCKShip *ship in self.gameState.ships) {
        SKShapeNode *shipNode = [[SKShapeNode alloc] init];

        shipNode.strokeColor = [UIColor redColor];
        shipNode.position = [self gamePointToCGPoint:ship.position];
        shipNode.path = [self shipPath];
        shipNode.lineWidth = 0.5;
        
        [shipNode runAction:[SKAction repeatActionForever:[SKAction moveBy:[self gamePointToCGVector:ship.velocity] duration:1.0]]];
        [shipNode setZRotation:ship.direction - M_PI_2];
        [self.containerNode addChild:shipNode];
        
        if (ship == self.gameState.ships.firstObject) {
            self.myShip = shipNode;
        }
    }
    
    for (SCKBullet *bullet in self.gameState.bullets) {
        SKShapeNode *bulletNode = [[SKShapeNode alloc] init];
        
        bulletNode.strokeColor = [UIColor yellowColor];
        bulletNode.position = [self gamePointToCGPoint:bullet.position];
        bulletNode.path = CGPathCreateWithEllipseInRect(CGRectMake(-1, -1, 2, 2), NULL);
        bulletNode.lineWidth = 0.5;
        
        [bulletNode runAction:[SKAction repeatActionForever:[SKAction moveBy:[self gamePointToCGVector:bullet.velocity] duration:1.0]]];
        [self.containerNode addChild:bulletNode];
    }
    
}


-(void)update:(CFTimeInterval)currentTime {
    self.containerNode.position = CGPointMake(-self.myShip.position.x, -self.myShip.position.y);
    self.cameraNode.position = CGPointMake(self.size.width / 2.0 , 10.0);
}

@end
