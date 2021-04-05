//
//  Transformations.h
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#ifndef Transformations_h
#define Transformations_h

#import <GLKit/GLKit.h>

@interface Transformations : NSObject

- (id)initWithDepth:(float)z Scale:(float)s Translation:(GLKVector2)t Rotation:(float)r RotationAxis:(GLKVector3)rotAxis;
- (void)start;
- (void)scale:(float)s;

- (void)translate:(GLKVector2)t withMultiplier:(float)m;
- (void)translateBy:(GLKVector2)t; // to translate cube in certain direction

- (void)rotate:(float)rotation withMultiplier:(float)m;
- (void)reset;
- (GLKMatrix4)getModelViewMatrix;

+ (GLKMatrix4)createTransformMatrixWithTranslation:(GLKVector3)translation Rotation:(float)rotation RotationAxis:(GLKVector3)rotAxis Scale:(GLKVector3)scale;

+ (GLKMatrix4)createTransformationMatrixWithTranslation:(GLKVector3)translation RotationX:(float) rotX RotationY:(float) rotY RotationZ:(float) rotZ Scale:(GLKVector3)scale;

+ (GLKMatrix4)changeMatrix: (GLKMatrix4)matrix ByTranslation: (GLKVector3) translate;

@end

#endif /* Transformations_h */
