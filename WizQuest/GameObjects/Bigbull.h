//
//  Bigbull.h
//  WizQuest
//
//  Created by socas on 2021-04-11.
//

#ifndef Bigbull_h
#define Bigbull_h

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Wall.h"
#import "Player.h"
#import "Monster.h"

@interface Bigbull: GameObject

@property bool active;
-(void)move;
-(void)del;
- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale Direction:(int) d;

@end
#endif
