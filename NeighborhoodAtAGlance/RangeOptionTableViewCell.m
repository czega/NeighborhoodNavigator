//
//  RangeOptionTableViewCell.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/28/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "RangeOptionTableViewCell.h"
#import "RangeFilterOption.h"

@implementation RangeOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    RangeFilterOption *option = (RangeFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self.valueLabel setText:[NSString stringWithFormat:@"%@ %@",option.selectedValue,option.unit]];
    
    CGFloat percentage = (option.selectedValue.floatValue - option.minValue.floatValue)/option.maxValue.floatValue;
    [self.slider setValue:percentage];
    
    if (option.isActive) {
        [self.valueLabel setTextColor:kBlueColor];
        [self.slider setTintColor:kBlueColor];
    } else {
        [self.valueLabel setTextColor:[UIColor lightGrayColor]];
        [self.slider setTintColor:[UIColor lightGrayColor]];
    }
    
}

- (void)sliderValueChanged {
    RangeFilterOption *option = (RangeFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    



//    int lowerValue = self.slider.lowerValue * (option.maxValue.integerValue - option.minValue.integerValue) + option.minValue.integerValue;
//   // [self.lowerRangeValueLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:lowerValue]]]];
//    
//    int upperValue = self.slider.upperValue * option.maxValue.integerValue;
//    [self.upperRangeValueLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:upperValue]]]];
//    
//    [option setSelectedMinValue:[NSNumber numberWithInt:lowerValue]];
//    [option setSelectedMaxValue:[NSNumber numberWithInt:upperValue]];
}

- (void)disableOption {
    [super disableOption];
    [self.valueLabel setTextColor:[UIColor lightGrayColor]];
    [self.slider setTintColor:[UIColor lightGrayColor]];
}

- (void)enableOption {
    [super enableOption];
    [self.valueLabel setTextColor:kBlueColor];
    [self.slider setTintColor:kBlueColor];
}

- (IBAction)sliderValueChanged:(id)sender {
    RangeFilterOption *option = (RangeFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    int value = (self.slider.value * (option.maxValue.integerValue - option.minValue.integerValue)) + option.minValue.integerValue;
    [option setSelectedValue:[NSNumber numberWithInt:value]];

    [self.valueLabel setText:[NSString stringWithFormat:@"%@ %@",[formatter stringFromNumber:option.selectedValue],option.unit]];
    
    [self.label setTextColor:kBlueColor];
    [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkBlue"]];
    [self.valueLabel setTextColor:kBlueColor];
    [self.slider setTintColor:kBlueColor];
    
    [option setIsActive:YES];

}
@end
