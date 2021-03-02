//
//  Copyright © 2017 Borna Noureddin. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include "GLESRenderer.hpp"
#include <chrono>

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Renderer () {
    GLKView *theView;
}

@end

@implementation Renderer
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

    glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
    glEnable(GL_DEPTH_TEST);
    
}

// clear the screen
- (void)clear
{
    glViewport(0, 0, (int)theView.drawableWidth, (int)theView.drawableHeight);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}

- (void)draw:(GameObject *) obj
{

    // get the projection
    float aspect = (float)theView.drawableWidth / (float)theView.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, aspect, 1.0f, 20.0f);
    GLKMatrix4 mvp = GLKMatrix4Multiply(perspective, obj.modelViewMatrix);
    
    // set up all the necessary uniform matrices
    // mvp for model-view-project aka position to scene of the shader
    glUniformMatrix4fv(obj.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp.m);
    
    // normal of the obj
    glUniformMatrix3fv(obj.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, obj.normalMatrix.m);
    
    // pass through?
    glUniform1i(obj.uniforms[UNIFORM_PASSTHROUGH], false);
    
    // fragment shader
    glUniform1i(obj.uniforms[UNIFORM_SHADEINFRAG], true);

    glUseProgram ( obj.programObject ); // get the program object with attached shaders

    // tell opengl which vertices to use for drawing
    glVertexAttribPointer ( 0, 3, GL_FLOAT,
                           GL_FALSE, 3 * sizeof ( GLfloat ), obj.vertices );
    glEnableVertexAttribArray ( 0 ); // has to enable it for opengl

    // set the color attribue (attrib) for the vertices
    // this is green (rgba)
    // glVertexAttrib4f ( 1, 0.0f, 1.0f, 0.0f, 1.0f );

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
}


@end

