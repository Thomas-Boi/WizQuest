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
    Transformations *playerTransformations;
    Transformations *platformTransformations;

    NSTimer *timer;
    NSTimer *jumpTimer;
    int jumpCount;
}

// MARK: Button references

@property (weak, nonatomic) IBOutlet UIView *actBtnView;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *shootButton;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@end

@implementation ViewController

// MARK: Handle actions

- (IBAction)moveLeft:(UIButton *)sender {
    [playerTransformations translateBy:GLKVector2Make(-0.05f, 0.0f)];
}

- (IBAction)moveRight:(UIButton *)sender {
    [playerTransformations translateBy:GLKVector2Make(0.05f, 0.0f)];
}

- (IBAction)jump:(UIButton *)sender {
    if (jumpTimer != nil) {
        return;
    }
    jumpTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(performJump) userInfo:nil repeats:true];
}

- (void)performJump {
    jumpCount++;
    if (jumpCount > 35) {
        [playerTransformations translateBy:GLKVector2Make(0.0f, -0.04f)];
    } else {
        [playerTransformations translateBy:GLKVector2Make(0.0f, 0.04f)];
    }
    // reset jump timer and counter
    if (jumpCount >= 70) {
        [jumpTimer invalidate];
        jumpTimer = nil;
        jumpCount = 0;
    }
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

    // Initialize transformations for the player
    playerTransformations = [[Transformations alloc] initWithDepth:5.0f Scale:1.0f Translation:GLKVector2Make(0.0f, -1.0f) Rotation:0 RotationAxis:GLKVector3Make(0.0, 0.0, 1.0)];
    [playerTransformations start];
    
    // set up the opengl window and draw
    // set up the manager
    GLKView *view = (GLKView *)self.view;
    manager = [[GameManager alloc] init];
    GLKMatrix4 initialPlayerTransformation = [playerTransformations getModelViewMatrix];
    [manager initManager:view initialPlayerTransform:initialPlayerTransformation];
    
    // set up UI buttons
    UILongPressGestureRecognizer *leftPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    UILongPressGestureRecognizer *rightPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    [self.leftButton addGestureRecognizer:leftPress];
    [self.rightButton addGestureRecognizer:rightPress];
    
    leftPress.minimumPressDuration = 0.0f;
    rightPress.minimumPressDuration = 0.0f;
    
    // Set jump/shoot buttons to be bottom right
    self.actBtnView.translatesAutoresizingMaskIntoConstraints = false;
    [self.actBtnView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.actBtnView.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.actBtnView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.actBtnView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.actBtnView.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.actBtnView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

    
}

- (void)update
{
    GLKMatrix4 modelViewMatrix = [playerTransformations getModelViewMatrix];
    [manager update:modelViewMatrix];
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [manager draw]; // ###
}

@end
