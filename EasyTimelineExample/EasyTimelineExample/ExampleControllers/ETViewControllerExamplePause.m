//
//  ETViewControllerExamplePause.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/28/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExamplePause.h"

@interface ETViewControllerExamplePause ()

@end

@implementation ETViewControllerExamplePause

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline				= [[EasyTimeline alloc] init];
	_timeline.duration		= 10.0;
	_timeline.tickPeriod	= 0.5;
	_timeline.delegate		= self;

	[_timeline addEvent:[EasyTimelineEvent eventAtTime:7.0 WithCompletion:^(EasyTimelineEvent *event, EasyTimeline *timeline) {
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"Event fired at %f\n", timeline.currentTime]];
	}]];

	self.title				= @"10s timeline with pause";

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	_tickNumber = 0;
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

	if (++_tickNumber == 5)
	{
		[timeline pause];
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"paused at %f\n for 5 seconds..\n", time]];
		[self performSelector:@selector(resumeTimeLine) withObject:nil afterDelay:5.0];
	}
}

- (void)resumeTimeLine
{
	_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"resuming now\n"]];
	[_timeline resume];
}

@end
