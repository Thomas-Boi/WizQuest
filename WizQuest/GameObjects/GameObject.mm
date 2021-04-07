//
//  GameObject.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameObject.h"
// List of vertex attributes
enum
{
    ATTRIB_POSITION,
    ATTRIB_NORMAL,
    ATTRIB_TEXTURE_COORDINATE,
    NUM_ATTRIBUTES
};

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// default sizes for the model created by GLESRenderer.cpp
const int DEFAULT_HEIGHT = 1;
const int DEFAULT_WIDTH = 1;

@interface GameObject()
{
    // props
    GLKVector3 _position;
    GLKVector3 _rotation;
    GLKVector3 _scale;
    float _height;
    float _width;

    // shader
    GLESRenderer glesRenderer; // use the cube for now
    GLint _uniforms[NUM_UNIFORMS];
    
    // Model
    float *vertices, *normals, *texCoords;
    GLuint *indices;
    
    // VAO and VBO buffers
    GLuint vertexArray;
    GLuint vertexBuffers[3];
    GLuint indexBuffer;
    
    // physics
    b2Body *_body;
    PhysicsBodyTypeEnum _bodyType;
}
@end

@implementation GameObject

// props
@synthesize position=_position;
@synthesize rotation=_rotation;
@synthesize scale=_scale;
@synthesize height=_height;
@synthesize width=_width;

// opengl matrices
@synthesize _id;
@synthesize modelMatrix;
@synthesize modelViewMatrix;
@synthesize normalMatrix;

// lighting
@synthesize diffuseLightPosition;
@synthesize diffuseComponent;

@synthesize vertexArray;
@synthesize indexBuffer;
@synthesize numIndices;

// shaders
@synthesize programObject;
@synthesize texture;


// physics
@synthesize bodyType=_bodyType;
@synthesize body=_body;


- (GLint *) uniforms
{
    return _uniforms;
}

// init the minimum details needed for an object
// note: just making the body type is not enough to init its physics
// the GameObject must also be added to a PhysicsWorld object
// position is counting from the center of the game object
// scale along the x-axis will be used as the width
// scale along the y-axis will be used as the height
- (void)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale VertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName ModelName:(NSString *)modelName   PhysicsBodyType:(PhysicsBodyTypeEnum) bodyType
{
    [self loadPosition:position Rotation:rotation Scale:scale];
    [self loadVertShader:vShaderName AndFragShader:fShaderName];
    [self loadModel:modelName];
    _bodyType = bodyType;
}

// get the model info from GLESRenderer then bind it to the vertexArray
// property
- (void)loadModel:(NSString *)modelName
{
    // Generate vertex attribute values from model
    int numVerts;
    if ([modelName isEqualToString:@"cube"])
    {
        numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices, &numVerts);
        
    }
    else if ([modelName isEqualToString:@"sphere"])
    {
        numIndices = glesRenderer.GenSphere(24, 0.1, &vertices, &normals, &texCoords, &indices, &numVerts);
        
    }
    else return;
    
    // Create VAOs
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);

    // Create VBOs
    glGenBuffers(NUM_ATTRIBUTES, vertexBuffers);   // One buffer for each attribute (position, tex, normal). See the uniforms at the top
    glGenBuffers(1, &indexBuffer);                 // Index buffer

    // Set up VBOs...
    
    // Position
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*numVerts, vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_POSITION);
    glVertexAttribPointer(ATTRIB_POSITION, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    // Normal vector
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*numVerts, normals, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_NORMAL);
    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    // Texture coordinate
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[2]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*numVerts, texCoords, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_TEXTURE_COORDINATE);
    glVertexAttribPointer(ATTRIB_TEXTURE_COORDINATE, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), BUFFER_OFFSET(0));
    
    
    // Set up index buffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(int)*numIndices, indices, GL_STATIC_DRAW);
    
    // Reset VAO
    glBindVertexArray(0);
}

