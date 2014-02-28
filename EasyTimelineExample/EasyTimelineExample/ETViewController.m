//
//  ETViewController.m
//  EasyTimelineExample
//
//  Created by Mohammed Islam on 2/26/14.
//  Copyright (c) 2014 KSI Technology. All rights reserved.
//

#import "ETViewController.h"
#import "ETViewControllerExample.h"
#import "ETViewControllerExampleTick.h"
#import "ETViewControllerExampleLoopTicks.h"
#import "ETViewControllerExampleSpeed.h"
#import "ETViewControllerExampleEvents.h"

#define tableCellReuse @"tableCellReuse"

@interface ETViewController ()

@end

@implementation ETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)loadView
{
	[super loadView];

    UITableView *tableView		= [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource		= self;
    tableView.delegate			= self;
	tableView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellReuse];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellReuse];
    }

	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"Simple 1s test";
			break;

		case 1:
			cell.textLabel.text = @"5s timeline ticking at 0.5s";
			break;

		case 2:
			cell.textLabel.text = @"5s loop ticking at 1.0s";
			break;

		case 3:
			cell.textLabel.text = @"10s timeline changing tick period";
			break;

		case 4:
			cell.textLabel.text	= @"10s timeline with events";

		default:
			break;
	}

    return cell;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	switch (indexPath.row)
	{
		case 0:
			[self.navigationController pushViewController:[[ETViewControllerExample alloc] init] animated:YES];
			break;

		case 1:
			[self.navigationController pushViewController:[[ETViewControllerExampleTick alloc] init] animated:YES];
			break;

		case 2:
			[self.navigationController pushViewController:[[ETViewControllerExampleLoopTicks alloc] init] animated:YES];
			break;

		case 3:
			[self.navigationController pushViewController:[[ETViewControllerExampleSpeed alloc] init] animated:YES];
			break;

		case 4:
			[self.navigationController pushViewController:[[ETViewControllerExampleEvents alloc] init] animated:YES];
			break;

		default:
			break;
	}
}


@end
