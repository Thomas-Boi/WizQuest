//
//  PhysicsWorld.m
//  WizQuest
//
//  Created by socas on 2021-03-25.
//

#import "PhysicsWorld.h"

@interface PhysicsWorld()
{
    b2Vec2 *gravity;
    b2World *world;
    
    
}

@end

@implementation PhysicsWorld

- (id)init
{
    if (self = [super init])
    {
        gravity = new b2Vec2(0.0f, -10.0f);
        world = new b2World(*gravity);
    }
    return self;
}

- (void) addDynamicObject:(GameObject *)obj
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(obj.position.x, obj.position.y);
    b2Body *body = world->CreateBody(&bodyDef);
    if (body)
    {
        body->SetUserData((__bridge void *)self);
        body->SetAwake(false);
        b2PolygonShape dynamicBox;
        //dynamicBox.SetAsBox(BRICK_WIDTH/2, BRICK_HEIGHT/2);
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 1.0f;
        body->CreateFixture(&fixtureDef);
        
    }
}

- (void) addStaticObject:(GameObject *)obj
{
    
}


@end
