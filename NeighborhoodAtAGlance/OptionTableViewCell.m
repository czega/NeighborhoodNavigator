//
//  OptionTableViewCell.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "OptionTableViewCell.h"

@implementation OptionTableViewCell

- (void)awakeFromNib {
    [self.checkmark addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedCheckmark)]];
    [self.checkmark setUserInteractionEnabled:true];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    FilterOption *option = [[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    if (option.isActive) {
        [self.label setTextColor:kBlueColor];
        [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkBlue"]];
    } else {
        [self.label setTextColor:[UIColor lightGrayColor]];
        [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkGrey"]];
    }
}
- (void)selectedCheckmark {
    FilterOption *option = [[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    if (option.isActive) {
        [self disableOption];
    } else {
        [self enableOption];
    }
}

- (void)enableOption {
    FilterOption *option = (FilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    [option setIsActive:YES];
    
    [self.label setTextColor:kBlueColor];
    [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkBlue"]];
}

- (void)disableOption {
    FilterOption *option = (FilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    [option setIsActive:NO];
    
    [self.label setTextColor:[UIColor lightGrayColor]];
    [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkGrey"]];
}

@end
