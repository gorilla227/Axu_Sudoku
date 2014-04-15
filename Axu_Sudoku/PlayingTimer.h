//
//  PlayingTimer.h
//  SandBox
//
//  Created by Andy on 14-1-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayingTimer : NSObject
@property int stats;//0: Stopped, 1: Started, 2: Paused
@property NSString *timeText;
-(NSNumber *)record;
-(BOOL)startTimer;
-(BOOL)pauseTimer;
-(BOOL)resumeTimer;
-(BOOL)stopTimer;
-(void)timerTick;
@end
