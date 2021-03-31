//
//  PhysicsWorld.m
//  WizQuest
//
//  Created by socas on 2021-03-25.
//

#import "PhysicsWorld.h"
// values for the world's steps behaviour
const float MAX_TIMESTEP = 1.0f/60.0f;
const int NUM_VELOCITY_ITERATIONS = 10;
const int NUM_POSITION_ITERATIONS = 3;

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

// add a game object to the game (mass != 0)
- (void) addObject:(GameObject *)obj
{
    switch(obj.bodyType)
    {
        case (DYNAMIC):
            [self addDynamicObject:obj];
            break;
        case (STATIC):
            [self addStaticObject:obj];
            break;
        default:
            return;
    }
}

// add a moving object to the game (mass != 0)
- (void) addDynamicObject:(GameObject *)obj
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(obj.position.x, obj.position.y);
    b2Body *body = world->CreateBody(&bodyDef);
    
    if (body)
    {
        body->SetUserData((__bridge void *)self);
        //body->SetAwake(isActive); // awake will start physics, else nothing happens until it is set to awake
        
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(obj.height/2, obj.width/2);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        body->CreateFixture(&fixtureDef);
        
        // pass the physics body back to the obj
        [obj loadPhysicsBody:body];
    }
}

// add a non-moving object to the game
- (void) addStaticObject:(GameObject *)obj
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.fixedRotation = true;
    bodyDef.position.Set(obj.position.x, obj.position.y);
    b2Body *body = world->CreateBody(&bodyDef);
    
    if (body)
    {
        body->SetUserData((__bridge void *)self);
        
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(obj.height/2, obj.width/2);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.friction = 0.3f;
        body->CreateFixture(&fixtureDef);
        
        // pass the physics body back to the obj
        [obj loadPhysicsBody:body];
    }}


- (void)update:(float)elapsedTime
{
    if (world)
    {
        // keep looping until we iterate through all steps
        // within the elapsed time. The remainder will also
        // count as one step no matter how small
        while (elapsedTime >= 0)
        {
            world->Step(MAX_TIMESTEP, NUM_VELOCITY_ITERATIONS, NUM_POSITION_ITERATIONS);
            elapsedTime -= MAX_TIMESTEP;
        }
    }
}
@end