// attach the shaders to the program object
// also initialize the programObject
- (bool)loadVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName
{
    char *vShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[vShaderName stringByDeletingPathExtension] ofType:[vShaderName pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[fShaderName stringByDeletingPathExtension] ofType:[fShaderName pathExtension]] cStringUsingEncoding:1]);
    programObject = glesRenderer.LoadProgram(vShaderStr, fShaderStr);
    if (programObject == 0)
        return false;
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(programObject, ATTRIB_POSITION, "position");
    glBindAttribLocation(programObject, ATTRIB_NORMAL, "normal");
    glBindAttribLocation(programObject, ATTRIB_TEXTURE_COORDINATE, "texCoordIn");
    
    // Link shader program
    programObject = glesRenderer.LinkProgram(programObject);

    // Get uniform locations.
    _uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    _uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    _uniforms[UNIFORM_MODELVIEW_MATRIX] = glGetUniformLocation(programObject, "modelViewMatrix");
    _uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(programObject, "texSampler");
    
    // ### Add lighting uniform locations here...
    _uniforms[UNIFORM_LIGHT_SPECULAR_POSITION] = glGetUniformLocation(programObject, "specularLightPosition");
    _uniforms[UNIFORM_LIGHT_DIFFUSE_POSITION] = glGetUniformLocation(programObject, "diffuseLightPosition");
    _uniforms[UNIFORM_LIGHT_DIFFUSE_COMPONENT] = glGetUniformLocation(programObject, "diffuseComponent");
    _uniforms[UNIFORM_LIGHT_SHININESS] = glGetUniformLocation(programObject, "shininess");
    _uniforms[UNIFORM_LIGHT_SPECULAR_COMPONENT] = glGetUniformLocation(programObject, "specularComponent");
    _uniforms[UNIFORM_LIGHT_AMBIENT_COMPONENT] = glGetUniformLocation(programObject, "ambientComponent");
    
    // Set up lighting parameters
    // ### Set default lighting parameter values here...

    return true;
}

// bind the texture file to the object
- (void)loadTexture:(NSString *)textureFileName
{
    // Load texture to apply and set up texture in GL
    texture = [self setupTexture:textureFileName];
    glActiveTexture(GL_TEXTURE0); // set texture 0 to be active
    // uniforms[UNIFORM_TEXTURE] will store the sampler2D
    // 0 is the number of texture.
    glUniform1i(_uniforms[UNIFORM_TEXTURE], 0);
}
                    
// Load in and set up texture image (adapted from Ray Wenderlich)
- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

// load the position, rotation, and scale of an object.
// this is usually used to init an object.
// each element in the rotation are around the x-axis, y-axis,
// and z-axis respectively.
- (void)loadPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale
{
    _position = position;
    _rotation = rotation;
    _scale = scale;
    GLKMatrix4 transform = [Transformations createTransformationMatrixWithTranslation:position RotationX:rotation.x RotationY:rotation.y RotationZ:rotation.z Scale:scale];
    [self loadModelMatrix:transform];
    
    // since we change the scale, we have to update height and width
    _height = scale.x / DEFAULT_WIDTH;
    _width = scale.y / DEFAULT_HEIGHT;
}

// load the position, rotation, and scale of an object.
// this is usually used to init an object.
// each element in the rotation are around the x-axis, y-axis,
// and z-axis respectively.
- (void)loadPosition: (GLKVector3)position
{
    GLKMatrix4 transform = [Transformations changeMatrix:self.modelMatrix ByTranslation:GLKVector3Subtract(position, _position)];
    _position = position;
    [self loadModelMatrix:transform];
}


// load the transformation for the GameObject
- (void)loadModelMatrix:(GLKMatrix4) modelMatrix
{
    
    self.modelMatrix = modelMatrix;
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelMatrix), NULL);
    modelViewMatrix = modelMatrix;
}

- (void)loadDiffuseLightPosition:(GLKVector4)diffuseLightPosition DiffuseComponent: (GLKVector4)component
{
    self.diffuseLightPosition = diffuseLightPosition;
    self.diffuseComponent = component;
}

- (void)loadDefaultDiffuseLight
{
    [self loadDiffuseLightPosition:GLKVector4Make(0, 1, 0, 1) DiffuseComponent:GLKVector4Make(255/255.0f, 255/255.0f, 255/255.0f, 1.0)];
}


- (void)loadPhysicsBody:(b2Body *) newBody
{
    _body = newBody;
}


// lifecycle
// update the object every draw cycle
// this can be overridden by the child classes
- (void)update
{
    if (_body && _bodyType != STATIC)
    {
        // update the position based on physics
        b2Vec2 position2D = _body->GetPosition();
        [self loadPosition:GLKVector3Make(position2D.x, position2D.y, _position.z)];
    }
}

- (void) onCollision:(GameObject *)otherObj
{
    
}


// deallocate the object
- (void)dealloc
{
    glDeleteProgram(programObject);
    if (vertices) delete(vertices);
    if (normals) delete(normals);
    if (texCoords) delete(texCoords);
    if (_body)
    {
        b2World *world = _body->GetWorld();
        world->DestroyBody(_body);
    }
}
@end

