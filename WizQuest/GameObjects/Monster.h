//
//  Monster.h
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#ifndef Monster_h
#define Monster_h
#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Wall.h"
#import "Spikes.h"
#import "Bullet.h"

@interface Monster : GameObject

@property bool active;

-(id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale MonsterType:(int)type;
-(void)setInitialStats;
-(void)takeDamage;
-(void)move;
-(void)changeDirection;

@end
#endif /* Monster_h */
