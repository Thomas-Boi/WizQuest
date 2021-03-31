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
        // note: models only accept "cube" or "sphere"
        Player *player = [[Player alloc] init];
        [player initPosition:GLKVector3Make(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(1, 1, 1) VertShader:@"PlayerShader.vsh" AndFragShader:@"PlayerShader.fsh" ModelName:@"cube" PhysicsBodyType:DYNAMIC];
        
        // tracker tracks things to be used for render and physics
        [tracker addPlayer:player];
        
        // physics tracks things for box2D
        [physics addObject:player];
        
        
        GameObject *floor = [[GameObject alloc] init];
        [floor initPosition:GLKVector3Make(SCREEN_WIDTH/2, 0, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(SCREEN_WIDTH, 1, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:floor];
        [physics addObject:floor];
        
        
        GameObject *leftPlatform = [[GameObject alloc] init];
        float smallPlatformWidth = SCREEN_WIDTH / 4;
        float xPos = smallPlatformWidth / 2;
        float yPos = SCREEN_HEIGHT / 3;
        [leftPlatform initPosition:GLKVector3Make(xPos, yPos, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(smallPlatformWidth, 1, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:leftPlatform];
        [physics addObject:leftPlatform];
        
        
        GameObject *rightPlatform = [[GameObject alloc] init];
        xPos = SCREEN_WIDTH - smallPlatformWidth / 2;
        [rightPlatform initPosition:GLKVector3Make(xPos, yPos, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(smallPlatformWidth, 1, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:rightPlatform];
        [physics addObject:rightPlatform];
        
          /*
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

// for the player
- (void)applyImpulseOnPlayer:(float)x Y:(float)y
{
    tracker.player.body->ApplyLinearImpulse(b2Vec2(x, y), tracker.player.body->GetPosition(), true);
}

// update the player movement and any physics here
- (void) update:(float) deltaTime
{
    // update physics engine
    [physics update:deltaTime];
    
    // update each object's position based on physics engine's data
    // this is required for non-static physics bodies
    [tracker.player update];
    
    // platforms don't need to be updated
}

- (void) draw
{
    [renderer clear];
    [renderer draw:tracker.player];
    
    
    for (GameObject *platform in tracker.platforms)
    {
        [renderer draw:platform];
    }
    
    /*
    for (Monster *monster in tracker.monsters)
    {
        [renderer draw:monster];
    }
     */
    
}

@end
