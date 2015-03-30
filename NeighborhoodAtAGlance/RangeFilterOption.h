//
//  RangeFilterOption.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "FilterOption.h"

@interface RangeFilterOption : FilterOption
@property NSNumber *minValue;
@property NSNumber *maxValue;
@property NSString *unit;

@property NSNumber *selectedValue;

@end
