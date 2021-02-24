//
//  ViewController.m
//  glesbasics
//
//  Created by Borna Noureddin on 2020-01-14.
//  Copyright © 2020 BCIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    Renderer *glesRenderer; // ###
    Transformations *transformations;
    
}
@end

@implementation ViewController

// MARK: Action buttons

- (IBAction)leftButton:(UIButton *)sender {
    
}

- (IBAction)rightButton:(UIButton *)sender {
    
}

// MARK: OpenGL setup in ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // ### <<<
    // set up the opengl window and draw

    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
    
    // Initialize transformations
    // by default everything is normal
    transformations = [[Transformations alloc] initWithDepth:5.0f Scale:1.0f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];

    // ### >>>
    
}

- (void)update
{
    GLKMatrix4 modelViewMatrix = [transformations getModelViewMatrix];
    [glesRenderer update:modelViewMatrix]; // ###
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw:rect]; // ###
}

@end
