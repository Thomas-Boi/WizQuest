//
//  ObjectTracker.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "ObjectTracker.h"

@interface ObjectTracker()
{
    // track player separately due to UI
    Player *_player;
    
    // platforms don't change throughout the game
    NSMutableArray *_staticObjs;
    
    // monsters change throughout the game
    NSMutableArray *_monsters;
}

@end

@implementation ObjectTracker

// props
@synthesize player=_player;

- (NSMutableArray *) staticObjs
{
    return _staticObjs;
}

@synthesize monsters=_monsters;

@synthesize bullets;
@synthesize bigbulls;

- (instancetype) init
{
    self = [super init];
    _staticObjs = [NSMutableArray array];
    _monsters = [NSMutableArray array];
    bullets = [NSMutableArray array];
    bigbulls = [NSMutableArray array];
    return self;
}

- (void) addPlayer: (Player *) player
{
    _player = player;
}

- (void) addBullet: (Bullet *) bullet
{
    [bullets addObject:bullet];
}

- (bool) removeBullet: (Bullet *) bullet
{
    if (!bullet.active)
    {
        [bullets removeObject:bullet];
        return true;
    }
    return false;
}

- (void) addBigbull: (Bigbull *) bigbull
{
    [bigbulls addObject:bigbull];
}

- (bool) removeBigbull: (Bigbull *) bigbull
{
    if (!bigbull.active)
    {
        [bigbulls removeObject:bigbull];
        return true;
    }
    return false;
}

- (void) addStaticObj: (GameObject *) obj
{
    [_staticObjs addObject:obj];
}

- (void) addMonster: (Monster *) monster
{
    [_monsters addObject:monster];
}

- (bool) removeMonster:(Monster *)monster
{
    if (!monster.active)
    {
        [_monsters removeObject:monster];
        return true;
    }
    return false;
}

// check and see if we need to delete
// any objects from the array.
- (void) cleanUp
{
    
}

@end
