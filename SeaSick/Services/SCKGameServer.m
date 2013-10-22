//
//  SCKGameServer.m
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import "SCKGameServer.h"
#import "../Models/SCKShip.h"
#import <Underscore.h>

@interface SCKGameServer ()

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) SRWebSocket *socket;
@property (strong, nonatomic) id<SCKGameUpdateDelegate> delegate;

@end

@implementation SCKGameServer

-(SCKGameServer*)initWithURL:(NSString*)url {
  self = [super init];
  if (self) {
    self.url = url;
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
    self.socket.delegate = self;
  }
  
  return self;
}

- (void)start:(id<SCKGameUpdateDelegate>)delegate {
  self.delegate = delegate;
  [self.socket open];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
  NSLog(@":( Websocket Failed With Error %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
  NSLog(@"Received \"%@\"", message);
  NSString* messageString = (NSString*)message;
  NSData *data = [messageString dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
  if([jsonObject[@"action"] isEqualToString:@"gameState"]) {
    [self updateGameState:jsonObject[@"params"]];
  }
}

-(void)updateGameState:(NSDictionary*)updateData {
  SCKGameState *newGameState = [SCKGameState new];
  
  newGameState.ships = [SCKShip fromJSONArray:updateData[@"ships"]];
  
  [self.delegate setGameState:newGameState];
}

-(void)updateShipState:(SCKShip *)ship {
  NSError *error = nil;
  NSDictionary *shipStatusMessage = @{@"action": @"shipStatus",
                                      @"params": [ship toJSONDictionary]};
  NSData *data = [NSJSONSerialization dataWithJSONObject:shipStatusMessage options:0 error:&error];

  [self.socket send:data];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
  NSLog(@"WebSocket closed");
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
  NSLog(@"Websocket Connected");
}


@end
