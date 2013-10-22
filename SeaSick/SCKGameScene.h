//
//  SCKGameScene.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import "CCScene.h"
#import "cocos2d.h"

#import "SCKGameState.h"
#import "SCKShip.h"

@protocol SCKSceneDelegate <NSObject>

- (void) fire;
- (void) myShipStateChanged:(SCKShip *)myShip;

@end

@interface SCKGameScene : CCScene <CCTouchOneByOneDelegate>

@property (nonatomic, strong) CCLayer *gameLayer;

@property (strong, nonatomic) SCKGameState* gameState;
@property (nonatomic) BOOL playerPerspective;
@property (nonatomic, strong) id<SCKSceneDelegate> delegate;


@end
