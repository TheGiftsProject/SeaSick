//
//  SCKShipNode.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import "CCNode.h"
#import "SCKShip.h"
#import "SCKGameScene.h"

@interface SCKShipNode : CCNode

@property (nonatomic) BOOL isMyShip;
@property (nonatomic, strong) SCKShip* ship;
@property (nonatomic, weak) SCKGameScene* scene; // weak to prevent circular references

- (id)initWithShip:(SCKShip*) ship andScene:(SCKGameScene *) scene;

@end
