//
//  SCKGameState.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import <Foundation/Foundation.h>

@interface SCKGameState : NSObject

@property (strong, nonatomic) NSArray *ships; // of SCKShip*
@property (strong, nonatomic) NSArray *bullets; // of SCKBullet*

@end
