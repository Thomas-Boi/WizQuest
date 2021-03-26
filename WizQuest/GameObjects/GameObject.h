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
#import "Transformations.h"
#import <Box2D/Box2D.h>

@interface GameObject : NSObject
@property(readonly) int _id;

// state in world
@property GLKVector3 position;
@property GLKVector3 rotation;
@property GLKVector3 scale;
@property float height;
@property float width;

// matrices
@property GLKMatrix4 modelMatrix;
@property GLKMatrix4 modelViewMatrix;
@property GLKMatrix3 normalMatrix;

// diffuse lighting parameters
@property GLKVector4 diffuseLightPosition;
@property GLKVector4 diffuseComponent;

// VAO and index buffer
@property(readonly) GLuint vertexArray;
@property(readonly) GLuint indexBuffer;
@property(readonly) GLuint numIndices;

// shaders
@property(readonly) GLint *uniforms;
@property(readonly) GLuint programObject;
@property(readonly) GLuint texture;

// physics stuff
/*
 
@property(readonly) btRigidBody *body;
@property int tag;
@property(readonly) btCollisionShape *shape;
*/

// creating the objects
- (void)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale VertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName ModelName:(NSString *)modelName;

// helper/utility methods
- (bool)loadVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName;
- (void)loadPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale;
- (void)loadModel:(NSString *)modelName;
- (void)loadModelMatrix:(GLKMatrix4) modelMatrix;
- (void)loadTexture:(NSString *)textureFileName;
- (void)loadDiffuseLightPosition:(GLKVector4)diffuseLightPosition DiffuseComponent: (GLKVector4)component;
- (void)loadDefaultDiffuseLight;

// lifecycles
- (void)update;
- (void)updateWithViewMatrix:(GLKMatrix4) viewMatrix;

@end
#endif /* GameObject_h */
