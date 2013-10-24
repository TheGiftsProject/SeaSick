//
//  SCKGameServer.h
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import "../Models/SCKGameState.h"
#import "../Models/SCKShip.h"

@protocol SCKGameUpdateDelegate <NSObject>

-(void)setGameState:(SCKGameState *)gameState;

@end

@interface SCKGameServer : NSObject<SRWebSocketDelegate>

-(SCKGameServer*)initWithURL:(NSString *)url;
-(void)start:(id<SCKGameUpdateDelegate>)delegate;
- (void) updateShipDirection:(SCKShip *)ship;

- (void) updateShip:(SCKShip *)ship accelerating:(BOOL)accel;
- (void) shipFired;

@end