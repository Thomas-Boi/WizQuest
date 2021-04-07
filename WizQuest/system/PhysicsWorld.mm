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

#pragma mark - Box2D contact listener class

class PhysicsContactListener : public b2ContactListener
{
public:
    void BeginContact(b2Contact* contact) {};
    void EndContact(b2Contact* contact) {};
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
    {
        b2WorldManifold worldManifold;
        contact->GetWorldManifold(&worldManifold);
        b2PointState state1[2], state2[2];
        b2GetPointStates(state1, state2, oldManifold, contact->GetManifold());
        if (state2[0] == b2_addState)
        {
            // Use contact->GetFixtureA()->GetBody() to get the body
            b2Body *bodyA = contact->GetFixtureA()->GetBody();
            b2Body *bodyB = contact->GetFixtureB()->GetBody();
            
            GameObject *objA = (__bridge GameObject *)(bodyA->GetUserData());
            GameObject *objB = (__bridge GameObject *)(bodyB->GetUserData());
         
            [objA onCollision:objB];
            [objB onCollision:objA];
            
            //[parentObj addContact:bodyA BodyB:bodyB];

        }
    }
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {};
};

#pragma mark - PhysicsWorld

@interface PhysicsWorld()
{
    b2Vec2 *gravity;
    b2World *world;
    PhysicsContactListener *contactListener;
}

@end

@implementation PhysicsWorld


- (id)init
{
    if (self = [super init])
    {
        gravity = new b2Vec2(0.0f, -20.0f);
        world = new b2World(*gravity);
        
        contactListener = new PhysicsContactListener();
        world->SetContactListener(contactListener);
    }
    return self;
}

// add a game object to the game (mass != 0)
- (void) addObject:(GameObject *)obj
{
    b2BodyType type;
    switch(obj.bodyType)
    {
        case (DYNAMIC):
            type = b2_dynamicBody;
            break;
            
        case (KINEMATIC):
            type = b2_kinematicBody;
            break;
            
        case (STATIC):
            type = b2_staticBody;
            break;
        default:
            return;
    }
    
    b2BodyDef bodyDef;
    bodyDef.type = type;
    bodyDef.position.Set(obj.position.x, obj.position.y);
    b2Body *body = world->CreateBody(&bodyDef);
    
    if (body)
    {
        // body keeps a reference to parent object
        body->SetUserData((__bridge void *)obj);
        //body->SetAwake(isActive); // awake will start physics, else nothing happens until it is set to awake
        
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(obj.height/2, obj.width/2);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 1.0f;
        fixtureDef.restitution = 0;
        
        if ([obj isKindOfClass:[Monster class]])
        {
            // all group index with same negative value
            // won't collide with each other
            fixtureDef.filter.groupIndex = -1;
        }
        body->CreateFixture(&fixtureDef);
        
        // pass the physics body back to the obj
        [obj loadPhysicsBody:body];
    }
}


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


- (void) dealloc
{
    if (gravity) delete gravity;
    if (world) delete world;
    if (contactListener) delete contactListener;
}
@end
