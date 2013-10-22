//
//  SCKShipUpdateDelegate.h
//  SeaSick
//
//  Created by Itay Adler on 22/10/2013.
//
//

#import <Foundation/Foundation.h>
#import "Models/SCKShip.h"

@protocol SCKShipUpdateDelegate

@required

- (void)updateShipState:(SCKShip *)ship;

@end
