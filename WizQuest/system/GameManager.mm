//
//  GameManager.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameManager.h"

const GLKVector2 MONSTER_SPAWN_POSITION = GLKVector2Make(SCREEN_CENTER_X, SCREEN_TOP_Y);

@interface GameManager()
{
    Renderer *renderer;
    ObjectTracker *tracker;
    PhysicsWorld *physics;
    
    float elapsedMonsterSpawnTime;
	float elapsedBulletTime;
}

@end

@implementation GameManager
@synthesize score;
//@synthesize player;

- (void) initManager:(GLKView *)view
{
    elapsedMonsterSpawnTime = MONSTER_SPAWN_TIME;
	elapsedBulletTime = BULLET_SPAWN_TIME;
    
    // this will change the game screen size
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    
    tracker = [[ObjectTracker alloc] init];
    
    physics = [[PhysicsWorld alloc] init];
    [self createGameScene];

    score = [[Score alloc] init];
}


// add platforms, and enemies to the tracker
- (void) createGameScene
{
    @autoreleasepool {
        // wall stats
        float platformThickness = 1;
        float halfWallWidth = platformThickness/2;
        
        // background
        Background *background = [[Background alloc] initPosition:GLKVector3Make(SCREEN_CENTER_X, SCREEN_CENTER_Y, DEPTH-1) Rotation:GLKVector3Make(0, 0, 180) Scale:GLKVector3Make(SCREEN_WIDTH + platformThickness, SCREEN_HEIGHT + platformThickness, 1)];
    
        [tracker addStaticObj:background];
        
        // note: models only accept "cube" or "sphere"
        Player* player = [[Player alloc] initPosition:GLKVector3Make(SCREEN_CENTER_X, SCREEN_CENTER_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(1, 1, 1)];
        
        // tracker tracks things to be used for render and physics
        [tracker addPlayer:player];
        // physics tracks things for box2D
        [physics addObject:player];
        
        // make the walls
        Wall *leftWall = [[Wall alloc] initPosition:GLKVector3Make(SCREEN_LEFT_X, SCREEN_CENTER_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(platformThickness, SCREEN_HEIGHT, 1)];
        [tracker addStaticObj:leftWall];
        [physics addObject:leftWall];
        
        Wall *rightWall = [[Wall alloc] initPosition:GLKVector3Make(SCREEN_RIGHT_X, SCREEN_CENTER_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(platformThickness, SCREEN_HEIGHT, 1)];
        [tracker addStaticObj:rightWall];
        [physics addObject:rightWall];
        
        
        // make the horizontal platform ( bottom)
        float floorWidth = (float) SCREEN_WIDTH / 5 * 2;
        Platform *leftFloor = [[Platform alloc] initPosition:GLKVector3Make(floorWidth/2 + halfWallWidth + SCREEN_LEFT_X, SCREEN_BOTTOM_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1)];
        [tracker addStaticObj:leftFloor];
        [physics addObject:leftFloor];
        
        Platform *rightFloor = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_RIGHT_X - floorWidth/2 - halfWallWidth, SCREEN_BOTTOM_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1)];
        [tracker addStaticObj:rightFloor];
        [physics addObject:rightFloor];
        
        // center platform
        float centerPlatformWidth = SCREEN_WIDTH/3;
        Platform *middlePlatform = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_CENTER_X, SCREEN_BOTTOM_Y + SCREEN_HEIGHT/4, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(centerPlatformWidth, platformThickness, 1)];
        [tracker addStaticObj:middlePlatform];
        [physics addObject:middlePlatform];
        
        // second from top platforms
        float smallPlatformWidth = SCREEN_WIDTH / 4;
        float xPosOffset = smallPlatformWidth / 2 + halfWallWidth;
        float yPos = SCREEN_TOP_Y - SCREEN_HEIGHT / 2;
        Platform *leftPlatform = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_LEFT_X + xPosOffset, yPos, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(smallPlatformWidth, platformThickness, 1)];
        [tracker addStaticObj:leftPlatform];
        [physics addObject:leftPlatform];
        
        
        Platform *rightPlatform = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_RIGHT_X - xPosOffset, yPos, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(smallPlatformWidth, platformThickness, 1)];
        [tracker addStaticObj:rightPlatform];
        [physics addObject:rightPlatform];
        
        // top most platform
        Platform *topPlatform = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_CENTER_X,    SCREEN_TOP_Y - SCREEN_HEIGHT/5, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(centerPlatformWidth, platformThickness, 1)];
        [tracker addStaticObj:topPlatform];
        [physics addObject:topPlatform];
        
        // ceiling is similar to the floor
        Platform *leftCeiling = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_LEFT_X + floorWidth/2 + halfWallWidth, SCREEN_TOP_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1)];
        [tracker addStaticObj:leftCeiling];
        [physics addObject:leftCeiling];
        
        Platform *rightCeiling = [[Platform alloc] initPosition:GLKVector3Make(SCREEN_RIGHT_X - floorWidth/2 - halfWallWidth, SCREEN_TOP_Y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1)];
        [tracker addStaticObj:rightCeiling];
        [physics addObject:rightCeiling];
        
        // make kill floor at bottom
        Spikes *killFloor = [[Spikes alloc] initPosition:GLKVector3Make(SCREEN_CENTER_X , SCREEN_BOTTOM_Y - 5, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorWidth, platformThickness, 1)];
        [tracker addStaticObj:killFloor];
        [physics addObject:killFloor];

    }
}

