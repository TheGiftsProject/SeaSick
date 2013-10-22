//
//  SCKViewController.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCKViewController.h"
#import "SCKMyScene.h"
#import "Models/SCKShip.h"
#import "Models/SCKBullet.h"
#import "Models/SCKGameState.h"

#define GAME_SERVER_URL @"ws://localhost:8080"

@interface SCKViewController ()

@property (nonatomic, strong) SCKMyScene* scene;
@property (nonatomic, strong) SCKGameServer* gameServer;

@end

@implementation SCKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameServer = [[SCKGameServer alloc] initWithURL:GAME_SERVER_URL];
    [self.gameServer start:self];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    self.scene = [[SCKMyScene alloc] initWithSize:skView.bounds.size andPlayerPerspective:NO];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.delegate = self;
    
    // Present the scene.
    [skView presentScene:self.scene];
}

- (void)setGameState:(SCKGameState *)gameState {
  self.scene.gameState = gameState;
}

- (void)myShipStateChanged:(SCKShip *)myShip
{
  [self.gameServer updateShipState:myShip];
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
