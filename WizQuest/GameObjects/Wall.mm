//
//  Wall.m
//  WizQuest
//
//  Created by Sebastian Bejm on 2021-04-04.
//

#import "Wall.h"

@interface Wall() {
    
}
@end

@implementation Wall

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
