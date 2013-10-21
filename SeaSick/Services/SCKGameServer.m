//
//  SCKGameServer.m
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import "SCKGameServer.h"

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
