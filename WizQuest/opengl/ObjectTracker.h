//
//  ObjectTracker.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef ObjectTracker_h
#define ObjectTracker_h

#import "GameObject.h"
#import <Foundation/Foundation.h>


@interface ObjectTracker : NSObject

@property(readonly) GameObject *player;
@property(readonly) NSMutableArray *platforms;
@property(readonly) NSMutableArray *monsters;

- (void) addPlayer: (GameObject *) player;
- (void) addPlatform: (GameObject *) platform;
- (void) addMonster: (GameObject *) monster;
- (void) cleanUp;

@end

#endif /* ObjectTracker_h */
