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
- (void) myShipDirectionChanged:(SCKShip *)myShip;
- (void) myShipDirectionAccelChanged:(SCKShip *)myShip accel:(BOOL)accel;

@end

@interface SCKGameScene : CCScene <CCTouchOneByOneDelegate>

@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) SCKGameState* gameState;
@property (nonatomic) BOOL playerPerspective;
@property (nonatomic, strong) id<SCKSceneDelegate> delegate;

- (CGPoint) gamePointToCGPoint:(SCKPoint)pt;

@end
