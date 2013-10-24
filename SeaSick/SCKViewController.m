//
//  SCKViewController.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCKViewController.h"
#import "SCKGameScene.h"
#import "Models/SCKShip.h"
#import "Models/SCKBullet.h"
#import "Models/SCKGameState.h"

#import "cocos2d.h"

#define GAME_SERVER_URL @"ws://192.168.2.55:8088"

#define WHY_NOT YES
#define HELL_NO NO
#define FO_SHO YES

@interface SCKViewController ()

@property (nonatomic, strong) SCKGameScene* scene;
@property (nonatomic, strong) SCKGameServer* gameServer;

@property (nonatomic, weak) CCDirectorIOS *director;

@end

@implementation SCKViewController



- (void) initCocos
{
    CCGLView *glView = [CCGLView viewWithFrame:self.view.bounds
								   pixelFormat:kEAGLColorFormatRGBA8
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
    self.director = (CCDirectorIOS*)[CCDirector sharedDirector];
    
    self.director.displayStats = YES;
    self.director.animationInterval = 1.0/60.0;
    self.director.view = glView;
    
    self.director.projection = kCCDirectorProjection2D;
    
    [self.director enableRetinaDisplay:WHY_NOT];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    [self.view addSubview:glView];
    
    self.scene = [[SCKGameScene alloc] init];
    self.scene.delegate = self;
    
    [self.director runWithScene:self.scene];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameServer = [[SCKGameServer alloc] initWithURL:GAME_SERVER_URL];
    [self.gameServer start:self];
    
    [self initCocos];

}

- (void)setGameState:(SCKGameState *)gameState {
  self.scene.gameState = gameState;
}

- (void) myShipDirectionChanged:(SCKShip *)myShip
{
    [self.gameServer updateShipDirection:myShip];
}
- (void) myShipDirectionAccelChanged:(SCKShip *)myShip accel:(BOOL)accel
{
    [self.gameServer updateShip:myShip accelerating:accel];
}

- (void)fire {
    NSLog(@"PEW!");
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
