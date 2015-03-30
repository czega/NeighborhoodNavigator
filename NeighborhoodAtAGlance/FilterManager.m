//
//  FilterManager.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "FilterManager.h"

@interface FilterManager()
@property NSMutableArray *options;
@end

@implementation FilterManager

+ (id)sharedManager {
    static FilterManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        self.options = [[NSMutableArray alloc]init];
        
        NSArray * filterOptions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Filters" ofType:@"plist"]];
        
        for (NSDictionary *dict in filterOptions) {
            if ([dict[@"type"] isEqualToString:@"VALUE"]) {
                ValueFilterOption *option = [[ValueFilterOption alloc]init];
                [option setName:dict[@"name"]];
                [option setIsActive:NO];
                [option setKey:dict[@"key"]];

                NSMutableArray *values = [[NSMutableArray alloc] init];
                for (NSNumber *value in dict[@"values"]) {
                    [values addObject:value];
                }
                [option setValues:values];
                [option setSelectedIndex:0];
                
                [self.options addObject:option];
            } else if ([dict[@"type"] isEqualToString:@"RANGE"]) {
                RangeFilterOption *option = [[RangeFilterOption alloc] init];
                
                [option setName:dict[@"name"]];
                [option setIsActive:NO];
                [option setKey:dict[@"key"]];
                [option setMinValue:dict[@"minValue"]];
                [option setMaxValue:dict[@"maxValue"]];
                [option setSelectedMinValue:dict[@ "minValue"]];
                [option setSelectedMaxValue:dict[@"maxValue"]];
                
                [self.options addObject:option];
            }
        }
    }
    return self;
}

- (NSArray*)getFilterOptions {
    return self.options.copy;
}

- (FilterOption*)getFilterOptionForIndex:(NSInteger)index {
    return [self.options objectAtIndex:index];
}

- (NSInteger)getFilterOptionsCount {
    return self.options.count;
}

// With current filter options, filtering between sales and rentals is the same
- (NSString*)getRentalsFilterString {
    return [self getFilterString];
}

- (NSString*)getSalesFilterString {
    return [self getFilterString];
}

- (NSString*)getFilterString {
    NSMutableString *filterString = [[NSMutableString alloc] init];
    
    for (FilterOption *option in self.options) {
        if (option.isActive) {
            if ([option isKindOfClass:[ValueFilterOption class]]) {
                ValueFilterOption *valueOption = (ValueFilterOption*)option;
                NSNumber *value = valueOption.values[valueOption.selectedIndex];
                [filterString appendFormat:@"|%@=%@",valueOption.key,value];
            } else if ([option isKindOfClass:[RangeFilterOption class]]) {
                RangeFilterOption *rangeOption = (RangeFilterOption*)option;
                [filterString appendFormat:@"|%@=%@-%@",rangeOption.key,rangeOption.selectedMinValue,rangeOption.selectedMaxValue];
            }
        }
    }
    
    return filterString;
}
@end
