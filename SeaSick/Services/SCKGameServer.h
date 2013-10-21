//
//  SCKGameServer.h
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@interface SCKGameServer : NSObject

// Make it with this
- (id)initWithURLRequest:(NSURLRequest *)request;

// Set this before opening
@property (nonatomic, assign) id <SRWebSocketDelegate> delegate;

- (void)open;

// Close it with this
- (void)close;

// Send a UTF8 String or Data
- (void)send:(id)data;

@end
