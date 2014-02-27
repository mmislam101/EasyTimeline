//
//  EasyTimeline.m
//  TypeTeacher
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSITechnology. All rights reserved.
//

#import "EasyTimeline.h"

@implementation EasyTimeline

- (id)init
{
	if (!(self = [super init]))
        return self;

	self.willLoop	= NO;
	self.speed		= 1;

    return self;
}

@end
