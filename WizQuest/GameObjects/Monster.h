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
#import "Score.h"

@interface Monster : GameObject

@property (readonly) Score *score;
//@property (readonly) Player *player;
@property bool active;
@property bool spike;

-(id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale MonsterType:(int)type
      ScoreSystem:(Score *)s;
-(void)setInitialStats;
-(void)takeDamage;
-(void)move;
-(void)changeDirection;

@end
#endif /* Monster_h */
