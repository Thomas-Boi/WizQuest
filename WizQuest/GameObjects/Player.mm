//
//  Player.m
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#import "Player.h"

@interface Player()
{

}

@end

@implementation Player
@synthesize active;
@synthesize health;

- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale
{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        [self loadVertShader:@"PlayerShader.vsh" AndFragShader:@"PlayerShader.fsh"];
        [self loadModel:@"cube"];
        self.bodyType = DYNAMIC;
        
        [self resetDamage];
    }
    return self;
}

-(void)takeDamage {
    health--;
    if (health == 0) {
        active = false;
    }
}

-(void)resetDamage {
    active = true;
    health = 3;
}

- (void) onCollision:(GameObject *)otherObj
{
    if ([otherObj isKindOfClass:[Monster class]])
    {
        [self takeDamage];
    }
    if ([otherObj isKindOfClass:[Spikes class]])
    {
        active = false;
    }
}
  
@end
