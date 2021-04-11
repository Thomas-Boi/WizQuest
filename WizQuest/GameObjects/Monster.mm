//
//  Monster.m
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#import "Monster.h"

@interface Monster()
{
    int monsterType;

    int health;
    float speed;
}
@end


@implementation Monster

@synthesize active;

-(id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale MonsterType:(int)type {
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        active = true;
        monsterType = type;
        [self loadVertShader:@"PlayerShader.vsh" AndFragShader:@"PlayerShader.fsh"];
        [self loadModel:@"cube"];
        [self setInitialStats];
        self.bodyType = DYNAMIC;
    }
    return self;
    
}

-(void)setInitialStats {
    switch (monsterType) {
        case 1:  // Slow moving monster, 3 hp
            health = 3;
            speed = 3.5;
            break;
        case 2: // Fast moving monster, 1 hp
            health = 1;
            speed = 6.0;
            break;
        case 3: // Big monster, same as slow except 5 hp
            health = 5;
            speed = 3.5;
            break;
    }
    
    // random speed in both direction
    bool faceRight = arc4random_uniform(2);
    if (!faceRight)
    {
        speed = -speed;
    }
}

-(void)takeDamage {
    health--;
    if (health == 0) {
        active = false;
    }
}

-(void)changeDirection {
    speed = -speed;
}

-(void)move {
    float y = self.body->GetLinearVelocity().y;
    self.body->SetLinearVelocity(b2Vec2(speed, y));
}

- (void) onCollision:(GameObject *)otherObj
{
    if ([otherObj isKindOfClass:[Wall class]])
    {
        [self changeDirection];
    }
    if ([otherObj isKindOfClass:[Spikes class]])
    {
        active = false;
    }
    if ([otherObj isKindOfClass:[Bullet class]])
    {
        [self takeDamage];
    }
}

@end
