//
//  ValueOptionCollectionViewCell.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "ValueOptionCollectionViewCell.h"

@implementation ValueOptionCollectionViewCell

- (void)awakeFromNib {
    [self.label.layer setCornerRadius:5.0f];
    [self.label.layer setBorderWidth:2.0f];
    [self.label.layer setMasksToBounds:YES];
}

@end
