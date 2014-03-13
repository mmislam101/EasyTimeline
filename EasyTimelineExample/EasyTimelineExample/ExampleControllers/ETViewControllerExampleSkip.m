//
//  ETViewControllerExampleSkip.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 3/12/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExampleSkip.h"

@interface ETViewControllerExampleSkip ()

@end

@implementation ETViewControllerExampleSkip

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline				= [[EasyTimeline alloc] init];
	_timeline.duration		= 10.0;
	_timeline.tickPeriod	= 1.0;
	_timeline.delegate		= self;

	[_timeline addEvent:[EasyTimelineEvent eventAtTime:7.0 withEventBlock:^(EasyTimelineEvent *event, EasyTimeline *timeline) {
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"Event fired at %f\n", timeline.currentTime]];
	}]];

	self.title				= @"10s timeline with skip";

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self performSelector:@selector(skipTimeline) withObject:nil afterDelay:3.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipTimeline
{
	_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"Skip ahead by 2 seconds at: %f\n", _timeline.currentTime]];
	[_timeline skipForwardSeconds:2.0];
}

#pragma mark EasyTimelineDelegate

- (void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline
{
	_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"tick: %f\n", time]];
}

@end
