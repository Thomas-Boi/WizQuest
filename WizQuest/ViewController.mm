//
//  ViewController.m
//  glesbasics
//
//  Created by Borna Noureddin on 2020-01-14.
//  Copyright © 2020 BCIT. All rights reserved.
//

#import "ViewController.h"

// movement speeds for the player
const float playerXSpeed = 2;
const float playerYSpeed = 14;

@interface ViewController () {
    GameManager *manager;

    NSTimer *timer;
    bool jumping;
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
    [manager applyImpulseOnPlayer:-playerXSpeed Y:0];
    [manager direction:false];
}

- (IBAction)moveRight:(UIButton *)sender {
    [manager applyImpulseOnPlayer:playerXSpeed Y:0];
    [manager direction:true];
}

- (IBAction)jump:(UIButton *)sender
{
    [manager applyImpulseOnPlayer:0 Y:playerYSpeed];
    
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

- (IBAction)Shoot:(id)sender {
    [manager fireBullet];
}

// MARK: OpenGL setup in ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up the opengl window and draw
    // set up the manager
    GLKView *view = (GLKView *)self.view;
    manager = [[GameManager alloc] init];
    [manager initManager:view];
    
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
    //GLKMatrix4 modelViewMatrix = [playerTransformations getModelViewMatrix];
    [manager update:self.timeSinceLastUpdate];
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [manager draw]; // ###
}

@end
