//
//  Bullet.h
//  WizQuest
//
//  Created by socas on 2021-04-06.
//

#ifndef Bullet_h
#define Bullet_h

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Wall.h"
#import "Player.h"
#import "Monster.h"

@interface Bullet: GameObject

@property bool active;
-(void)move;
- (id) initWithDirection:(int) d;

@end
#endif 
