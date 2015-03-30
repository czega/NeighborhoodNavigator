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
    
    [self.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    RangeFilterOption *option = (RangeFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self.lowerRangeValueLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:option.selectedMinValue]]];
    [self.upperRangeValueLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:option.selectedMaxValue]]];

    CGFloat lowerValuePercentage = (option.selectedMinValue.floatValue-option.minValue.floatValue)/option.maxValue.floatValue;
    [self.slider setLowerValue:lowerValuePercentage];
    
    CGFloat upperValuePercentage = option.selectedMaxValue.floatValue/option.maxValue.floatValue;
    [self.slider setUpperValue:upperValuePercentage];
    
    if (option.isActive) {
        [self.lowerRangeValueLabel setTextColor:kBlueColor];
        [self.upperRangeValueLabel setTextColor:kBlueColor];
        [self.slider setTintColor:kBlueColor];
    } else {
        [self.lowerRangeValueLabel setTextColor:[UIColor lightGrayColor]];
        [self.upperRangeValueLabel setTextColor:[UIColor lightGrayColor]];
        [self.slider setTintColor:[UIColor lightGrayColor]];
    }
    
}

- (void)sliderValueChanged {
    RangeFilterOption *option = (RangeFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    [self.label setTextColor:kBlueColor];
    [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkBlue"]];
    [self.lowerRangeValueLabel setTextColor:kBlueColor];
    [self.upperRangeValueLabel setTextColor:kBlueColor];
    [self.slider setTintColor:kBlueColor];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    int lowerValue = self.slider.lowerValue * (option.maxValue.integerValue - option.minValue.integerValue) + option.minValue.integerValue;
    [self.lowerRangeValueLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:lowerValue]]]];
    
    int upperValue = self.slider.upperValue * option.maxValue.integerValue;
    [self.upperRangeValueLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:upperValue]]]];
    
    [option setIsActive:YES];
    [option setSelectedMinValue:[NSNumber numberWithInt:lowerValue]];
    [option setSelectedMaxValue:[NSNumber numberWithInt:upperValue]];
}

- (void)disableOption {
    [super disableOption];
    [self.lowerRangeValueLabel setTextColor:[UIColor lightGrayColor]];
    [self.upperRangeValueLabel setTextColor:[UIColor lightGrayColor]];
    [self.slider setTintColor:[UIColor lightGrayColor]];
}

- (void)enableOption {
    [super enableOption];
    [self.lowerRangeValueLabel setTextColor:kBlueColor];
    [self.upperRangeValueLabel setTextColor:kBlueColor];
    [self.slider setTintColor:kBlueColor];
}



@end
