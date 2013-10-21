//
//  SCKSocketDelegate.h
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@interface SCKSocketDelegate : NSObject<SRWebSocketDelegate>

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

@end
