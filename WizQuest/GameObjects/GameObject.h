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
#import <Foundation/Foundation.h>

@interface GameObject : NSObject {
    int _id;
    GLuint programObject;
    
    GLKMatrix4 mvp;
    GLKMatrix3 normalMatrix;
    float *vertices, *normals, *texCoords;
    int *indices, numIndices;
    
    // Uniform index.
    // hold important data as seen below
    // these values are constant across all
    // passes between the vertex and frag shader
    GLint _uniforms[NUM_UNIFORMS];
}

@property(readonly) int _id;
@property(readonly) GLuint programObject;
@property(readonly) GLKMatrix4 mvp;
@property(readonly) GLKMatrix3 normalMatrix;
@property(readonly) float *vertices;
@property(readonly) float *normals;
@property(readonly) float *texCoords;
@property(readonly) int *indices;
@property(readonly) int numIndices;
@property(readonly) GLint *uniforms;

- (bool)setupVertShader:(char *) vShader AndFragShader:(char *) fShader;
- (void)loadModels;

@end
#endif /* GameObject_h */
