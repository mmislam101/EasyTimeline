//
//  NSTimer+EasyTimeline.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/28/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "NSTimer+EasyTimeline.h"
#import <objc/runtime.h>

@interface NSTimer (EasyTimelinePrivate)

@property (nonatomic) NSNumber *timeDeltaNumber;

@end

@implementation NSTimer (EasyTimelinePrivate)

static void *AssociationKey;

- (NSNumber *)timeDeltaNumber
{
    return objc_getAssociatedObject(self, AssociationKey);
}

- (void)setTimeDeltaNumber:(NSNumber *)timeDeltaNumber
{
    objc_setAssociatedObject(self, AssociationKey, timeDeltaNumber, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation NSTimer (EasyTimeline)

- (void)pauseOrResume
{
    if ([self isPaused])
	{
        self.fireDate			= [[NSDate date] dateByAddingTimeInterval:self.timeDeltaNumber.doubleValue];
        self.timeDeltaNumber	= nil;
    }
    else
	{
        NSTimeInterval interval = [[self fireDate] timeIntervalSinceNow];
        self.timeDeltaNumber	= @(interval);
        self.fireDate			= [NSDate distantFuture];
    }
}

- (BOOL)isPaused
{
    return (self.timeDeltaNumber != nil);
}


@end
