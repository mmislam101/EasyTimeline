//
//  EasyTimeline.m
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

#import "EasyTimeline.h"
#import "NSTimer+EasyTimeline.h"

@implementation EasyTimeline

@synthesize
events		= _events;

- (id)init
{
	if (!(self = [super init]))
        return self;

	self.willLoop	= NO;
	_events			= [[NSMutableArray alloc] init];
	_eventTimers	= [[NSMutableArray alloc] init];
	_startTime		= 0;
	_isRunning		= NO;
	_loop			= 0;
	_hasStarted		= NO;

    return self;
}

#pragma mark Easy Timeline Controllers

- (void)start
{
	if (_duration <= 0.0)
		return;

	// If starting it again, restart from beginning
	[self stop];

	_isRunning	= YES;

	// Do main timeline timer
	_mainTimer	= [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(finishedTimer:) userInfo:nil repeats:self.willLoop];

	[[NSRunLoop currentRunLoop] addTimer:_mainTimer forMode:NSDefaultRunLoopMode];

	_startTime	= [NSDate timeIntervalSinceReferenceDate];

	// Do tick timer
	if (self.tickPeriod > 0.0 && (self.tickPeriod <= self.duration || self.willLoop))
	{
		_tickTimer	= [NSTimer timerWithTimeInterval:self.tickPeriod target:self selector:@selector(tick:) userInfo:nil repeats:YES];

		[[NSRunLoop currentRunLoop] addTimer:_tickTimer forMode:NSDefaultRunLoopMode];
	}

	// Do timers for events
	if (_events.count > 0)
	{
		for (EasyTimelineEvent *event in _events)
		{
			if (event.time > 0.0 && (event.time <= self.duration || self.willLoop))
			{
				NSTimer *eventTimer = [NSTimer scheduledTimerWithTimeInterval:event.time
																	   target:self
																	 selector:@selector(runEvent:)
																	 userInfo:event repeats:event.willRepeat];
				[_eventTimers addObject:eventTimer];
			}
		}
	}

	_hasStarted = YES;
}

- (void)pause
{
	if (!_isRunning && _startTime > 0)
		return;

	_isRunning	= NO;

	[_mainTimer pauseOrResume];
	[_tickTimer pauseOrResume];

	[_eventTimers enumerateObjectsUsingBlock:^(NSTimer *eventTimer, NSUInteger idx, BOOL *stop) {
		[eventTimer pauseOrResume];
	}];

	_pausedTime	= [NSDate timeIntervalSinceReferenceDate];
}

- (void)resume
{
	if (_isRunning)
		return;

	_isRunning	= YES;
	_startTime	= _startTime + ([NSDate timeIntervalSinceReferenceDate] - _pausedTime);
	_pausedTime	= 0;

	[_mainTimer pauseOrResume];
	[_tickTimer pauseOrResume];

	[_eventTimers enumerateObjectsUsingBlock:^(NSTimer *eventTimer, NSUInteger idx, BOOL *stop) {
		[eventTimer pauseOrResume];
	}];
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
	_pausedTime	= 0;
	_isRunning	= NO;
	_loop		= 0;
	_hasStarted	= NO;
}

- (void)skipForwardSeconds:(NSTimeInterval)seconds
{
	// Don't skip before you start
	if (_startTime <= 0.0)
		return;

	// If you're skipping past the end of the timeline, finish the timeline
	if (!self.willLoop && (_mainTimer.oldFireDate.timeIntervalSinceReferenceDate - [NSDate timeIntervalSinceReferenceDate] <= seconds))
	{
		NSLog(@"b");
		[self stop];

		if (self.completionBlock)
			self.completionBlock(self);

		if (_delegate && [_delegate respondsToSelector:@selector(finishedTimeLine:)])
			[_delegate finishedTimeLine:self];

		return;
	}

	// Stop all the other timers and save the fire date
	NSDate *mainFireDate			= _mainTimer.oldFireDate;
	[_mainTimer invalidate];

	NSDate *tickFireDate			= _tickTimer.oldFireDate;
	[_tickTimer invalidate];

	__block NSMutableArray *eventFireDate	= [[NSMutableArray alloc] init];
	[_eventTimers enumerateObjectsUsingBlock:^(NSTimer *eventTimer, NSUInteger idx, BOOL *stop) {
		[eventFireDate addObject:eventTimer.oldFireDate];
		[eventTimer invalidate];
	}];

	// Reset all timers with a shorter first fire date
	// Do main timeline timer
	_mainTimer			= [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(finishedTimer:) userInfo:nil repeats:self.willLoop];
	_mainTimer.fireDate	= [mainFireDate dateByAddingTimeInterval:-seconds];

	[[NSRunLoop currentRunLoop] addTimer:_mainTimer forMode:NSDefaultRunLoopMode];

	if (_pausedTime > 0.0)
		[_mainTimer pauseOrResume];

	// Do tick timer
	NSDate *newTickFireDate = [tickFireDate dateByAddingTimeInterval:-seconds];
	if (self.tickPeriod > 0.0)// && (self.tickPeriod <= self.duration || self.willLoop))
	{
		_tickTimer			= [NSTimer timerWithTimeInterval:self.tickPeriod target:self selector:@selector(tick:) userInfo:nil repeats:YES];
		_tickTimer.fireDate	= newTickFireDate;

		[[NSRunLoop currentRunLoop] addTimer:_tickTimer forMode:NSDefaultRunLoopMode];

		if (_pausedTime > 0.0)
			[_tickTimer pauseOrResume];
	}

	// Do timers for events
	if (_events.count > 0)
	{
		NSInteger idx	= 0;
		_eventTimers	= [[NSMutableArray alloc] init];
		for (EasyTimelineEvent *event in _events)
		{
			if (event.time > 0.0)// && (event.time <= self.duration || self.willLoop))
			{
				NSTimer *eventTimer = [NSTimer scheduledTimerWithTimeInterval:event.time
																	   target:self
																	 selector:@selector(runEvent:)
																	 userInfo:event repeats:event.willRepeat];
				eventTimer.fireDate	= [eventFireDate[idx++] dateByAddingTimeInterval:-seconds];
				[_eventTimers addObject:eventTimer];

				if (_pausedTime > 0.0)
					[eventTimer pauseOrResume];
			}
		}
	}

	_startTime -= seconds;
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

#pragma mark Status

- (NSTimeInterval)currentTime
{
	if (_startTime)
		return (_pausedTime > 0.0 ? _pausedTime :[NSDate timeIntervalSinceReferenceDate]) - _startTime;
	else
		return 0.0;
}

- (NSInteger)currentLoopCount
{
	return _loop;
}

#pragma mark Helper functions

- (void)finishedTimer:(NSTimer *)timer
{
	if (!self.willLoop)
		[self stop];

	if (self.completionBlock)
		self.completionBlock(self);

	if (_delegate && [_delegate respondsToSelector:@selector(finishedTimeLine:)])
		[_delegate finishedTimeLine:self];

	_loop++;
}

- (void)tick:(NSTimer *)timer
{
	NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - _startTime;
	
	if (self.tickBlock)
		self.tickBlock(time, self);

	if (_delegate && [_delegate respondsToSelector:@selector(tickAt:forTimeline:)])
		[_delegate tickAt:time forTimeline:self];
}

- (void)runEvent:(NSTimer *)timer
{
	EasyTimelineEvent *event = (EasyTimelineEvent *)timer.userInfo;
	
	if (event.eventBlock)
		event.eventBlock(event, self);
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

@end
