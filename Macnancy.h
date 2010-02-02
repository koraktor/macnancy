/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2010, Sebastian Staudt
 */

#import <Cocoa/Cocoa.h>
#import <Palantir/PalantirPlugin.h>


@interface Macnancy : PalantirPlugin <NSComboBoxDelegate, NSDatePickerCellDelegate> {

    NSMenuItem *daysRemainingMenuItem;
    NSDate     *deliveryDate;
    NSMenuItem *deliveryDateMenuItem;
    NSInteger   lastDateTypeIndex;
    NSDate     *today;

}

- (void)update;

@property (assign) IBOutlet NSDatePicker *datePicker;
@property (assign) IBOutlet NSComboBox   *dateTypeComboBox;
@property (nonatomic, retain) NSMenuItem *daysRemainingMenuItem;
@property (nonatomic, retain) NSDate     *deliveryDate;
@property (nonatomic, retain) NSMenuItem *deliveryDateMenuItem;
@property (nonatomic, retain) NSDate     *today;

@end
