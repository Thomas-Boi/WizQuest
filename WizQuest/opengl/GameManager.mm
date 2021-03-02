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
- (void) initManager:(GLKView *)view  initialPlayerTransform:(GLKMatrix4) transform
{
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    tracker = [[ObjectTracker alloc] init];
    [self loadObjects:transform];
}

// add the player, platforms, and enemies to the tracker
- (void) loadObjects:(GLKMatrix4) initialPlayerTransform
{
    @autoreleasepool {
        // note: all models use the cube. The param is for future use
        // test data for putting object on the screen
        GameObject *player = [self createGameObject:@"playerModel" VertShader:@"PlayerShader.vsh" FragShader:@"PlayerShader.fsh" Transformation:initialPlayerTransform];
        [tracker addPlayer:player];
        
        // since player depth is 5, init z to be -5
        // floor
        GLKMatrix4 floorTransform = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(0.0, -2.1, -5.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(10.0, 1.0, 1.0)];

        GameObject *floor = [self createGameObject:@"platformModel" VertShader:@"PlatformShader.vsh" FragShader:@"PlatformShader.fsh" Transformation:floorTransform];
        [tracker addPlatform:floor];
        
        // left wall
        GLKMatrix4 leftWallTransform = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(-4.1, 0.5, -5.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(1.0, 5.0, 1.0)];

        GameObject *wall = [self createGameObject:@"platformModel" VertShader:@"PlatformShader.vsh" FragShader:@"PlatformShader.fsh" Transformation:leftWallTransform];
        [tracker addPlatform:wall];
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

// update the player movement and slide the platform here
- (void) update:(GLKMatrix4) transformations
{
    
    [tracker.player loadTransformation:transformations];
    
    /*
    for (GameObject *platform in tracker.platforms)
    {
        [platform loadTransformation:transformations];
    }
     */
    
    
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
