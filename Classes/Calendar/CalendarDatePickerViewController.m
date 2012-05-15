//
//  CalendarDatePickerViewController.m
//  Calendar
//
//  Created by Michael Sprague on 5/11/12.
//  Copyright (c) 2012 Novacoast. All rights reserved.
//

#import "CalendarDatePickerViewController.h"

@implementation CalendarDatePickerViewController

@synthesize calendarViewDatePickerControllerDelegate;
@synthesize start_date = _start_date;
@synthesize end_date = _end_date;

#pragma mark -
#pragma mark Controller initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _start_date = nil;
        _end_date = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    self.start_date = nil;
    self.end_date = nil;
    self.calendarViewDatePickerControllerDelegate = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View delegate
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -
#pragma mark CalendarLogic delegate
- (void)calendarLogic:(CalendarLogic *)aLogic dateSelected:(NSDate *)aDate
{
    // Sorry, this is a little confusing.
    // We want to delay the call to update the calendar if it involves selecting a new month.
    // Otherwise our date selection will go away when the new view has been made
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aDate forKey:@"date"];
    [NSTimer scheduledTimerWithTimeInterval:0.14 target:self
                                   selector:@selector(timerDateRnageSelected:) 
                                   userInfo:userInfo repeats:NO];
    
    
}
- (void)calendarLogic:(CalendarLogic *)aLogic monthChangeDirection:(NSInteger)aDirection{
    [super calendarLogic:aLogic monthChangeDirection:aDirection];
    NSLog(@"change direction");
}

-(void)timerDateRnageSelected:(NSTimer *)timer{
    NSDate *aDate = (NSDate *)[timer.userInfo objectForKey:@"date"];
    
    BOOL deselect = NO;
    
    if(self.start_date == nil){
        self.start_date = aDate;
    } else if(self.end_date == nil){
        self.end_date = aDate;
    } else { // reset it then
        [self.calendarView deselectButtonForDate:self.start_date];
        [self.calendarView deselectButtonForDate:self.end_date];
        deselect = YES;
    }
    
    // If there's a start date and an end date, either select the range or deselect it (if it's already selected)
    if(self.start_date != nil && self.end_date != nil){
        // if start date > end date, swap them.
        if([self.start_date compare:self.end_date] > 0){
            NSDate *tmp = [self.start_date copy];
            self.start_date = self.end_date;
            self.end_date = tmp;
            [tmp release];
        }
        
        [self selectDateRange:self.start_date toDate:self.end_date deselect:deselect];
        
    }
    // if we were deselecting, make sure to reset the start and end dates.
    if(deselect){
        self.start_date = aDate;
        self.end_date = nil;
    }
    
    
    [self.calendarView selectButtonForDate:aDate];
	[calendarViewControllerDelegate calendarViewController:self dateDidChange:aDate];
    
    NSLog(@"date selected %i", [calendarView.calendarLogic indexOfCalendarDate:self.start_date]);
}


-(void)selectDateRange:(NSDate *)start_date toDate:(NSDate *)end_date deselect:(BOOL)deselect
{
    NSInteger start_index = [self.calendarView.datesIndex indexOfObject:self.start_date];
    NSInteger end_index = [self.calendarView.datesIndex indexOfObject:self.end_date];
    
    // ugh this is gross.  Get the start, end, and current months.
    NSDate *ref_date = self.calendarView.calendarLogic.referenceDate;
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) fromDate:self.start_date];
    NSInteger start_month = [dateComponents month];
    dateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) fromDate:self.end_date];
    NSInteger end_month = [dateComponents month];
    dateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) fromDate:ref_date];
    NSInteger current_month = [dateComponents month];
    
    [dateComponents setDay:[calendar rangeOfUnit:NSDayCalendarUnit
                                          inUnit:NSMonthCalendarUnit
                                         forDate:ref_date].length];
    NSDate *lastDayInMonth = [calendar dateFromComponents:dateComponents];
    //dateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) fromDate:lastDayInMonth];
    NSInteger last_day = [self.calendarView.datesIndex indexOfObject:lastDayInMonth];
    [dateComponents setDay:0];
    NSDate *firstDayInMonth = [calendar dateFromComponents:dateComponents];
    NSInteger first_day = [self.calendarView.datesIndex indexOfObject:firstDayInMonth];
    [calendar release];
    
    if(start_month < current_month){
        start_index = first_day+1;
        
    }
    if(end_month > current_month){
        end_index = last_day;
    }
    
    // loop through all of the buttons in the range of start_index to end_index 
    // either select or deselect them depending on our current state.
    // Note: this takes advantage of "fast enumeration" 
    for(UIButton *button in self.calendarView.buttonsIndex){
        NSInteger index = [self.calendarView.buttonsIndex indexOfObject:button];
        if((index >= start_index && index <= end_index)){
            if(!deselect) {
                NSDate *date = [calendarView.datesIndex objectAtIndex:index];
                NSLog(@"DDDAAAATE %@ for index %i", date, index);
                [self.calendarView selectButtonForDate:date];
            }
            else {
                [self.calendarView deselectButtonForDate:[calendarView.datesIndex objectAtIndex:index]];
            }
        }
    }
}


-(void)done{
    [self.calendarViewDatePickerControllerDelegate calendarViewController:self startDateSelected:self.start_date endDateSelected:self.end_date];
}

@end
