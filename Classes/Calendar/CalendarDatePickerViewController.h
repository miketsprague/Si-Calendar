//
//  CalendarDatePickerViewController.h
//  Calendar
//
//  Created by Michael Sprague on 5/11/12.
//  Copyright (c) 2012 Novacoast. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarDatePickerViewControllerDelegate.h"
@interface CalendarDatePickerViewController : CalendarViewController {

}

@property (nonatomic, retain) id <CalendarDatePickerViewControllerDelegate> calendarViewDatePickerControllerDelegate;
@property (nonatomic, retain) NSDate *start_date;
@property (nonatomic, retain) NSDate *end_date;

-(void)done;

@end
