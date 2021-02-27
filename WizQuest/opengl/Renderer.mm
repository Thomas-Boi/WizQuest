//
//  Copyright © 2017 Borna Noureddin. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include "GLESRenderer.hpp"
#include <chrono>

GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Renderer () {
    GLKView *theView;
    GLESRenderer glesRenderer;
    GLuint programObject;
    
    GLKMatrix4 mvp;
    GLKMatrix4 mvp2;
    GLKMatrix3 normalMatrix;
    
    float *vertices, *normals, *texCoords;
    int *indices, numIndices;
}

@end

@implementation Renderer

- (void)dealloc
{
    glDeleteProgram(programObject);
}

- (void)loadModels
{
    numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
}

/*! Set up the view
 \ param view, a view
 */
- (void)setup:(GLKView *)view
{
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!view.context) {
        NSLog(@"Failed to create ES context");
    }
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];
    if (![self setupShaders])
        return;

    glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
    glEnable(GL_DEPTH_TEST);
    
}

- (void)update:(GLKMatrix4) transformations
{
    mvp = transformations;
    mvp2 = GLKMatrix4Translate(mvp, 1.0f, 3.0f, 0);
    
    // Perspective
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);
    
    // get the projection
    float aspect = (float)theView.drawableWidth / (float)theView.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, aspect, 1.0f, 20.0f);

    mvp = GLKMatrix4Multiply(perspective, mvp);
    mvp2 = GLKMatrix4Multiply(perspective, mvp2);
    
}

- (void)draw:(GameObject *) obj
{

    // get the projection
    float aspect = (float)theView.drawableWidth / (float)theView.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, aspect, 1.0f, 20.0f);
    mvp = GLKMatrix4Multiply(perspective, obj.mv);
    
    // set up all the necessary uniform matrices
    // mvp for model-view-project aka position to scene of the shader
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp.m);
    
    // normal of the obj
    glUniformMatrix3fv(obj.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, obj.normalMatrix.m);
    
    // pass through?
    glUniform1i(obj.uniforms[UNIFORM_PASSTHROUGH], false);
    
    // fragment shader
    glUniform1i(obj.uniforms[UNIFORM_SHADEINFRAG], true);

    
    // clear the viewport so we start fresh
    glViewport(0, 0, (int)theView.drawableWidth, (int)theView.drawableHeight);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glUseProgram ( obj.programObject ); // get the program object with attached shaders

    
    // tell opengl which vertices to use for drawing
    glVertexAttribPointer ( 0, 3, GL_FLOAT,
                           GL_FALSE, 3 * sizeof ( GLfloat ), obj.vertices );
    glEnableVertexAttribArray ( 0 ); // has to enable it for opengl

    // set the color attribue (attrib) for the vertices
    // this is green (rgba)
    glVertexAttrib4f ( 1, 0.0f, 1.0f, 0.0f, 1.0f );

    // tell opengl to use normals for the obj's normals so we can apply texture
    glVertexAttribPointer ( 2, 3, GL_FLOAT,
                           GL_FALSE, 3 * sizeof ( GLfloat ), obj.normals );
    glEnableVertexAttribArray ( 2 ); // also enable it
    
    // tell opengl to use texCoords so we can apply texture
    glVertexAttribPointer ( 3, 2, GL_FLOAT,
                           GL_FALSE, 2 * sizeof ( GLfloat ), obj.texCoords );
    glEnableVertexAttribArray ( 3 );

    // draw the object
    glDrawElements ( GL_TRIANGLES, obj.numIndices, GL_UNSIGNED_INT, obj.indices );
    
    /*
    // mvp2
    // mvp for model-view-project aka position to scene of the shader
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp2.m);

    // set the color attribue (attrib) for the vertices
    // this is red (rgba)
    glVertexAttrib4f ( 1, 1.0f, 0.0f, 0.0f, 1.0f );

    // draw the object
    glDrawElements ( GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, indices );
    */
}


@end

