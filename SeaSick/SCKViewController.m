//
//  SCKViewController.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCKViewController.h"
#import "SCKMyScene.h"

#define GAME_SERVER_URL @"ws://192.168.2.174:8080"

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
    self.scene = [SCKMyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.scene];
}

- (void)setGameState:(SCKGameState *)gameState {
  self.scene.gameState = gameState;
}

- (void)updateShipState:(SCKShip *)ship {
  [self.gameServer updateShipState:ship];
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
