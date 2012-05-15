//
//  CalendarAppDelegate.m
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright Savage Media Pty Ltd 2010. All rights reserved.
//

#import "CalendarAppDelegate.h"
#import "CalendarViewController.h"
#import "CalendarDatePickerViewController.h"

@implementation CalendarAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	UINavigationController *navigation = [[UINavigationController alloc] init];
	CalendarDatePickerViewController *controller = [[CalendarDatePickerViewController alloc] init];
	[navigation pushViewController:controller animated:NO];
	[controller setCalendarViewControllerDelegate:self];
    [controller setCalendarViewDatePickerControllerDelegate:self];
	
    // Override point for customization after app launch    
    [window addSubview:navigation.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)calendarViewController:(CalendarViewController *)aCalendarViewController dateDidChange:(NSDate *)aDate {
	NSLog(@"Date set to: %@", aDate);
}

// Called when a range has been selected.
- (void)calendarViewController:(CalendarViewController *)aCalendarViewController startDateSelected:(NSDate *)startDate endDateSelected:(NSDate *)endDate {
    NSLog(@"Date range selected %@ to %@", startDate, endDate);
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
