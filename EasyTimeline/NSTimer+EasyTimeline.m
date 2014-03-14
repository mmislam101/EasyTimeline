//
//  NSTimer+EasyTimeline.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/28/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
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

#import "NSTimer+EasyTimeline.h"
#import <objc/runtime.h>

static void *AssociationKey;
static void *OldFireDateKey;

@interface NSTimer (EasyTimelinePrivate)

@property (nonatomic) NSNumber *timeDeltaNumber;

@end

@implementation NSTimer (EasyTimelinePrivate)

- (NSNumber *)timeDeltaNumber
{
    return objc_getAssociatedObject(self, &AssociationKey);
}

- (void)setTimeDeltaNumber:(NSNumber *)timeDeltaNumber
{
    objc_setAssociatedObject(self, &AssociationKey, timeDeltaNumber, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation NSTimer (EasyTimeline)

- (void)pauseOrResume
{
    if ([self isPaused])
	{
        self.fireDate			= [[NSDate date] dateByAddingTimeInterval:self.timeDeltaNumber.doubleValue];
        self.timeDeltaNumber	= nil;
		self.oldFireDate		= nil;
    }
    else
	{
        self.timeDeltaNumber	= @(self.fireDate.timeIntervalSinceNow);
		self.oldFireDate		= self.fireDate;
        self.fireDate			= [NSDate distantFuture];
    }
}

- (BOOL)isPaused
{
    return (self.timeDeltaNumber != nil);
}

- (void)setOldFireDate:(NSDate *)oldFireDate
{
	objc_setAssociatedObject(self, &OldFireDateKey, oldFireDate, OBJC_ASSOCIATION_RETAIN);
}

- (NSDate *)oldFireDate
{
	NSDate *oldFireDate = objc_getAssociatedObject(self, &OldFireDateKey);

	if (oldFireDate)
		return oldFireDate;

	return self.fireDate;
}

@end
