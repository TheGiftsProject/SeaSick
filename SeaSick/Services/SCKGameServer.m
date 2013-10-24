//
//  SCKGameServer.m
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import "SCKGameServer.h"
#import "../Models/SCKShip.h"
#import "../Models/SCKBullet.h"
#import <Underscore.h>

@interface SCKGameServer ()

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) SRWebSocket *socket;
@property (strong, nonatomic) id<SCKGameUpdateDelegate> delegate;
@property (nonatomic) dispatch_queue_t dq;

@end

@implementation SCKGameServer

-(SCKGameServer*)initWithURL:(NSString*)url {
  self = [super init];
  if (self) {
    self.url = url;
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
    self.dq = dispatch_queue_create("game server queue", NULL);
    [self.socket setDelegateDispatchQueue:self.dq];
    self.socket.delegate = self;
  }
  
  return self;
}

- (void)start:(id<SCKGameUpdateDelegate>)delegate {
  self.delegate = delegate;
  [self.socket open];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
  NSLog(@":( Websocket Failed With Error %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
  //NSLog(@"Received \"%@\"", message);
  NSString* messageString = (NSString*)message;
  NSData *data = [messageString dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
  NSString *currentAction = jsonObject[@"action"];
  if([currentAction isEqualToString:@"gameState"]) {
    [self updateGameState:jsonObject[@"params"]];
  }
}

-(void)updateGameState:(NSDictionary*)updateData {
  SCKGameState *newGameState = [SCKGameState new];
  
  newGameState.bullets = [SCKBullet fromJSONArray:updateData[@"bullets"]];
  newGameState.ships = [SCKShip fromJSONArray:updateData[@"ships"]];
  newGameState.playerShipId = [updateData[@"playerShipId"] intValue];

  dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate setGameState:newGameState];
  });
  
}


- (void) updateShipDirection:(SCKShip *)ship {
    NSError *error = nil;
    NSDictionary *shipDirectionMessage = @{@"action": @"shipDirection",
                                        @"params": @{@"direction": @(ship.direction) }};
    NSData *data = [NSJSONSerialization dataWithJSONObject:shipDirectionMessage options:0 error:&error];
    
    [self.socket send:data];
}

- (void) updateShip:(SCKShip *)ship accelerating:(BOOL)accel {
    NSError *error = nil;
    NSDictionary *shipAccelMessage = @{@"action": @"shipAccelerator",
                                        @"params": @{@"accelerating": @(accel) }};
    NSData *data = [NSJSONSerialization dataWithJSONObject:shipAccelMessage options:0 error:&error];
    
    [self.socket send:data];
}

-(void)updateShipState:(SCKShip *)ship {
  NSError *error = nil;
  NSDictionary *shipStatusMessage = @{@"action": @"shipStatus",
                                      @"params": [ship toJSONDictionary]};
  NSData *data = [NSJSONSerialization dataWithJSONObject:shipStatusMessage options:0 error:&error];

  [self.socket send:data];
}

- (void)shipFired {
    NSError *error = nil;
    NSDictionary *shipFiredMessage = @{@"action": @"shipFired"}; // PEW!
    NSData *data = [NSJSONSerialization dataWithJSONObject:shipFiredMessage options:0 error:&error];
    
    [self.socket send:data];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
  NSLog(@"WebSocket closed");
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
  NSLog(@"Websocket Connected");
}


@end
