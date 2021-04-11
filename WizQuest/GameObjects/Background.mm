//
//  Background.m
//  WizQuest
//
//  Created by socas on 2021-04-10.
//

#import "Background.h"

@interface Background() {
    
}
@end

@implementation Background

- (id)initPosition: (GLKVector3)position Rotation: (GLKVector3)rotation Scale: (GLKVector3)scale
{
    if (self = [super initPosition:position Rotation:rotation Scale:scale]) {
        [self loadVertShader:@"TextureShader.vsh" AndFragShader:@"TextureShader.fsh"];
        [self loadModel:@"cube"];
        [self loadTexture:@"background.png"];
    }
    return self;
}

@end
