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
    NSMutableArray *_platforms;
    
    // monsters change throughout the game
    NSMutableArray *_monsters;
}

@end

@implementation ObjectTracker

// props
@synthesize player=_player;

- (NSMutableArray *) platforms
{
    return _platforms;
}

@synthesize monsters=_monsters;

- (instancetype) init
{
    self = [super init];
    _platforms = [NSMutableArray array];
    _monsters = [NSMutableArray array];
    return self;
}

- (void) addPlayer: (Player *) player
{
    _player = player;
}

- (void) addPlatform: (GameObject *) platform
{
    [_platforms addObject:platform];
}

- (void) addMonster: (Monster *) monster
{
    [_monsters addObject:monster];
}

// check and see if we need to delete
// any objects from the array.
- (void) cleanUp
{
    
}

@end
