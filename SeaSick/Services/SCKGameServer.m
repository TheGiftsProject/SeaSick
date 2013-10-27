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
#import <ObjectMapping.h>
#import <RKResponseDescriptor.h>
#import <RKObjectRequestOperation.h>
#import "../Models/SCKScore.h"

@interface SCKGameServer ()

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) SRWebSocket *socket;
@property (strong, nonatomic) id<SCKGameServerDelegate> delegate;
@property (nonatomic) dispatch_queue_t dq;

@end

@implementation SCKGameServer

-(SCKGameServer*)initWithURL:(NSString*)url
{
  self = [super init];
  if (self) {
    self.url = url;
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@", url]]];
    self.dq = dispatch_queue_create("game server queue", NULL);
    [self.socket setDelegateDispatchQueue:self.dq];
    self.socket.delegate = self;
  }
  
  return self;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
  NSLog(@"WebSocket closed");
  if ([self.delegate respondsToSelector:@selector(clientDidDisconnect:)]) {
    [self.delegate clientDidDisconnect:ClientDisconnected];
  }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
  NSLog(@"Websocket Connected");
  if ([self.delegate respondsToSelector:@selector(clientDidConnect)]) {
    [self.delegate clientDidConnect];
  }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
  NSLog(@":( Websocket Failed With Error %@", error);
  if ([self.delegate respondsToSelector:@selector(clientDidDisconnect:)]) {
    [self.delegate clientDidDisconnect:SocketError];
  }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
  NSString* messageString = (NSString*)message;
  NSData *data = [messageString dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
  NSString *currentAction = jsonObject[@"action"];
  if([currentAction isEqualToString:@"gameState"]) {
    [self updateGameState:jsonObject[@"params"]];
  }
}

- (void)start:(id<SCKGameServerDelegate>)delegate
{
  self.delegate = delegate;
  [self.socket open];
}

- (void)reconnect {
  [self.socket open];
}

-(void)updateGameState:(NSDictionary*)updateData
{
  SCKGameState *newGameState = [SCKGameState new];
  
  newGameState.bullets = [SCKBullet fromJSONArray:updateData[@"bullets"]];
  newGameState.ships = [SCKShip fromJSONArray:updateData[@"ships"]];
  newGameState.playerShipId = [updateData[@"playerShipId"] intValue];

  dispatch_async(dispatch_get_main_queue(), ^{
    if ([self.delegate respondsToSelector:@selector(newGameStateReceived:)]) {
      [self.delegate newGameStateReceived:newGameState];
    }
  });
}

- (void)updateShipDirection:(SCKShip *)ship
{
  [self sendMessage:@"shipDirection" withMessageData:@{@"direction": @(ship.direction) }];
}

- (void)updateShip:(SCKShip *)ship accelerating:(BOOL)accel
{
  [self sendMessage:@"shipAccelerator" withMessageData:@{@"accelerating": @(accel) }];
}

- (void)updateShipState:(SCKShip *)ship {
  [self sendMessage:@"shipStatus" withMessageData:[ship toJSONDictionary]];
}

- (void)shipFired {
  [self sendMessage:@"shipFired" withMessageData:@""];
}

- (void)sendMessage:(NSString *)messageId withMessageData:(id)messageData {
  NSError *error = nil;
  NSDictionary *message = @{@"action": messageId, @"params": messageData};
  NSData *data = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
  [self.socket send:data];
}

+ (void)requestScores:(NSString *)url withBlock:(void (^)(NSArray *))block {
  NSString *reqUrl = [NSString stringWithFormat:@"http://%@/scores", url];
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SCKScore class]];
  [mapping addAttributeMappingsFromDictionary:@{
                                                @"id":   @"Id",
                                                @"score":     @"score"
                                                }];
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
  RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:req responseDescriptors:@[responseDescriptor]];
  
  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
    NSLog(@"The scores: %@", [result array]);
    block([result array]);
  } failure:nil];
  [operation start];
}

@end
