//
//  ETViewControllerExampleLoopTicks.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExampleLoopTicks.h"

@interface ETViewControllerExampleLoopTicks ()

@end

@implementation ETViewControllerExampleLoopTicks

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline				= [[EasyTimeline alloc] init];
	_timeline.duration		= 5.0;
	_timeline.tickPeriod	= 1.0;
	_timeline.willLoop		= YES;
	_timeline.delegate		= self;

	self.title				= @"5s loop ticking at 1.0s";

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark EasyTimelineDelegate

- (void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline
{
	_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"tick: %f\n", time]];
}

- (void)finishedTimeLine:(EasyTimeline *)timeline
{
	_stopTimeLabel.text = [NSString stringWithFormat:@"Lap: %f", [NSDate timeIntervalSinceReferenceDate]];
}

@end
