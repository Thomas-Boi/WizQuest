//
//  Player.m
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#import "Player.h"

@interface Player()
{
    
}

@end

@implementation Player

- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale
{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        [self loadVertShader:@"PlayerShader.vsh" AndFragShader:@"PlayerShader.fsh"];
        [self loadModel:@"cube"];
        self.bodyType = DYNAMIC;
    }
    return self;
}

@end
