//
//  ETViewControllerExample.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExample.h"

@interface ETViewControllerExample ()

@end

@implementation ETViewControllerExample

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline			= [[EasyTimeline alloc] init];
	_timeline.duration	= 1.0;
	_timeline.delegate	= self;

	self.title			= @"Simple 1s test";

    return self;
}

- (void)loadView
{
	[super loadView];

	self.view.backgroundColor		= [UIColor whiteColor];
	CGRect frame					= self.view.frame;

	_startTimeLabel					= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 100.0, frame.size.width, 50.0)];
	_startTimeLabel.font			= [UIFont fontWithName:@"Helvetica" size:24.0];
	_startTimeLabel.textAlignment	= NSTextAlignmentCenter;

	[self.view addSubview:_startTimeLabel];

	_stopTimeLabel					= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 150.0, frame.size.width, 50.0)];
	_stopTimeLabel.font				= [UIFont fontWithName:@"Helvetica" size:24.0];
	_stopTimeLabel.textAlignment	= NSTextAlignmentCenter;

	[self.view addSubview:_stopTimeLabel];

	_tickView						= [[UITextView alloc] initWithFrame:CGRectMake(0.0, 200.0, frame.size.width, frame.size.height - 200.0)];

	[self.view addSubview:_tickView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[_timeline start];

	_startTimeLabel.text		= [NSString stringWithFormat:@"Start: %f", [NSDate timeIntervalSinceReferenceDate]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark EasyTimelineDelegate

- (void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline
{

}

- (void)finishedTimeLine:(EasyTimeline *)timeline
{
	_stopTimeLabel.text = [NSString stringWithFormat:@"Finished: %f", [NSDate timeIntervalSinceReferenceDate]];
}

@end
