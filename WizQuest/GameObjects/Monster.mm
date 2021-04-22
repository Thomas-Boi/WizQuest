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

    int health, value;
    float speed;
}
@end


@implementation Monster

@synthesize active;
@synthesize spike;
@synthesize score;
//@synthesize player;

-(id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale MonsterType:(int)type
      ScoreSystem:(Score *)s{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        spike = active = true;
        monsterType = type;
        score = s;
        [self loadVertShader:@"TextureShader.vsh" AndFragShader:@"TextureShader.fsh"];
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
            value = 1;
            [self loadModel:@"spider"];
            [self loadTexture:@"spider.png"];
            break;
        case 2: // Fast moving monster, 1 hp
            health = 1;
            speed = 6.0;
            value = 1;
            [self loadModel:@"jaguar"];
            [self loadTexture:@"jaguar.png"];
            break;
        case 3: // Big monster, same as slow except 5 hp
            health = 5;
            speed = 3.5;
            value = 2;
            [self loadModel:@"boar"];
            [self loadTexture:@"boar.png"];
            break;
    }
    
    // random speed in both direction
    bool faceRight = arc4random_uniform(2);
    // recall by default everything faces right
    if (!faceRight)
    {
        [self changeDirection];
    }
}

-(void)takeDamage:(int)damage
{
    health -= damage;
    if (health <= 0) {
        [score addPoints:value];
        active = false;
    }
}

-(void)changeDirection {
    speed = -speed;
    [self flipFaceRight:!self.isFacingRight];
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
        spike = active = false;
    }
    if ([otherObj isKindOfClass:[Bullet class]])
    {
        [self takeDamage:1];
    }
	if ([otherObj isKindOfClass:[Bigbull class]])
    {
        [self takeDamage:3];
    }
}

@end
