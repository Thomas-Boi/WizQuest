//
//  ScreenInfo.h
//  WizQuest
//
//  Created by socas on 2021-03-26.
//

#ifndef ScreenInfo_h
#define ScreenInfo_h

// sizes
// width will be changed by Renderer if needed
const int SCREEN_HEIGHT = 16;
extern int SCREEN_WIDTH;

// perspective
const int DEPTH = -13;
const int SCREEN_CENTER_X = 0;
const int SCREEN_CENTER_Y = 0;
const int SCREEN_BOTTOM_Y = SCREEN_CENTER_Y - SCREEN_HEIGHT / 2;
const int SCREEN_TOP_Y = SCREEN_CENTER_Y + SCREEN_HEIGHT / 2;
extern int SCREEN_LEFT_X;
extern int SCREEN_RIGHT_X;

// ortho
// view box top left coord (ortho)
//const int SCREEN_LEFT_X_COORD = 0;
//const int SCREEN_BOTTOM_Y_COORD = 0;

// total depth is 15
//const int EYE_NEAR_COORD = -5;
//const int EYE_FAR_COORD = 10;
//const int DEPTH = 0;

#endif /* ScreenInfo_h */
