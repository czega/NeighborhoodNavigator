//
//  OptionTableViewCell.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)disableOption;
- (void)enableOption;

@property NSInteger index;

@end
