//
//  Bigbull.m
//  WizQuest
//
//  Created by socas on 2021-04-11.
//

#import "Bigbull.h"

@interface Bigbull()
{
    float speed;
}

@end

@implementation Bigbull

@synthesize active;

- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale Direction:(int) d
{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        active = true;
        speed = d * 20;
        [self loadVertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh"];
        [self loadModel:@"cube"];
        self.bodyType = DYNAMIC;
    }
    return self;
}


-(void)move {
    self.body->SetLinearVelocity(b2Vec2(speed, 0.6));
}

-(void)del {
    active = false;
}

- (void) onCollision:(GameObject *)otherObj
{
    if (![otherObj isKindOfClass:[Player class]])
    {
        active = false;
    }
}

@end
