//
//  ETViewControllerExampleTick.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExampleTick.h"

@interface ETViewControllerExampleTick ()

@end

@implementation ETViewControllerExampleTick

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline				= [[EasyTimeline alloc] init];
	_timeline.duration		= 5.0;
	_timeline.tickPeriod	= 0.5;
	_timeline.delegate		= self;

	self.title				= @"5s timeline ticking at 0.5s";

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

@end
