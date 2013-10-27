//
//  SCKHealthBar.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/24/13.
//
//

#import "CCNode.h"

// Not including frame
#define HEALTH_BAR_WIDTH 100.0
#define HEALTH_BAR_HEIGHT 2.0

@interface SCKHealthBar : CCNode

@property (nonatomic) int health;

@end
