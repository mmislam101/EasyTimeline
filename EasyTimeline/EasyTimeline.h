//
//  EasyTimeline.h
//  TypeTeacher
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSITechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EasyTimeline;

@protocol EasyTimelineDelegate <NSObject>

@optional

- (void)tickAt:(CGFloat)time forTimeline:(EasyTimeline *)timeline;
- (void)finishedTimeLine:(EasyTimeline *)timeline;

@end

@interface EasyTimeline : NSObject

#pragma mark Easy Timeline Properties

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL willLoop; // Default to NO
@property (nonatomic, assign) CGFloat tickPeriod; // This is the period (in seconds) in which tickFortimeline: will be called
@property (nonatomic, assign) NSInteger speed; // speed is the x times the timeline will run at, default is 1

#pragma mark Easy Timeline Controllers

- (void)start;
- (void)pause;
- (void)reset;

@end
