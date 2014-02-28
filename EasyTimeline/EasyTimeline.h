//
//  EasyTimeline.h
//  TypeTeacher
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSITechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyTimelineEvent.h"

@class EasyTimeline;

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

	NSMutableArray *_events;
	NSMutableArray *_eventTimers;
	
	__weak id <EasyTimelineDelegate> _delegate;
}

@property (weak, nonatomic) id <EasyTimelineDelegate> delegate;

#pragma mark Easy Timeline Properties

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL willLoop; // Default to NO
@property (nonatomic, assign) NSTimeInterval tickPeriod; // This is the period (in seconds) in which tickFortimeline: will be called, this can be changed on the fly
@property (nonatomic, readonly) NSArray *events;
@property (nonatomic, readonly) NSTimeInterval currentTime;

#pragma mark Easy Timeline Controllers

- (void)start;
- (void)pause;
- (void)stop;

#pragma mark Easy Timeline Events

// Adding or removing events while timeline is running won't work
- (void)addEvent:(EasyTimelineEvent *)event;
- (void)removeEvent:(EasyTimelineEvent *)event;

@end
