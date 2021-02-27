//
//  GameManager.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameManager.h"


@interface GameManager()
{
    Renderer *renderer;
    ObjectTracker *tracker;
    GameObject *obj;
}

@end


@implementation GameManager
- (void) initManager:(GLKView *)view
{
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    [renderer loadModels];
    tracker = [[ObjectTracker alloc] init];
    obj = [[GameObject alloc] init];
    [obj setupVertShader:(char *)"Shader.vsh" AndFragShader:(char *)"Shader.fsh"];
    [obj loadModels];
}

- (void) addObject:(GameObject *) obj
{
    
}

- (void) update:(GLKMatrix4) transformations
{
    [obj loadTransformation:transformations];
}

- (void) draw
{
    [renderer draw:obj];
}

@end
