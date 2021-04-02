//
//  ContactDetected.m
//  WizQuest
//
//  Created by socas on 2021-04-01.
//

#import "ContactDetected.h"

@interface ContactDetected()
{
    b2Body *_bodyA, *_bodyB;
}

@end

@implementation ContactDetected

@synthesize bodyA=_bodyA;
@synthesize bodyB=_bodyB;

- (void) addContact:(b2Body *) bA BodyB:(b2Body *) bB
{
    _bodyA = bA;
    _bodyB = bB;
}

@end
