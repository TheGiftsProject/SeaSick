//
//  SCKViewController.h
//  SeaSick
//

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Services/SCKGameServer.h"
#import "SCKGameScene.h"

@interface SCKViewController : UIViewController<SCKGameServerDelegate, SCKSceneDelegate>

@property (nonatomic, strong) NSString* playerName;

@end
