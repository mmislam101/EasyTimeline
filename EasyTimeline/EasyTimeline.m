//
//  EasyTimeline.m
//  TypeTeacher
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSITechnology. All rights reserved.
//

#import "EasyTimeline.h"

@implementation EasyTimeline

- (id)init
{
	if (!(self = [super init]))
        return self;

	self.willLoop	= NO;

    return self;
}

#pragma mark Easy Timeline Controllers

- (void)start
{
	if (_duration <= 0.0)
		return;

	_mainTimer	= [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(finishedTimer:) userInfo:nil repeats:self.willLoop];

	[[NSRunLoop currentRunLoop] addTimer:_mainTimer forMode:NSDefaultRunLoopMode];

	_startTime	= [NSDate timeIntervalSinceReferenceDate];

	if (_tickPeriod <= 0.0 || self.tickPeriod > self.duration)
		return;

	_tickTimer	= [NSTimer timerWithTimeInterval:self.tickPeriod target:self selector:@selector(tick:) userInfo:nil repeats:YES];

	[[NSRunLoop currentRunLoop] addTimer:_tickTimer forMode:NSDefaultRunLoopMode];
}

- (void)pause
{

}

- (void)stop
{
	[_mainTimer invalidate];
	[_tickTimer invalidate];

	_mainTimer = nil;
	_tickTimer = nil;
}

- (void)finishedTimer:(NSTimer *)timer
{
	if (!self.willLoop)
	{
		[_tickTimer invalidate];
		_tickTimer = nil;
	}

	if (_delegate && [_delegate respondsToSelector:@selector(finishedTimeLine:)])
		[_delegate finishedTimeLine:self];
}

- (void)tick:(NSTimer *)timer
{
	if (_delegate && [_delegate respondsToSelector:@selector(tickAt:forTimeline:)])
		[_delegate tickAt:[NSDate timeIntervalSinceReferenceDate] - _startTime forTimeline:self];
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
