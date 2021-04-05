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

@interface Monster : GameObject

-(id)initWithMonsterType:(int)type;
-(void)setInitialStats;
-(void)takeDamage;
-(void)move;
-(void)changeDirection;

@end
#endif /* Monster_h */
