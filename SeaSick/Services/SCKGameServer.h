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

typedef enum SCKGameServerClientDisconnectType {
  SocketError,
  ClientDisconnected
} SCKGameServerClientDisconnectType;

@protocol SCKGameServerDelegate <NSObject>

-(void)newGameStateReceived:(SCKGameState *)gameState;
-(void)clientDidConnect;
-(void)clientDidDisconnect:(SCKGameServerClientDisconnectType)disconnectType;

@end

@interface SCKGameServer : NSObject<SRWebSocketDelegate>

-(SCKGameServer*)initWithURL:(NSString *)url;
-(void)start:(id<SCKGameServerDelegate>)delegate;
-(void)reconnect;
- (void) updateShipDirection:(SCKShip *)ship;

- (void) updateShip:(SCKShip *)ship accelerating:(BOOL)accel;
- (void) shipFired;

@end