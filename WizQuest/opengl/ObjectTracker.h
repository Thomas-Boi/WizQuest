//
//  ObjectTracker.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef ObjectTracker_h
#define ObjectTracker_h

#import "GameObject.h"
#import <Foundation/Foundation.h>


@interface ObjectTracker : NSObject

@property GameObject *player;
@property(readonly) GameObject *platforms;
@property(readonly) GameObject *enemies;

@end

#endif /* ObjectTracker_h */
