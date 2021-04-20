//
//  Player.h
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#ifndef Player_h
#define Player_h

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Monster.h"
#import "Spikes.h"

@interface Player : GameObject

@property bool active;
@property int health;

-(void)resetDamage;
-(void)takeDamage;

@end

#endif /* Player_h */
