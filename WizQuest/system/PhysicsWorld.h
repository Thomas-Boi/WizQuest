//
//  PhysicsWorld.h
//  WizQuest
//
//  Created by socas on 2021-03-25.
//

#ifndef PhysicsWorld_h
#define PhysicsWorld_h

#import <Foundation/Foundation.h>
#import <Box2D/Box2D.h>
#import "GameObject.h"
#import "Monster.h"
#import "PhysicsBodyTypeEnum.h"

@interface PhysicsWorld : NSObject

- (void) update:(float)elapsedTime;
- (void) addObject:(GameObject *)obj;

@end
#endif /* PhysicsWorld_h */
