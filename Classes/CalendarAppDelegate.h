//
//  CalendarAppDelegate.h
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright Savage Media Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewControllerDelegate.h"
#import "CalendarDatePickerViewControllerDelegate.h"

@interface CalendarAppDelegate : NSObject <UIApplicationDelegate, CalendarViewControllerDelegate, CalendarDatePickerViewControllerDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

