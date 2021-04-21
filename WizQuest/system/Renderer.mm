//
//  Copyright © 2017 Borna Noureddin. All rights reserved.
//

#import "Renderer.h"

int SCREEN_WIDTH;
int SCREEN_LEFT_X;
int SCREEN_RIGHT_X;

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Renderer () {
    GLKView *theView;
    
    GLKMatrix4 projectionMatrix;
    
    // Lighting parameters
    // ### Add lighting parameter variables here...
    GLKVector4 specularLightPosition;
    GLKVector4 specularComponent;
    GLfloat shininess;
    GLKVector4 ambientComponent;
    
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

    glClearColor ( 150/255.0f, 150/255.0f, 150/255.0f, 0.0f );
    glEnable(GL_DEPTH_TEST);
    
    // global light values
    specularComponent = GLKVector4Make(255/255.0f, 255/255.0f, 255/255.0f, 1.0f);
    specularLightPosition = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    shininess = 1000.0f;
    ambientComponent = GLKVector4Make(0.2f, 0.2f, 0.2f, 1.0f);
    
    // Setup blending for alpha values (transparent things)
    /*
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
     */
    
    // Calculate projection matrix
    
    // perspective for 3D view
    float aspect = fabsf((float)(theView.bounds.size.width / theView.bounds.size.height));
    SCREEN_WIDTH = SCREEN_HEIGHT * aspect;
    SCREEN_LEFT_X = SCREEN_CENTER_X - SCREEN_WIDTH / 2;
    SCREEN_RIGHT_X = SCREEN_CENTER_X + SCREEN_WIDTH / 2;
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    // orthographic makes everything looks 2D
    //projectionMatrix = GLKMatrix4MakeOrtho(SCREEN_LEFT_X_COORD, SCREEN_LEFT_X_COORD + SCREEN_WIDTH, SCREEN_BOTTOM_Y_COORD, SCREEN_BOTTOM_Y_COORD + SCREEN_HEIGHT, EYE_NEAR_COORD, EYE_FAR_COORD);
    
}

// clear the screen
- (void)clear
{
    glViewport(0, 0, (int)theView.drawableWidth, (int)theView.drawableHeight);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}

- (void)draw:(GameObject *) obj
{
    // Select VAO
    glBindVertexArray(obj.vertexArray);
    
    // select the shader program
    glUseProgram(obj.programObject);
    
    
    // select the texture
    glBindTexture(GL_TEXTURE_2D, obj.texture);
    
    // Set up uniforms for the shaders
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, obj.modelViewMatrix);

    // update specular
    // pass on global lighting, fog and texture values
    glUniform4fv(obj.uniforms[UNIFORM_LIGHT_SPECULAR_POSITION], 1, specularLightPosition.v);
    glUniform1i(obj.uniforms[UNIFORM_LIGHT_SHININESS], shininess);
    glUniform4fv(obj.uniforms[UNIFORM_LIGHT_SPECULAR_COMPONENT], 1, specularComponent.v);
    glUniform4fv(obj.uniforms[UNIFORM_LIGHT_AMBIENT_COMPONENT], 1, ambientComponent.v);
    
    // ### Set values for lighting parameter uniforms here...
    glUniform4fv(obj.uniforms[UNIFORM_LIGHT_DIFFUSE_POSITION], 1, obj.diffuseLightPosition.v);
    glUniform4fv(obj.uniforms[UNIFORM_LIGHT_DIFFUSE_COMPONENT], 1, obj.diffuseComponent.v);
    
    glUniformMatrix4fv(obj.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix4fv(obj.uniforms[UNIFORM_MODELVIEW_MATRIX], 1, 0, obj.modelViewMatrix.m);
    glUniformMatrix3fv(obj.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, obj.normalMatrix.m);

    
    // Select IBO (index buffer object) and draw
    if (obj.numIndices != 0)
    {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, obj.indexBuffer);
        glDrawElements(GL_TRIANGLES, obj.numIndices, GL_UNSIGNED_INT, 0);
    }
    else
    {
        glDrawArrays(GL_TRIANGLES, 0, obj.numVertices);
    }
}


@end

