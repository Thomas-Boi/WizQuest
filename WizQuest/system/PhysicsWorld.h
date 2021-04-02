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
#import "PhysicsBodyTypeEnum.h"
#import "ContactDetected.h"

@interface PhysicsWorld : NSObject
@property(readonly) NSMutableArray *contacts;

- (void) update:(float)elapsedTime;
- (void) addObject:(GameObject *)obj;
- (void) addContact:(b2Body *) bodyA BodyB:(b2Body *) bodyB;
- (void) clearContacts;

@end
#endif /* PhysicsWorld_h */
