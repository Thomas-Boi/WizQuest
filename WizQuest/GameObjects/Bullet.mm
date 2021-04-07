//
//  Bullet.m
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#import "Bullet.h"

@interface Bullet()
{
    float speed;
}

@end

@implementation Bullet

@synthesize active;

- (id) initWithDirection:(int) d
{
    if (self = [super init]) {
        active = true;
        speed = d * 10;
    }
    return self;
}


-(void)move {
    self.body->SetLinearVelocity(b2Vec2(speed, 0.6));
}

- (void) onCollision:(GameObject *)otherObj
{
    if (![otherObj isKindOfClass:[Player class]])
    {
        active = false;
    }
}

@end

