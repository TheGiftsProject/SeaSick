//
//  SCKViewController.h
//  SeaSick
//

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Services/SCKGameServer.h"
#import "SCKMyScene.h"

@interface SCKViewController : UIViewController<SCKGameUpdateDelegate, SCKSceneDelegate>

@end
