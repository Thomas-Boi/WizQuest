//
//  ObjectTracker.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef ObjectTracker_h
#define ObjectTracker_h

#import "Player.h"
#import "Monster.h"
#import <Foundation/Foundation.h>


@interface ObjectTracker : NSObject

@property(readonly) Player *player;
@property(readonly) NSMutableArray *platforms;
@property(readonly) NSMutableArray *monsters;

- (void) addPlayer: (Player *) player;
- (void) addPlatform: (GameObject *) platform;
- (void) addMonster: (Monster *) monster;
- (bool) removeMonster:(Monster *)monster;
- (void) cleanUp;

@end

#endif /* ObjectTracker_h */
