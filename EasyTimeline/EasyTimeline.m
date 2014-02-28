//
//  EasyTimeline.m
//  TypeTeacher
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSITechnology. All rights reserved.
//

#import "EasyTimeline.h"

@implementation EasyTimeline

@synthesize
events = _events;

- (id)init
{
	if (!(self = [super init]))
        return self;

	self.willLoop	= NO;
	_events			= [[NSMutableArray alloc] init];
	_startTime		= 0;

    return self;
}

#pragma mark Easy Timeline Controllers

- (void)start
{
	if (_duration <= 0.0)
		return;

	// If starting it again, restart from beginning
	[self stop];

	// Do main timeline timer
	_mainTimer	= [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(finishedTimer:) userInfo:nil repeats:self.willLoop];

	[[NSRunLoop currentRunLoop] addTimer:_mainTimer forMode:NSDefaultRunLoopMode];

	_startTime	= [NSDate timeIntervalSinceReferenceDate];

	// Do tick timer
	if (_tickPeriod > 0.0 && self.tickPeriod <= self.duration)
	{
		_tickTimer	= [NSTimer timerWithTimeInterval:self.tickPeriod target:self selector:@selector(tick:) userInfo:nil repeats:YES];

		[[NSRunLoop currentRunLoop] addTimer:_tickTimer forMode:NSDefaultRunLoopMode];
	}

	// Do timers for events
	if (_events.count > 0)
	{
		_eventTimers = [[NSMutableArray alloc] init];
		for (EasyTimelineEvent *event in _events)
		{
			NSTimer *eventTimer = [NSTimer scheduledTimerWithTimeInterval:event.time
																   target:self
																 selector:@selector(runEvent:)
																 userInfo:event repeats:NO];
			[_eventTimers addObject:eventTimer];
		}
	}
}

- (void)stop
{
	[_mainTimer invalidate];
	[_tickTimer invalidate];

	for (NSTimer *eventTimer in _eventTimers)
		[eventTimer invalidate];

	_mainTimer	= nil;
	_tickTimer	= nil;

	_startTime	= 0;
}

#pragma mark Easy Timeline Events

- (void)addEvent:(EasyTimelineEvent *)event
{
	[_events addObject:event];
}

- (void)removeEvent:(EasyTimelineEvent *)event
{
	[_events removeObject:event];
}

#pragma mark Helper functions

- (void)finishedTimer:(NSTimer *)timer
{
	if (!self.willLoop)
		[self stop];

	if (_delegate && [_delegate respondsToSelector:@selector(finishedTimeLine:)])
		[_delegate finishedTimeLine:self];
}

- (void)tick:(NSTimer *)timer
{
	if (_delegate && [_delegate respondsToSelector:@selector(tickAt:forTimeline:)])
		[_delegate tickAt:[NSDate timeIntervalSinceReferenceDate] - _startTime forTimeline:self];
}

- (void)runEvent:(NSTimer *)timer
{
	EasyTimelineEvent *event = (EasyTimelineEvent *)timer.userInfo;
	
	if (event.completionBlock)
		event.completionBlock(event, self);
}

- (void)setTickPeriod:(NSTimeInterval)tickPeriod
{
	_tickPeriod = tickPeriod;

	if (_tickTimer) // True if timeline is running
	{
		[_tickTimer invalidate];
		_tickTimer	= [NSTimer timerWithTimeInterval:self.tickPeriod target:self selector:@selector(tick:) userInfo:nil repeats:YES];

		[[NSRunLoop currentRunLoop] addTimer:_tickTimer forMode:NSDefaultRunLoopMode];
	}
}

- (NSTimeInterval)currentTime
{
	if (_startTime)
		return [NSDate timeIntervalSinceReferenceDate] - _startTime;
	else
		return 0.0;
}

@end
