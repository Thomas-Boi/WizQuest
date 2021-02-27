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
}

@end


@implementation GameManager
- (void) initManager:(GLKView *)view
{
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    [renderer loadModels];
    tracker = [[ObjectTracker alloc] init];
}

- (void) addObject:(GameObject *) obj
{
    
}

- (void) update:(GLKMatrix4) transformations
{
    [renderer update:transformations];
}

- (void) draw
{
    [renderer draw];
}

@end
