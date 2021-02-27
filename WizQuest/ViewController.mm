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
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation ViewController

// MARK: Handle actions

- (IBAction)moveLeft:(UIButton *)sender {
    [transformations translateBy:GLKVector2Make(-0.05f, 0.0f)];
}

- (IBAction)moveRight:(UIButton *)sender {
    [transformations translateBy:GLKVector2Make(0.05f, 0.0f)];
}

- (void)longPressHandler:(UILongPressGestureRecognizer*)gesture {
    if (gesture.view == _leftButton) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLeft:) userInfo:nil repeats:true];
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            [timer invalidate];
            timer = nil;
        }
    } else if (gesture.view == _rightButton) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveRight:) userInfo:nil repeats:true];
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            [timer invalidate];
            timer = nil;
        }
    }
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
<<<<<<< HEAD
    transformations = [[Transformations alloc] initWithDepth:5.0f Scale:1.0f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    
    [transformations start];
    // ### >>
=======
    transformations = [[Transformations alloc] initWithDepth:5.0f Scale:0.5f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 45.0f)];
>>>>>>> Added basic code into the GameObject
    
    UILongPressGestureRecognizer *leftPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    UILongPressGestureRecognizer *rightPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    [self.leftButton addGestureRecognizer:leftPress];
    [self.rightButton addGestureRecognizer:rightPress];
    
    leftPress.minimumPressDuration = 0.0f;
    rightPress.minimumPressDuration = 0.0f;
    
}

- (void)update
{
    GLKMatrix4 modelViewMatrix = [transformations getModelViewMatrix];
    [glesRenderer update:modelViewMatrix]; // ###
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw]; // ###
}

<<<<<<< HEAD
=======
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Begin transformations
    [transformations start];
}



- (void)moveCube:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:sender.view];
    float x = translation.x/sender.view.frame.size.width;
    float y = translation.y/sender.view.frame.size.height;
    GLKVector2 translate = GLKVector2Make(x, y);
    [transformations translate:translate withMultiplier:5.0f];
}

- (void)rotateCube:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:sender.view];
    // only get the horizontal component
    float x = translation.x/sender.view.frame.size.width;
    [transformations rotate:x withMultiplier:5.0f];
}

>>>>>>> Added basic code into the GameObject
@end
