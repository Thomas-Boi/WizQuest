//
//  Monster.m
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#import "Monster.h"

@interface Monster()
{
    bool active;
    int monsterType;

    int health;
    float speed;
}
@end


@implementation Monster

-(id)initWithMonsterType:(int)type {
    if (self = [super init]) {
        active = true;
        monsterType = type;
        [self setInitialStats];
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
}

-(void)takeDamage {
    health--;
    if (health == 0) {
        active = false;
        // destroy object
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
}

@end
