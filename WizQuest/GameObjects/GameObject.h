//
//  GameObject.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//


#ifndef GameObject_h
#define GameObject_h

#import <GLKit/GLKit.h>
#import "GLESRenderer.hpp"
#import "UniformEnum.h"

@interface GameObject : NSObject {
    int _id;
    
    // Uniform index.
    // hold important data as seen below
    // these values are constant across all
    // passes between the vertex and frag shader
    GLint _uniforms[NUM_UNIFORMS];
    
}

@property(readonly) int _id;
@property(readonly) GLint *uniforms;

- (void)setup:(GLKView *)view;
- (void)loadModels;
- (void)update:(GLKMatrix4) transformations;
- (void)draw;

@end
#endif /* GameObject_h */
