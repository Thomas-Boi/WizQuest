//
//  StartViewController.m
//  WizQuest
//
//  Created by Sebastian Bejm on 2021-04-20.
//

#import "StartViewController.h"

@interface StartViewController () {
    Score *score;
}

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    score = [[Score alloc] init];
    
    [self.highScoreLabel setText:[NSString stringWithFormat:@"High Score: %i", score.highScore]];
}



@end
