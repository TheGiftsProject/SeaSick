//
//  SCKGameScene.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import <CoreMotion/CoreMotion.h>

#import "SCKGameScene.h"
#import "SCKShipNode.h"
#import "SCKBulletNode.h"
#import "Models/SCKShip.h"
#import "Models/SCKBullet.h"
#import "SCKHealthBar.h"


@interface SCKGameScene()
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) CCLayer *gameLayer;
@property (nonatomic, strong) CCLayer *statusLayer;

@property (nonatomic, strong) SCKShip *myShip;
@property (nonatomic, strong) SCKShipNode *myShipNode;

@property (nonatomic) BOOL accelerating;

@property (nonatomic, strong) NSMutableDictionary *shipNodes; // ship node by id
@property (nonatomic, strong) NSMutableDictionary *bulletNodes; // bullet node by id

@property (nonatomic, strong) SCKHealthBar *healthBar;
@property (nonatomic, strong) CCLabelTTF *scoreLabel;

@end

@implementation SCKGameScene

- (id)init
{
  if (self = [super init]) {
    
    CCLayerGradient *backgroundLayer = [CCLayerGradient layerWithColor:ccc4(0, 0, 255, 255)
                                                              fadingTo:ccc4(0, 0, 128, 255)
                                                           alongVector:ccp(0,-1)];
    [self addChild:backgroundLayer];
    
    self.gameLayer = [[CCLayer alloc] init];
    [self addChild:self.gameLayer];
    
    self.statusLayer = [[CCLayer alloc] init];
    [self addChild:self.statusLayer];
    self.statusLayer.zOrder = 100;
    
    [self scheduleUpdate];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    self.shipNodes = [NSMutableDictionary new];
    self.bulletNodes = [NSMutableDictionary new];
    
    self.motionManager = [CMMotionManager new];
    
    self.healthBar = [SCKHealthBar new];
    self.healthBar.position = ccp(self.boundingBox.size.width - HEALTH_BAR_WIDTH/2.0f - 5.0f,
                                  self.boundingBox.size.height - HEALTH_BAR_HEIGHT/2.0f - 5.0f);
    [self.statusLayer addChild:self.healthBar];
    
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
      if (error) {
        NSLog(@"Magnetometer Error: %@", error);
      }
      else {
        [self magnetometerUpdate:motion.magneticField.field];
      }
    }];
  }
  
  return self;
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
  
  self.myShip.direction = (2.0f*M_PI) - heading;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate myShipDirectionChanged:self.myShip];
  });
  
}


- (CGPoint) gamePointToCGPoint:(SCKPoint)pt
{
  return CGPointMake(pt.x * (float)self.boundingBox.size.width,
                     pt.y * self.boundingBox.size.height);
}


- (void) updateShipNode:(SCKShipNode *)shipNode fromShip:(SCKShip *)ship
{
  shipNode.ship = ship;
  shipNode.visible = (ship.health > 0);
  shipNode.position = [self gamePointToCGPoint:ship.position];
  shipNode.rotation = CC_RADIANS_TO_DEGREES(M_PI_2 - ship.direction);
}

- (void) updateBulletNode:(SCKBulletNode *)bulletNode fromBullet:(SCKBullet *)bullet
{
  bulletNode.position = [self gamePointToCGPoint:bullet.position];
}

- (void) updateHUD
{
  self.healthBar.health = self.myShip.health;
  if (self.scoreLabel) {
    [self.statusLayer removeChild:self.scoreLabel];
  }
  NSString *labelString = [NSString stringWithFormat:@"%@ - %d", self.playerName, self.myShip.score];
  self.scoreLabel = [CCLabelTTF labelWithString:labelString fontName:@"Visitor TT2 BRK" fontSize:10.0f];
  self.scoreLabel.verticalAlignment = kCCVerticalTextAlignmentTop;
  self.scoreLabel.horizontalAlignment = kCCTextAlignmentLeft;
  self.scoreLabel.position = ccp(2.0, self.boundingBox.size.height - 1.0);
  self.scoreLabel.anchorPoint = ccp(0, 1);
  [self.statusLayer addChild:self.scoreLabel];
}

- (void)setGameState:(SCKGameState *)gameState
{
  _gameState = gameState;
  
  NSMutableDictionary *newDict = [NSMutableDictionary new];
  for (SCKShip *ship in self.gameState.ships) {
    SCKShipNode *shipNode = self.shipNodes[@(ship.Id)];
    if (!shipNode) {
      NSLog(@"Creating new ship node with id %d", ship.Id);
      shipNode = [[SCKShipNode alloc] init];
      [self updateShipNode:shipNode fromShip:ship];
      [self.gameLayer addChild:shipNode];
      newDict[@(ship.Id)] = shipNode;
      
      if (ship.Id == self.gameState.playerShipId) {
        self.myShip = ship;
        self.myShipNode = shipNode;
        shipNode.isMyShip = YES;
      }
    }
    else {
      [self updateShipNode:shipNode fromShip:ship];
      newDict[@(ship.Id)] = shipNode;
      
      if (ship.Id == self.gameState.playerShipId) {
        self.myShip = ship;
        [self updateHUD];
      }
    }
  }
  
  
  self.shipNodes = newDict;
  //NSLog(@"SCK Scene got %d ships", self.gameState.ships.count);
  
  
  newDict = [NSMutableDictionary new];
  for (SCKBullet *bullet in self.gameState.bullets) {
    
    SCKBulletNode *bulletNode = self.bulletNodes[@(bullet.Id)];
    if (!bulletNode) {
      bulletNode = [[SCKBulletNode alloc] init];
      [self updateBulletNode:bulletNode fromBullet:bullet];
      [self.gameLayer addChild:bulletNode];
      newDict[@(bullet.Id)] = bulletNode;
    }
    else {
      [self updateBulletNode:bulletNode fromBullet:bullet];
      newDict[@(bullet.Id)] = bulletNode;
    }
    
  }
  
  self.bulletNodes = newDict;
  
  
  // Remove unnecessary nodes
  for (CCNode* node in self.gameLayer.children) {
    BOOL found = NO;
    for (SCKShipNode *shipNode in [self.shipNodes allValues]) {
      if (shipNode == node) {
        found = YES;
        break;
      }
    }
    
    if (!found) {
      for (SCKBulletNode *bulletNode in [self.bulletNodes allValues]) {
        if (bulletNode == node) {
          found = YES;
          break;
        }
      }
    }
    
    if (!found) {
      [node removeFromParentAndCleanup:YES];
    }
  }
  
}

-(void)update:(ccTime)delta {
  
}


- (BOOL)inAccelerationArea:(UITouch *)touch {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    return (location.x < (float)self.boundingBox.size.width / 2.0);
}

- (void)setAccelerating:(BOOL)accelerating
{
  _accelerating = accelerating;
  [self.delegate myShipDirectionAccelChanged:self.myShip accel:self.accelerating];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self inAccelerationArea:touch]) {
        // accelerate
        self.accelerating = TRUE;
        
    }
    else {
        self.accelerating = NO;
        // fire
        [self.delegate fire];
    }
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self inAccelerationArea:touch]) {
        // accelerate
        self.accelerating = TRUE;
        
    }
    else {
        self.accelerating = NO;
    }
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.accelerating = NO;
}

@end
