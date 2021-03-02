//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>
#import "UniformEnum.h"
#import "GameObject.h"

@interface Renderer : NSObject

- (void)setup:(GLKView *)view;
- (void)draw:(GameObject *) obj;
- (void)clear;

@end

#endif /* Renderer_h */
