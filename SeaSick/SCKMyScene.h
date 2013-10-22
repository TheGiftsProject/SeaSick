//
//  SCKMyScene.h
//  SeaSick
//

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Models/SCKGameState.h"
#import "Models/SCKShip.h"



@interface SCKMyScene : SKScene

@property (strong, nonatomic) SCKGameState* gameState;
@property (nonatomic) BOOL playerPerspective;
@property (nonatomic, strong) id<SCKSceneDelegate> delegate;

-(id)initWithSize:(CGSize)size andPlayerPerspective:(BOOL)playerPerspective;

@end
