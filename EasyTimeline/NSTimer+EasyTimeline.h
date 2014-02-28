//
//  NSTimer+EasyTimeline.h
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/28/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//
//	Got this from: http://stackoverflow.com/questions/347219/how-can-i-programmatically-pause-an-nstimer

#import <Foundation/Foundation.h>

@interface NSTimer (EasyTimeline)

- (void)pauseOrResume;
- (BOOL)isPaused;

@end
