//
//  EasyTimeline.h
//  TypeTeacher
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSITechnology. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "EasyTimelineEvent.h"

@class EasyTimeline;

typedef void (^timelineCompletionBlock)(EasyTimeline *timeline);
typedef void (^timelineTickBlock)(NSTimeInterval time, EasyTimeline *timeline);

@protocol EasyTimelineDelegate <NSObject>

@optional

- (void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline;
- (void)finishedTimeLine:(EasyTimeline *)timeline;

@end

@interface EasyTimeline : NSObject
{
	NSTimer *_mainTimer;
	NSTimer *_tickTimer;

	NSTimeInterval _startTime;
	NSTimeInterval _pausedTime;

	NSMutableArray *_events;
	NSMutableArray *_eventTimers;

	NSInteger _loop;
	
	__weak id <EasyTimelineDelegate> _delegate;
}

@property (weak, nonatomic) id <EasyTimelineDelegate> delegate;

#pragma mark Easy Timeline Properties

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL willLoop; // Default to NO
@property (nonatomic, assign) NSTimeInterval tickPeriod; // This is the period (in seconds) in which tickFortimeline: will be called, this can be changed on the fly
@property (nonatomic, readonly) NSArray *events;
@property (nonatomic, copy) timelineCompletionBlock completionBlock;
@property (nonatomic, copy) timelineTickBlock tickBlock;

#pragma mark Easy Timeline Status

@property (nonatomic, readonly) NSTimeInterval currentTime;
@property (nonatomic, readonly) NSInteger currentLoopCount;
@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic, readonly) BOOL hasStarted;

#pragma mark Easy Timeline Controllers

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)skipForwardSeconds:(NSTimeInterval)seconds;

#pragma mark Easy Timeline Events

// Adding or removing events while timeline is running won't work
- (void)addEvent:(EasyTimelineEvent *)event;
- (void)removeEvent:(EasyTimelineEvent *)event;

@end
