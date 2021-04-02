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
        
        // make the walls
        float platformThickness = 1;
        float halfWallWidth = platformThickness/2;
        GameObject *leftWall = [[GameObject alloc] init];
        [leftWall initPosition:GLKVector3Make(0, SCREEN_HEIGHT / 2, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(platformThickness, SCREEN_HEIGHT, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:leftWall];
        [physics addObject:leftWall];
        
        GameObject *rightWall = [[GameObject alloc] init];
        [rightWall initPosition:GLKVector3Make(SCREEN_WIDTH, SCREEN_HEIGHT / 2, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(platformThickness, SCREEN_HEIGHT, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:rightWall];
        [physics addObject:rightWall];
        
        
        // make the horizontal platform
        float floorWidth = SCREEN_WIDTH/5 * 2.5;
        GameObject *leftFloor = [[GameObject alloc] init];
        [leftFloor initPosition:GLKVector3Make(floorWidth/2 + halfWallWidth, 0, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:leftFloor];
        [physics addObject:leftFloor];
        
        GameObject *rightFloor = [[GameObject alloc] init];
        [rightFloor initPosition:GLKVector3Make(SCREEN_WIDTH - floorWidth/2 - halfWallWidth, 0, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:rightFloor];
        [physics addObject:rightFloor];
        
        float centerPlatformWidth = SCREEN_WIDTH/3;
        GameObject *middlePlatform = [[GameObject alloc] init];
        [middlePlatform initPosition:GLKVector3Make(SCREEN_WIDTH/2, SCREEN_HEIGHT/4, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(centerPlatformWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:middlePlatform];
        [physics addObject:middlePlatform];
        
        GameObject *leftPlatform = [[GameObject alloc] init];
        float smallPlatformWidth = SCREEN_WIDTH / 4;
        float xPosLeft = smallPlatformWidth / 2 + halfWallWidth;
        float yPos = SCREEN_HEIGHT / 2;
        [leftPlatform initPosition:GLKVector3Make(xPosLeft, yPos, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(smallPlatformWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:leftPlatform];
        [physics addObject:leftPlatform];
        
        
        GameObject *rightPlatform = [[GameObject alloc] init];
        float xPosRight = SCREEN_WIDTH - xPosLeft;
        [rightPlatform initPosition:GLKVector3Make(xPosRight, yPos, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(smallPlatformWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:rightPlatform];
        [physics addObject:rightPlatform];
        
        GameObject *topPlatform = [[GameObject alloc] init];
        [topPlatform initPosition:GLKVector3Make(SCREEN_WIDTH/2, SCREEN_HEIGHT/5 * 4, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(centerPlatformWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:topPlatform];
        [physics addObject:topPlatform];
        
        // ceiling is similar to the floor
        GameObject *leftCeiling = [[GameObject alloc] init];
        [leftCeiling initPosition:GLKVector3Make(floorWidth/2 + halfWallWidth, SCREEN_HEIGHT, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:leftCeiling];
        [physics addObject:leftCeiling];
        
        GameObject *rightCeiling = [[GameObject alloc] init];
        [rightCeiling initPosition:GLKVector3Make(SCREEN_WIDTH - floorWidth/2 - halfWallWidth, SCREEN_HEIGHT, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1) VertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh" ModelName:@"cube" PhysicsBodyType:STATIC];
        [tracker addPlatform:rightCeiling];
        [physics addObject:rightCeiling];
        
        // monster
        Monster *monster = [[Monster alloc] init];
        [monster initPosition:GLKVector3Make( SCREEN_WIDTH/2 + 2, SCREEN_HEIGHT/2 - 2, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(2, 2, 2) VertShader:@"PlayerShader.vsh" AndFragShader:@"PlayerShader.fsh" ModelName:@"cube" PhysicsBodyType:DYNAMIC];
        
        [tracker addMonster:monster];
        [physics addObject:monster];
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
    [self updatePhysics:deltaTime];
    
    // update each object's position based on physics engine's data
    // this is required for non-static physics bodies
    [tracker.player update];
    
    // platforms don't need to be updated
    
    // update all monsters
    for (Monster *monster in tracker.monsters)
    {
        [monster update];
    }
}

- (void) updatePhysics:(float) deltaTime
{
    [physics update:deltaTime];
    
    for (ContactDetected *contactDetected in physics.contacts)
    {
        if (tracker.player.body == contactDetected.bodyA)
        {
            NSLog(@"Contact 1 is the player");
        }
        
        else if (tracker.player.body == contactDetected.bodyB)
        {
            NSLog(@"Contact 2 is the player");
        }
        else
            continue;
        
        for (Monster *monster in tracker.monsters)
        {
            if (monster.body == contactDetected.bodyA)
            {
                NSLog(@"Contact 1 is the monster");
            }
            
            else if (monster.body == contactDetected.bodyB)
            {
                NSLog(@"Contact 2 is the monster");
            }
        }
        
    }
    [physics clearContacts];
    
}

- (void) draw
{
    [renderer clear];
    [renderer draw:tracker.player];
    
    
    for (GameObject *platform in tracker.platforms)
    {
        [renderer draw:platform];
    }
    
    
    for (Monster *monster in tracker.monsters)
    {
        [renderer draw:monster];
    }
    
    
}

@end
