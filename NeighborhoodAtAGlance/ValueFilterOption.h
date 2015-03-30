//
//  ValueFilterOption.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "FilterOption.h"

@interface ValueFilterOption : FilterOption
@property NSArray *values;
@property NSNumber *selectedValue;
@property NSInteger selectedIndex;
@end
