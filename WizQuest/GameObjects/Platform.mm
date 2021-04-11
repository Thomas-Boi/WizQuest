//
//  Platform.m
//  WizQuest
//
//  Created by socas on 2021-03-02.
//

#import "Platform.h"

@interface Platform()
{
    
}
@end

@implementation Platform

- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale
{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        [self loadVertShader:@"PlatformShader.vsh" AndFragShader:@"PlatformShader.fsh"];
        [self loadModel:@"cube"];
        self.bodyType = STATIC;
    }
    return self;
}

@end
