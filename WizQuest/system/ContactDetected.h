//
//  ContactDetected.h
//  WizQuest
//
//  Created by socas on 2021-04-01.
//

#ifndef ContactDetected_h
#define ContactDetected_h

#import <Foundation/Foundation.h>
#import <Box2D/Box2D.h>

@interface ContactDetected : NSObject
@property(readonly) b2Body *bodyA;
@property(readonly) b2Body *bodyB;

- (void) addContact:(b2Body *) bodyA BodyB:(b2Body *) bodyB;

@end

#endif /* ContactDetected_h */
