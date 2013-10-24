//
//  SCKShipNode.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/22/13.
//
//

#import "CCNode.h"
#import "SCKShip.h"

@interface SCKShipNode : CCNode

@property (nonatomic) BOOL isMyShip;
@property (nonatomic, strong) SCKShip* ship;

@end
