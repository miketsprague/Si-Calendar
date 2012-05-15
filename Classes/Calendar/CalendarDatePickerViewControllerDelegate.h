//
//  CalendarDatePickerViewControllerDelegate.h
//  Calendar
//
//  Created by Michael Sprague on 5/11/12.
//  Copyright (c) 2012 Novacoast. All rights reserved.
//

@class CalendarDatePickerViewController;

@protocol CalendarDatePickerViewControllerDelegate

// Called when a range has been selected.
- (void)calendarViewController:(CalendarViewController *)aCalendarViewController startDateSelected:(NSDate *)startDate endDateSelected:(NSDate *)endDate;

@end
