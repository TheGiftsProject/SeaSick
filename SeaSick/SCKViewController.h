//
//  SCKViewController.h
//  SeaSick
//

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Services/SCKGameServer.h"
#import "SCKShipUpdateDelegate.h"

@interface SCKViewController : UIViewController<SCKGameUpdateDelegate, SCKShipUpdateDelegate>

@end
