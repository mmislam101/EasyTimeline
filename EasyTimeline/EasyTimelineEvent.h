//
//  EasyTimelineEvents.h
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EasyTimeline;
@class EasyTimelineEvent;

typedef void (^completionBlock)(EasyTimelineEvent *event, EasyTimeline *timeline);

@interface EasyTimelineEvent : NSObject

@property (nonatomic, copy) completionBlock completionBlock;
@property (nonatomic, assign) NSTimeInterval time;

+ (EasyTimelineEvent *)eventAtTime:(NSTimeInterval)time WithCompletion:(completionBlock)completionBlock;

@end
