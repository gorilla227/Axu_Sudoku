//
//  PlayingTimer.m
//  SandBox
//
//  Created by Andy on 14-1-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "PlayingTimer.h"

@implementation PlayingTimer{
	int hr, min, sec;
	NSTimer *timer;
}
@synthesize stats;
@synthesize timeText;
-(id)init
{
	self = [super init];
	if(self)
	{
		hr = 0;
		min = 0;
		sec = 0;
		stats = 0;
	}
	return self;
}

-(NSNumber *)record
{
    return [NSNumber numberWithInt:(hr * 3600 + min * 60 + sec)];
}

-(BOOL)startTimer
{
	if(stats == 0)
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate distantPast]];
		stats = 1;
        [self setTimeText:@""];
		return YES;
	}
	return NO;
}

-(BOOL)pauseTimer
{
	if(stats == 1)
	{
		[timer setFireDate:[NSDate distantFuture]];
		stats = 2;
		return YES;
	}
	return NO;
}

-(BOOL)resumeTimer
{
	if(stats == 2)
	{
		[timer setFireDate:[NSDate distantPast]];
		stats = 1;
		return YES;
	}
	return NO;
}

-(BOOL)stopTimer
{
	if(stats !=0)
	{
		[timer invalidate];
        hr = 0;
		min = 0;
		sec = 0;
		stats = 0;
        [self setTimeText:@""];
		return YES;
	}
	return NO;
}

-(void)timerTick
{
	sec++;
	if(sec == 60)
	{
		sec = 0;
		min++;
		if(min == 60)
		{
			min = 0;
			hr++;
		}
	}
    
    NSString *hour = [[NSString alloc] initWithFormat:@"%i", hr];
	NSString *minute = [[NSString alloc] initWithFormat:@"%i", min];
	NSString *second = [[NSString alloc] initWithFormat:@"%i", sec];
	if (min < 10)
	{
		minute = [NSString stringWithFormat:@"0%@", minute];
	}
	if (sec < 10)
	{
		second = [NSString stringWithFormat:@"0%@", second];
	}
	[self setTimeText:[NSString stringWithFormat:@"%@:%@:%@", hour, minute, second]];
}
@end
