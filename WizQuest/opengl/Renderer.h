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
- (void)loadModels;
- (void)update:(GLKMatrix4) transformations;
- (void)draw:(GameObject *) obj;

@end

#endif /* Renderer_h */
