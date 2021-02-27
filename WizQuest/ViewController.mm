//
//  ViewController.m
//  glesbasics
//
//  Created by Borna Noureddin on 2020-01-14.
//  Copyright © 2020 BCIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    GameManager *manager;
    Transformations *transformations;
<<<<<<< HEAD
    NSTimer *timer;
=======
    Transformations *platformTransformations;
    __weak IBOutlet UILabel *positionLabel;
    __weak IBOutlet UILabel *rotationLabel;
    
>>>>>>> GameManager now use ObjectTracker and Transformation to draw object
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
    // Initialize transformations
    // by default everything is normal
    transformations = [[Transformations alloc] initWithDepth:5.0f Scale:0.5f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 45.0f)];
    
    // set up the manager
    GLKView *view = (GLKView *)self.view;
    manager = [[GameManager alloc] init];
    [manager initManager:view];
    
<<<<<<< HEAD
    // Initialize transformations
    // by default everything is normal
    transformations = [[Transformations alloc] initWithDepth:5.0f Scale:1.0f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    
    [transformations start];
    // ### >>
    
    UILongPressGestureRecognizer *leftPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    UILongPressGestureRecognizer *rightPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    [self.leftButton addGestureRecognizer:leftPress];
    [self.rightButton addGestureRecognizer:rightPress];
    
    leftPress.minimumPressDuration = 0.0f;
    rightPress.minimumPressDuration = 0.0f;
    
=======
    
    // ### >>>
>>>>>>> GameManager now use ObjectTracker and Transformation to draw object
}

- (void)update
{
    //GLKMatrix4 modelViewMatrix = [transformations getModelViewMatrix];
    //[manager update:modelViewMatrix];
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [manager draw]; // ###
}

@end
