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
  USArrayWrapper *ships = _.array(updateData[@"ships"]);
//USArrayWrapper *bullets = _.array(updateData[@"bullets"]);
  
  newGameState.ships = ships.map(^SCKShip *(NSDictionary *ship)  {
    SCKShip *s = [SCKShip new];
    s.Id = [((NSString*)ship[@"id"]) integerValue];
    s.score = [((NSString*)ship[@"score"]) integerValue];
    s.health = [((NSString*)ship[@"health"]) integerValue];
    NSArray *velArr = (NSArray*)ship[@"velocity"];
    NSArray *posArr = (NSArray*)ship[@"position"];
    SCKPoint vel;
    vel.x = [((NSString*)velArr[0]) floatValue];
    vel.y = [((NSString*)velArr[1]) floatValue];
    s.velocity = vel;
    SCKPoint pos;
    pos.x = [((NSString*)posArr[0]) floatValue];
    pos.y = [((NSString*)posArr[1]) floatValue];
    s.position = pos;
    return s;
  }).unwrap;
  
  [self.delegate setGameState:newGameState];
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
