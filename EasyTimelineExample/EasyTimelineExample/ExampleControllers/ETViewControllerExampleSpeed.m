//
//  ETViewControllerExampleSpeed.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExampleSpeed.h"

@interface ETViewControllerExampleSpeed ()

@end

@implementation ETViewControllerExampleSpeed

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline				= [[EasyTimeline alloc] init];
	_timeline.duration		= 10.0;
	_timeline.tickPeriod	= 1.0;
	_timeline.delegate		= self;

	self.title				= @"10s timeline changing tick period";

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

	if (time > 3.0 && time < 3.5)
	{
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"change tick period to 2.0\n"]];
		timeline.tickPeriod = 2.0;
	}

	if (time > 6.0 && time < 7.1)
	{
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"change ticks period to 0.5\n"]];

		timeline.tickPeriod = 0.5;
	}
}

@end
