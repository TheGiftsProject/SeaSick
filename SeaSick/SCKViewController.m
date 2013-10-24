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
#import <SimpleAudioEngine.h>
#import "MBProgressHUD.h"
#import "cocos2d.h"

#define GAME_SERVER_URL @"ws://127.0.0.1:8088"

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
  
  self.scene = [SCKGameScene new];
  self.scene.delegate = self;
  self.scene.playerName = self.playerName;
  
  [self.director runWithScene:self.scene];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"Run 4 Your Lives.mp3" loop:YES];
  self.gameServer = [[SCKGameServer alloc] initWithURL:GAME_SERVER_URL];
  [self.gameServer start:self];
  
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.labelText = @"Connecting to Server";
  [self initCocos];
}

- (void)newGameStateReceived:(SCKGameState *)gameState
{
  self.scene.gameState = gameState;
}

- (void)clientDidConnect
{
  [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)clientDidDisconnect:(SCKGameServerClientDisconnectType)disconnectType
{
  if(disconnectType == SocketError) {
    //Trying to reconnect
    [self.gameServer reconnect];
  }
}

- (void)myShipDirectionChanged:(SCKShip *)myShip
{
  [self.gameServer updateShipDirection:myShip];
}

- (void)myShipDirectionAccelChanged:(SCKShip *)myShip accel:(BOOL)accel
{
  [self.gameServer updateShip:myShip accelerating:accel];
}

- (void)fire
{
  [self.gameServer shipFired];
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
