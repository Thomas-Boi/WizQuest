//
//  Score.m
//  WizQuest
//
//  Created by socas on 2021-04-11.
//

#import "Score.h"

@interface Score()
{
    
}
@end

@implementation Score

@synthesize highScore;
@synthesize currentScore;

- (id) init
{
    if (self = [super init])
    {
        // highScore should be saved and loaded
        highScore = 0;
        currentScore = 0;
    }
    return self;
}

- (void) resetCurrent
{
    currentScore = 0;
}

- (void) addPoints:(int)points
{
    currentScore += points;
    
    if (currentScore > highScore)
        highScore = currentScore;

}


@end
