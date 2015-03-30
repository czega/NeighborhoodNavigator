//
//  RangeOptionTableViewCell.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/28/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionTableViewCell.h"
#import "NMRangeSlider.h"

@interface RangeOptionTableViewCell : OptionTableViewCell
@property (weak, nonatomic) IBOutlet NMRangeSlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *lowerRangeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperRangeValueLabel;

@end
