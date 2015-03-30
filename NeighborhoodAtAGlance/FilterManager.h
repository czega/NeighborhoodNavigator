//
//  FilterManager.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterOption.h"
#import "RangeFilterOption.h"
#import "ValueFilterOption.h"

@interface FilterManager : NSObject

+ (id)sharedManager;

- (NSArray*)getFilterOptions;
- (FilterOption*)getFilterOptionForIndex:(NSInteger)index;
- (NSInteger)getFilterOptionsCount;
- (NSString*)getSalesFilterString;
- (NSString*)getRentalsFilterString;

@end