// for the player
- (void)movePlayerVelocity:(float)x Y:(float)y
{
    float impulse = x * tracker.player.body->GetMass();
    tracker.player.body->ApplyLinearImpulse(b2Vec2(impulse, y), tracker.player.body->GetPosition(), true);
    [tracker.player flipFaceRight:x > 0];
}

- (int) GetPlayerHealth
{
    return tracker.player.health;
}

// update the player movement and any physics here
- (void) update:(float) deltaTime
{
    //NSLog(@"highscore: %i, current score: %i", score.highScore, score.currentScore);
    // update physics engine
    [physics update:deltaTime];
    
    [tracker.player update];
    
    // platforms don't need to be updated
    
    // update all monsters
    for (NSInteger i = tracker.monsters.count - 1; i >= 0 ; i--)
    {
        if ([tracker removeMonster:tracker.monsters[i]])
            continue;
        [tracker.monsters[i] move];
        [tracker.monsters[i] update];
    }
    [self spawnMonster:deltaTime];
    
    for (NSInteger i = tracker.bullets.count - 1; i >= 0 ; i--)
    {
        if ([tracker removeBullet:tracker.bullets[i]])
            continue;
        [tracker.bullets[i] move];
        [tracker.bullets[i] update];
    }
    
    for (NSInteger i = tracker.bigbulls.count - 1; i >= 0 ; i--)
    {
        if ([tracker removeBigbull:tracker.bigbulls[i]])
            continue;
        [tracker.bigbulls[i] move];
        [tracker.bigbulls[i] update];
    }
}

- (void) respawn
{
    for (Monster *monster in tracker.monsters)
        monster.active = false;
    for (Monster *bullet in tracker.bullets)
        bullet.active = false;
    [tracker.player resetDamage];
    
    b2Vec2 playerInitPos = b2Vec2(SCREEN_CENTER_X, SCREEN_CENTER_Y);
    tracker.player.body->SetTransform(playerInitPos, 0);
    
    [score resetCurrent];
}

- (void) spawnMonster:(float) deltaTime
{
    //NSLog(@"%.2f", elapsedMonsterSpawnTime);
    if (tracker.monsters.count >= MONSTER_MAX_COUNT)
        return;
    
    if (MONSTER_SPAWN_TIME >= (elapsedMonsterSpawnTime += deltaTime))
        return;
    
    elapsedMonsterSpawnTime = 0.0f;
    
    int r = arc4random_uniform(3) + 1;
    
    GLKVector3 scale;
    switch (r) {
        case 1:
            scale = GLKVector3Make(1, 1, 1);
            break;
        case 2:
            scale = GLKVector3Make(1, 1, 1);
            break;
        default:
            scale = GLKVector3Make(1, 1, 1);
            break;
    }
    
    Monster *monster = [[Monster alloc] initPosition:GLKVector3Make( MONSTER_SPAWN_POSITION.x, MONSTER_SPAWN_POSITION.y, DEPTH) Rotation:GLKVector3Make(0, 0, 0) Scale:scale MonsterType:r ScoreSystem:score];
    
    [tracker addMonster:monster];
    [physics addObject:monster];
    
}

// add object during run time here
- (void) fireBullet
{
    // don't want too many bullets flying around
    if (tracker.bullets.count >= BULLET_MAX_COUNT)
        return;
    
    Bullet *bullet = [[Bullet alloc] initPosition:GLKVector3Make(tracker.player.position.x + (tracker.player.isFacingRight? 1 :-1), tracker.player.position.y , tracker.player.position.z) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(0.5, 0.5, 0.5) Direction:(tracker.player.isFacingRight? 1:-1)];
    [tracker addBullet:bullet];
    [physics addObject:bullet];
}

- (void) fireBigbull
{
    // don't want too many bullets flying around
    if (tracker.bigbulls.count >= 1)
        return;
    
    elapsedBulletTime = 0.0f;
    
    Bigbull *bigbull = [[Bigbull alloc] initPosition:GLKVector3Make(tracker.player.position.x + (tracker.player.isFacingRight? 1 : -1), tracker.player.position.y + 0.6 , tracker.player.position.z) Rotation:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(0.25, 2.0, 1) Direction:(tracker.player.isFacingRight? 1 : -1)];
    [tracker addBigbull:bigbull];
    [physics addObject:bigbull];
}

- (void) draw
{
    [renderer clear];
    
    if(tracker.player.active)
        [renderer draw:tracker.player];
    
    
    for (GameObject *platform in tracker.staticObjs)
    {
        [renderer draw:platform];
    }
    
    
    for (Monster *monster in tracker.monsters)
    {
        [renderer draw:monster];
    }
    
    for (Bullet *bullet in tracker.bullets)
    {
        [renderer draw:bullet];
    }
    
    for (Bigbull *bigbull in tracker.bigbulls)
    {
        [renderer draw:bigbull];
    }
    
}

@end
