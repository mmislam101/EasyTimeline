EasyTimeline
============

Sometimes you need things to happen at specific times and things. 

When it's just an event 2.0 seconds later, a `performSelector:withObject:afterDelay:` is perfect. 

If it gets a little more complex where you need something happening ever 3.0 seconds, a quick implementation of `NSTimer` is good.

But what if you want something to happen every 2.0 seconds and then at 7.0 seconds something else to happen and you want to pause everything for a while and then go on, etc?

That's where **Easy Timeline** comes into play.

###Setup

Init with: 
```smalltalk
EasyTimeline *timeline  = [[EasyTimeline alloc] init]
timeline.duration       = 10.0; // Duration is in seconds. You can even use fractional seconds, warning below
```

####Warning:
This is based on NSTImer which has a tolerance level. The [Apple's documenation](https://www.google.com) states:
>A timer is not a real-time mechanism; it fires only when one of the run loop modes to which the timer has been added is running and able to check if the timer’s firing time has passed. Because of the various input sources a typical run loop manages, the effective resolution of the time interval for a timer is limited to on the order of 50-100 milliseconds. If a timer’s firing time occurs during a long callout or while the run loop is in a mode that is not monitoring the timer, the timer does not fire until the next time the run loop checks the timer. Therefore, the actual time at which the timer fires potentially can be a significant period of time after the scheduled firing time.

###Controls

Easy Timeline is controlled through the following function calls
```smalltalk
[timeline start]; // Starts and re-starts the timer
[timeline stop]; // Stops the timer and resets it
[timeline pause]; // Pauses the timer
[timeline resume]; // Resume after pausing
```

###Completion

Easy Timeline provides the delegate function `(void)finishedTimeLine:(EasyTimeline *)timeline` as well as the block property `timelineCompletionBlock completionBlock` which you can set with a `^void (EasyTimeline *_timeline)` type to execute code when the timeline completes.

```smalltalk

- (void)init
{
...
  EasyTimeline *timeline  = [[EasyTimeline alloc] init]
  timeline.duration       = 10.0;
  
  _timeline.completionBlock = ^void (EasyTimeline *_timeline) {
		NSLog(@"monkey");
	};
...
}

#pragma mark EasyTimelineDelegate

- (void)finishedTimeLine:(EasyTimeline *)timeline
{
	NSLog(@"butt");
}
```

This would produce the logs "monkey" and then "butt"

###Ticks

Settings the `NSTimeInterval tickPeriod` (as long as the period is less than the duration) will allow you to execute code in periodic timer intervals while Easy Timeline is running.

Easy Timeline provides the delegate function `(void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline` as well as the block property `timelineTickBlock tickBlock` which you can set with a `^void (NSTimeInterval time, EasyTimeline *_timeline)` type to execute code when the timeline completes.

```smalltalk

- (void)init
{
...
  EasyTimeline *timeline  = [[EasyTimeline alloc] init]
  timeline.duration       = 10.0;
  timeline.tickPeriod	    = 1.0;
  
	_timeline.tickBlock		= ^void (NSTimeInterval time, EasyTimeline *_timeline) {
		NSLog(@"block tick");
	};
...
}

#pragma mark EasyTimelineDelegate

- (void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline
{
	NSLog(@"delegate tick");
}
```

This would produce the logs "block tick" and then "delegate tick" periodically till the timeline finishes

###Events

Easy Timeline offers you an ability to add blocks of code to execute at a specific time within
