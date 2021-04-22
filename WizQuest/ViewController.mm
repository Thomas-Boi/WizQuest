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

// MARK: UI References
@property (weak, nonatomic) IBOutlet UIStackView *playerHealth;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *shootButton;
@property (weak, nonatomic) IBOutlet UIButton *shootButton2;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@property UIView *gameOverView;
@property UILabel *currentScoreLabel;
@property UILabel *highScoreLabel;

@end

@implementation ViewController

// MARK: Handle actions

- (IBAction)moveLeft:(UIButton *)sender {
    [manager movePlayerVelocity:-playerXSpeed Y:0];
}

- (IBAction)moveRight:(UIButton *)sender {
    [manager movePlayerVelocity:playerXSpeed Y:0];
}

- (IBAction)jump:(UIButton *)sender
{
    [manager movePlayerVelocity:0 Y:playerYSpeed];
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

- (IBAction)Shoot2:(id)sender {
    [manager fireBigbull];
}


// MARK: Adding GameOver Screen

- (void) initGameOverScreen {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    // view setup
    self.gameOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width / 2, height / 1.5)];
    self.gameOverView.center = self.view.center;
    self.gameOverView.backgroundColor = [UIColor lightGrayColor];
    
    // add labels
    UILabel *gameOverTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    [gameOverTitle setText:@"Game Over!"];
    gameOverTitle.font = [gameOverTitle.font fontWithSize:34];
    gameOverTitle.textAlignment = NSTextAlignmentCenter;
    gameOverTitle.center = CGPointMake(self.gameOverView.frame.origin.x, 35);
    gameOverTitle.textColor = [UIColor blackColor];
    [self.gameOverView addSubview:gameOverTitle];
    
    self.currentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.currentScoreLabel.font = [self.currentScoreLabel.font fontWithSize:22];
    self.currentScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.currentScoreLabel.center = CGPointMake(self.gameOverView.frame.origin.x, 110);
    self.currentScoreLabel.textColor = [UIColor redColor];
    [self.gameOverView addSubview:self.currentScoreLabel];
    
    self.highScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.highScoreLabel.font = [self.highScoreLabel.font fontWithSize:22];
    self.highScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.highScoreLabel.center = CGPointMake(self.gameOverView.frame.origin.x, 140);
    self.highScoreLabel.textColor = [UIColor redColor];
    [self.gameOverView addSubview:self.highScoreLabel];
    
    // add retry button
    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    [retryButton setTitle:@"Restart" forState:UIControlStateNormal];
    retryButton.titleLabel.font = [retryButton.titleLabel.font fontWithSize:26];
    retryButton.titleLabel.textColor = [UIColor blackColor];
    retryButton.center = CGPointMake(self.gameOverView.frame.origin.x, 180);
    [self.gameOverView addSubview:retryButton];
    
    [retryButton addTarget:self action:@selector(restartGame) forControlEvents:UIControlEventTouchUpInside];
        
}

-(void)restartGame {
    [self.gameOverView setHidden:true];
    [manager respawn];
}

// MARK: OpenGL setup in ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up the opengl window and draw
    // set up the manager
    GLKView *view = (GLKView *)self.view;
    manager = [[GameManager alloc] init];
    [manager initManager:view];
    
    // set up game over screen and hide it initially
    [self initGameOverScreen];
    [self.view addSubview:self.gameOverView];
    self.gameOverView.userInteractionEnabled = true;
    [self.gameOverView setHidden:true];
    
    // set up UI buttons
    UILongPressGestureRecognizer *leftPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    UILongPressGestureRecognizer *rightPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    [self.leftButton addGestureRecognizer:leftPress];
    [self.rightButton addGestureRecognizer:rightPress];
    
    leftPress.minimumPressDuration = 0.0f;
    rightPress.minimumPressDuration = 0.0f;
    
}

- (void)updatePlayerHealth {
    int currentHealth = [manager GetPlayerHealth];
    switch (currentHealth) {
        case 3:
            [[[self.playerHealth subviews] objectAtIndex:2] setHidden:false];
            [[[self.playerHealth subviews] objectAtIndex:1] setHidden:false];
            [[[self.playerHealth subviews] objectAtIndex:0] setHidden:false];
            break;
        case 2:
            [[[self.playerHealth subviews] objectAtIndex:2] setHidden:true];
            [[[self.playerHealth subviews] objectAtIndex:1] setHidden:false];
            [[[self.playerHealth subviews] objectAtIndex:0] setHidden:false];
            break;
        case 1:
            [[[self.playerHealth subviews] objectAtIndex:2] setHidden:true];
            [[[self.playerHealth subviews] objectAtIndex:1] setHidden:true];
            [[[self.playerHealth subviews] objectAtIndex:0] setHidden:false];
            break;
        case 0:
            [[[self.playerHealth subviews] objectAtIndex:2] setHidden:true];
            [[[self.playerHealth subviews] objectAtIndex:1] setHidden:true];
            [[[self.playerHealth subviews] objectAtIndex:0] setHidden:true];
            break;
    }

}

- (void)update
{
    //GLKMatrix4 modelViewMatrix = [playerTransformations getModelViewMatrix];
    [manager update:self.timeSinceLastUpdate];
    
    // update score
    NSString* scoreString = [NSString stringWithFormat:@"SCORE: %i", manager.score.currentScore];
    [self.scoreLabel setText:scoreString];
    
    // update player health
    [self updatePlayerHealth];
    
    // show game over screen when dead
    if (manager.GetPlayerHealth == 0) {
        [self.gameOverView setHidden:false];
        [self.currentScoreLabel setText:[NSString stringWithFormat:@"Current score: %i", manager.score.currentScore]];
        [self.highScoreLabel setText:[NSString stringWithFormat:@"High score: %i", manager.score.highScore]];

    }
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [manager draw]; // ###
}

@end
