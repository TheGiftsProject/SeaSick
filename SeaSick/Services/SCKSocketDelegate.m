//
//  SCKSocketDelegate.m
//  SeaSick
//
//  Created by Itay Adler on 21/10/2013.
//
//

#import "SCKSocketDelegate.h"

@implementation SCKSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  NSLog([NSString stringWithFormat:@"Message: %@", message]);
}

@end
