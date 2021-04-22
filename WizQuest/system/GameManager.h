//
//  GameManager.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef GameManager_h
#define GameManager_h
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "GameObject.h"
#import "Player.h"
#import "Wall.h"
#import "Monster.h"
#import "Spikes.h"
#import "Renderer.h"
#import "ObjectTracker.h"
#import "Transformations.h"
#import "PhysicsWorld.h"
#import "PhysicsBodyTypeEnum.h"
#import "MonsterInfo.h"
#import "Bullet.h"
#import "Bigbull.h"
#import "Platform.h"
#import "Background.h"
#import "Score.h"

@interface GameManager : NSObject

@property (readonly) Score *score;
//@property (readonly) Player *player;

- (void) initManager:(GLKView *)view;

// for the player and UI 
- (void) applyImpulseOnPlayer:(float)x Y:(float)y;
- (void) fireBullet;
- (void) respawn;
- (void) fireBigbull;
- (void) update:(float) deltaTime;
- (void) draw;
- (int) GetPlayerHealth;

@end


#endif /* GameManager_h */
