//
//  Score.h
//  WizQuest
//
//  Created by socas on 2021-04-11.
//

#ifndef Score_h
#define Score_h

#import <Foundation/Foundation.h>

@interface Score : NSObject
@property (readonly) int highScore;
@property (readonly) int currentScore;

- (void) resetCurrent;
- (void) addPoints:(int) points;

@end

#endif /* Score_h */
