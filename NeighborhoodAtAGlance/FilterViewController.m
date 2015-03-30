//
//  FilterViewController.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/26/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "FilterViewController.h"

#import "ValueOptionCollectionViewCell.h"
#import "ValueOptionTableViewCell.h"

#import "RangeOptionTableViewCell.h"

#import "ViewController.h"

@interface FilterViewController ()
@property NSInteger openIndex;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerNib:[UINib nibWithNibName:@"ValueOptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"ValueOptionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RangeOptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"RangeOptionTableViewCell"];
    self.openIndex = -1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FilterManager sharedManager] getFilterOptionsCount];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterOption *option = [[FilterManager sharedManager] getFilterOptionForIndex:indexPath.row];

    if ([option isKindOfClass:[ValueFilterOption class]]) {
        ValueOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValueOptionTableViewCell" forIndexPath:indexPath];
        
        [cell.label setText:option.name];
        [cell setIndex:indexPath.row];
        
        return cell;
    } else if ([option isKindOfClass:[RangeFilterOption class]]) {
        RangeOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RangeOptionTableViewCell" forIndexPath:indexPath];
        
        [cell.label setText:option.name];
        [cell setIndex:indexPath.row];
            
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (self.openIndex == indexPath.row) {
        self.openIndex = -1;
    } else {
        self.openIndex = indexPath.row;
    }
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.openIndex) {
        return 95;
    }
    return 44;
}

- (IBAction)doneButtonSelected:(id)sender {
    UIViewController *viewController = self.presentingViewController;
    if ([viewController isKindOfClass:[ViewController class]]) {
        [((ViewController*)viewController) filterOptionsUpdated];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearAllButtonSelected:(id)sender {
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        OptionTableViewCell *cell = (OptionTableViewCell*)[self.tableView cellForRowAtIndexPath:path];
        [cell disableOption];
    }
}
@end
