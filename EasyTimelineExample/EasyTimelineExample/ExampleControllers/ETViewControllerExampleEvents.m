//
//  ETViewControllerExampleEvents.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewControllerExampleEvents.h"

@interface ETViewControllerExampleEvents ()

@end

@implementation ETViewControllerExampleEvents

- (id)init
{
   	if (!(self = [super init]))
        return self;

	_timeline				= [[EasyTimeline alloc] init];
	_timeline.duration		= 10.0;
	_timeline.delegate		= self;

	[_timeline addEvent:[EasyTimelineEvent eventAtTime:3.0 withEventBlock:^(EasyTimelineEvent *event, EasyTimeline *timeline) {
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"First event fired at %f\n", timeline.currentTime]];
	}]];

	[_timeline addEvent:[EasyTimelineEvent eventAtTime:7.0 withEventBlock:^(EasyTimelineEvent *event, EasyTimeline *timeline) {
		_tickView.text = [_tickView.text stringByAppendingString:[NSString stringWithFormat:@"Second event fired at %f\n", timeline.currentTime]];
	}]];

	self.title				= @"10s timeline with events";

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

@end
