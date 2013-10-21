//
//  SCKActor.h
//  SeaSick
//
//  Created by Gilad Goldberg on 10/21/13.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    float x;
    float y;
} SCKPoint;

@interface SCKActor : NSObject

@property (nonatomic) int Id;
@property (nonatomic) SCKPoint position;
@property (nonatomic) SCKPoint velocity;

@end
