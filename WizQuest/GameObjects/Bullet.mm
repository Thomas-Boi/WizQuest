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

- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale Direction:(int) d
{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        active = true;
        speed = d * 10;
        [self loadVertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh"];
        [self loadModel:@"cube"];
        self.bodyType = DYNAMIC;
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

