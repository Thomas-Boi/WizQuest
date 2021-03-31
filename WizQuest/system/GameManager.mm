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
    PhysicsWorld *physics;
}

@end


@implementation GameManager
- (void) initManager:(GLKView *)view
{
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    
    tracker = [[ObjectTracker alloc] init];
    
    physics = [[PhysicsWorld alloc] init];
    [self createGameScene];
}


// add platforms, and enemies to the tracker
- (void) createGameScene
{
    @autoreleasepool {
        // note: all models use the cube. The param is for future use
        // test data for putting object on the screen
        int depth = 0;
        Player *player = [[Player alloc] init];
        [player initPosition:GLKVector3Make(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, depth) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(1, 1, 1) VertShader:@"PlayerShader.vsh" AndFragShader:@"PlayerShader.fsh" ModelName:@"cube"];
        
        // tracker tracks things to be used for render and physics
        [tracker addPlayer:player];
        
        // physics tracks things for box2D
        [physics addDynamicObject:player IsActive:true];
        
        /*
        // since player depth is 5, init z to be -5
        // floor
        GLKMatrix4 floorTransform = [Transformations createTransformMatrixWithTranslation:GLKVector3Make(0.0, -2.1, -5.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(10.0, 1.0, 1.0)];

        Platform *floor = (Platform *)[self createGameObject:@"platformModel" VertShader:@"PlatformShader.vsh" FragShader:@"PlatformShader.fsh" Transformation:floorTransform];
        [tracker addPlatform:floor];
        
        // left wall
        GLKMatrix4 leftWallTransform = [Transformations createTransformMatrixWithTranslation:GLKVector3Make(-4.1, 0.5, -5.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(1.0, 5.0, 1.0)];

        Platform *wall = (Platform *)[self createGameObject:@"platformModel" VertShader:@"PlatformShader.vsh" FragShader:@"PlatformShader.fsh" Transformation:leftWallTransform];
        [tracker addPlatform:wall];
        
        // monster
        GLKMatrix4 monsterTransform = [Transformations createTransformMatrixWithTranslation:GLKVector3Make(5.0, -1.0, -5.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(1.0, 1.0, 1.0)];

        Monster *monster = (Monster *)[self createGameObject:@"platformModel" VertShader:@"PlayerShader.vsh" FragShader:@"PlayerShader.fsh" Transformation:monsterTransform];
        [tracker addMonster:monster];
        */
        
    }
}

// add object during run time here
- (void) addObject:(GameObject *) obj
{

}

// update the player movement and any physics here
- (void) update:(float) deltaTime
{
    // update physics engine
    [physics update:deltaTime];
    
    // update each object's position based on physics engine's data
    [tracker.player update];
    
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
    
    /*
    for (Platform *platform in tracker.platforms)
    {
        [renderer draw:platform];
    }
    
    for (Monster *monster in tracker.monsters)
    {
        [renderer draw:monster];
    }
     */
    
}

@end
