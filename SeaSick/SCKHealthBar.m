//
//  SCKHealthBar.m
//  SeaSick
//
//  Created by Gilad Goldberg on 10/24/13.
//
//

#import "SCKHealthBar.h"
#import <OpenGLES/ES2/gl.h>

@implementation SCKHealthBar

- (id)init
{
  if (self = [super init]) {
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
  }
  
  return self;
}

- (ccColor4F)getColorForHealth:(int)health {

  switch (health) {
      // green -> yellow -> red
    case 5:
      return ccc4f(0.0, 1.0, 0, 1.0);
    case 4:
      return ccc4f(0.5, 1.0, 0, 1.0);
    case 3:
      return ccc4f(1.0, 1.0, 0, 1.0);
    case 2:
      return ccc4f(0.5, 0.5, 0, 1.0);
    case 1:
      return ccc4f(1.0, 0.5, 0, 1.0);
    default:
      // magenta to indicate error, note that zero
      // falls back here since ships with zero health should
      // never be displayed
      return ccc4f(1.0, 0.0, 1.0, 1.0);
  }

}

-(void)draw
{
  ccDrawSolidRect(ccp(-HEALTH_BAR_WIDTH/2.0f, -HEALTH_BAR_HEIGHT/2.0f),
                  ccp(-HEALTH_BAR_WIDTH/2.0f + (HEALTH_BAR_WIDTH*((float)self.health)/5.0f), HEALTH_BAR_HEIGHT/2.0f), [self getColorForHealth:self.health]);
  
  glLineWidth(1.0f);
  ccDrawColor4B(0, 0, 0, 128);
  ccDrawRect(ccp(-HEALTH_BAR_WIDTH/2.0f - 2.0f, -HEALTH_BAR_HEIGHT/2.0f -2.0f), ccp(HEALTH_BAR_WIDTH/2.0f + 2.0f, HEALTH_BAR_HEIGHT/2.0f + 1.5f));
}


@end
