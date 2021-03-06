//
//  RangeOptionTableViewCell.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/28/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionTableViewCell.h"

@interface RangeOptionTableViewCell : OptionTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sliderValueChanged:(id)sender;

@end
