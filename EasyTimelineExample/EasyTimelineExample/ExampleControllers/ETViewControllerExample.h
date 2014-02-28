//
//  ETViewControllerExample.h
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/27/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyTimeline.h"

@interface ETViewControllerExample : UIViewController <EasyTimelineDelegate>
{
	EasyTimeline *_timeline;

	UILabel *_startTimeLabel;
	UILabel *_stopTimeLabel;

	UITextView *_tickView;
}

@end
