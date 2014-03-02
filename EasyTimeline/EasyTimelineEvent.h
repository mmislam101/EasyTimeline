//
//  EasyTimelineEvents.h
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
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

#import <Foundation/Foundation.h>

@class EasyTimeline;
@class EasyTimelineEvent;

typedef void (^timelineEventBlock)(EasyTimelineEvent *event, EasyTimeline *timeline);

@interface EasyTimelineEvent : NSObject

@property (nonatomic, copy) timelineEventBlock eventBlock;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) BOOL willRepeat; // Default to NO

+ (EasyTimelineEvent *)eventAtTime:(NSTimeInterval)time withEventBlock:(timelineEventBlock)completionBlock;

@end
