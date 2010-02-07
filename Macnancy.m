/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2010, Sebastian Staudt
 */

#import "Macnancy.h"

#define DIFFERENCE_LAST_PERIOD 24192000
#define DIFFERENCE_CONCEPTION_DATE 22982400


@implementation Macnancy

@synthesize datePicker, dateTypeComboBox, daysRemainingMenuItem, deliveryDate,
            deliveryDateMenuItem, today;

- (void)awakeFromNib {
    self.daysRemainingMenuItem = [NSMenuItem new];
    self.deliveryDateMenuItem  = [NSMenuItem new];

    [self.dateTypeComboBox selectItemAtIndex:0];
    lastDateTypeIndex = 0;
    self.deliveryDate = [self settingWithName:@"deliveryDate"];
    [self.datePicker setDateValue:self.deliveryDate];

    [super awakeFromNib];
    [self action];

    [self.menu addItem:self.daysRemainingMenuItem];
    [self.menu addItem:self.deliveryDateMenuItem];
}

- (void)action {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *newToday = [gregorianCalendar dateFromComponents:components];

    if(![newToday isEqualToDate:self.today]) {
        self.today = newToday;
        [self update];
    }
}

- (NSTimeInterval)actionInterval {
    return 60;
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    switch([self.dateTypeComboBox indexOfSelectedItem]) {
        case 0:
            [self.datePicker setDateValue:self.deliveryDate];
            break;
        case 1:
            [self.datePicker setDateValue:[self.deliveryDate dateByAddingTimeInterval:-DIFFERENCE_CONCEPTION_DATE]];
            break;
        case 2:
            [self.datePicker setDateValue:[self.deliveryDate dateByAddingTimeInterval:-DIFFERENCE_LAST_PERIOD]];
            break;
    }

    lastDateTypeIndex = [self.dateTypeComboBox indexOfSelectedItem];
}

- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate **)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval {
    NSDate *aDate;

    switch([self.dateTypeComboBox indexOfSelectedItem]) {
        case 0:
            if([*proposedDateValue compare:self.today] < 0) {
                *proposedDateValue = self.today;
            }
            aDate = *proposedDateValue; 
            break;
        case 1:
            if([*proposedDateValue compare:[self.today dateByAddingTimeInterval:-DIFFERENCE_CONCEPTION_DATE]] < 0) {
                *proposedDateValue = self.today;
            }
            aDate = [*proposedDateValue dateByAddingTimeInterval:DIFFERENCE_CONCEPTION_DATE];
            break;
        case 2:
            if([*proposedDateValue compare:[self.today dateByAddingTimeInterval:-DIFFERENCE_LAST_PERIOD]] < 0) {
                *proposedDateValue = self.today;
            }
            aDate = [*proposedDateValue dateByAddingTimeInterval:DIFFERENCE_LAST_PERIOD];
            break;
    }

    self.deliveryDate = aDate;
    [self setSettingWithName:@"deliveryDate" toValue:aDate];

    [self update];
}

- (void)setDeliveryDate:(NSDate *)aDate {
    deliveryDate = aDate;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *deliveryDateString = [dateFormatter stringFromDate:self.deliveryDate];

    [self.deliveryDateMenuItem setTitle:[NSString stringWithFormat:[self.bundle localizedStringForKey:@"delivery date" value:@"Delivery date: %@" table:@"Macnancy"], deliveryDateString]];
}

- (void)update {
    int pregnantSince = round((DIFFERENCE_LAST_PERIOD - [self.deliveryDate timeIntervalSinceDate:self.today]) / 86400);
    [self.daysRemainingMenuItem setTitle:[NSString stringWithFormat:[self.bundle localizedStringForKey:@"days remaining" value:@"%d days remaining..." table:@"Macnancy"], 280 - pregnantSince]];
    [self.statusItem setTitle:[NSString stringWithFormat:@"%d+%d", (pregnantSince / 7), (pregnantSince % 7)]];
}

@end
