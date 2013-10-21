//
//  SCKMyScene.h
//  SeaSick
//

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Models/SCKGameState.h"

@interface SCKMyScene : SKScene

@property (nonatomic) int playerId;
@property (strong, nonatomic) SCKGameState* gameState;

@end
