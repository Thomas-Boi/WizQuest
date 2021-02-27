//
//  GameManager.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameManager.h"


@interface GameManager()
{
    Renderer *renderer;
    ObjectTracker *tracker;
}

@end


@implementation GameManager
- (void) initManager:(GLKView *)view
{
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    tracker = [[ObjectTracker alloc] init];
    [self loadObjects];
}

// add the player, platforms, and enemies to the tracker
- (void) loadObjects
{
    @autoreleasepool {
        // test data for putting object on the screen
        GLKMatrix4 initialPlayerTransform = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(0.0, 0.0, -4.0) Rotation:45.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(0.5, 0.5, 0.5)];
        
        GameObject *player = [self createGameObject:@"playerModel" VertShader:@"PlayerShader.vsh" FragShader:@"PlayerShader.fsh" Transformation:initialPlayerTransform];
        [tracker addPlayer:player];
        
        //
        GLKMatrix4 initialPlatformTransform = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(0.0, 0.0, -5.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(1.0, 1.0, 1.0)];

        GameObject *platform = [self createGameObject:@"platformModel" VertShader:@"PlatformShader.vsh" FragShader:@"PlatformShader.fsh" Transformation:initialPlatformTransform];
        [tracker addPlatform:platform];
        
    }
}

// create a game object here. Need the model, shaders, and its
// initial transformation (position, rotation, scale)
- (GameObject *) createGameObject:(NSString *) modelName VertShader:(NSString *) vShaderName FragShader:(NSString *) fShaderName Transformation:(GLKMatrix4) transformations
{
    @autoreleasepool {
        GameObject *obj = [[GameObject alloc] init];
        [obj setupVertShader:vShaderName AndFragShader:fShaderName];
        [obj loadModels:modelName];
        [obj loadTransformation:transformations];
        return obj;
    }
}

// add object during run time here
- (void) addObject:(GameObject *) obj
{

}

- (void) update:(GLKMatrix4) transformations
{
    
    [tracker.player loadTransformation:transformations];
    
    for (GameObject *platform in tracker.platforms)
    {
        [platform loadTransformation:transformations];
    }
    
    
}

- (void) draw
{
    [renderer clear];
    [renderer draw:tracker.player];
    
    
    for (GameObject *platform in tracker.platforms)
    {
        [renderer draw:platform];
    }
    
    
}

@end
