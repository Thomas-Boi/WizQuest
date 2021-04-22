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
#import "Bullet.h"
#import "Bigbull.h"
#import <Foundation/Foundation.h>


@interface ObjectTracker : NSObject

@property(readonly) Player *player;
@property(readonly) NSMutableArray *staticObjs;
@property(readonly) NSMutableArray *monsters;
@property(readonly) NSMutableArray *bullets;
@property(readonly) NSMutableArray *bigbulls;

- (void) addPlayer: (Player *) player;
- (void) addStaticObj: (GameObject *) obj;
- (void) addMonster: (Monster *) monster;
- (void) addBullet: (Bullet *) bullet;
- (void) addBigbull: (Bigbull *) bigbull;
- (bool) removeMonster:(Monster *)monster;
- (bool) removeBullet:(Bullet *) bullet;
- (bool) removeBigbull:(Bigbull *) bigbull;
- (void) cleanUp;

@end

#endif /* ObjectTracker_h */
