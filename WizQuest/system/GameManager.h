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
#import "Monster.h"
#import "Renderer.h"
#import "ObjectTracker.h"
#import "Transformations.h"
#import "PhysicsWorld.h"
#import "PhysicsBodyTypeEnum.h"

@interface GameManager : NSObject

- (void) initManager:(GLKView *)view;
// for the player and UI 
- (void) applyImpulseOnPlayer:(float)x Y:(float)y;
- (void) addObject:(GameObject *) obj;
- (void) update:(float) deltaTime;
- (void) draw;

@end


#endif /* GameManager_h */