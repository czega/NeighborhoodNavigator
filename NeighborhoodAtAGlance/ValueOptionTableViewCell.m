//
//  ValueOptionTableViewCell.m
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import "ValueOptionTableViewCell.h"
#import "ValueOptionCollectionViewCell.h"

@implementation ValueOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ValueOptionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ValueOptionCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ValueFilterOption *option = (ValueFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    return option.values.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ValueOptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ValueOptionCollectionViewCell" forIndexPath:indexPath];
    
    ValueFilterOption *option = (ValueFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    NSNumber *value = option.values[indexPath.row];
    
    [cell.label setText:value.stringValue];
    
    if (option.isActive && option.selectedIndex == indexPath.row) {
        [cell.label setTextColor:kBlueColor];
        [cell.label.layer setBorderColor:kBlueColor.CGColor];
    } else {
        [cell.label setTextColor:[UIColor lightGrayColor]];
        [cell.label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i < [collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        ValueOptionCollectionViewCell *cell = (ValueOptionCollectionViewCell*)[collectionView cellForItemAtIndexPath:path];
        [cell.label setTextColor:[UIColor lightGrayColor]];
        [cell.label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
    
    ValueOptionCollectionViewCell *cell = (ValueOptionCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.label setTextColor:kBlueColor];
    [cell.label.layer setBorderColor:kBlueColor.CGColor];
    
    [self.label setTextColor:kBlueColor];
    [self.checkmark setImage:[UIImage imageNamed:@"CheckmarkBlue"]];

    ValueFilterOption *option = (ValueFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    [option setIsActive:YES];
    [option setSelectedIndex:indexPath.row];
}



- (void)disableOption {
    [super disableOption];
    
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        ValueOptionCollectionViewCell *cell = (ValueOptionCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:path];
        [cell.label setTextColor:[UIColor lightGrayColor]];
        [cell.label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
}

- (void)enableOption {
    [super enableOption];
    
    ValueFilterOption *option = (ValueFilterOption*)[[FilterManager sharedManager]getFilterOptionForIndex:self.index];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:option.selectedIndex inSection:0];
    ValueOptionCollectionViewCell *cell = (ValueOptionCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:path];
    [cell.label setTextColor:kBlueColor];
    [cell.label.layer setBorderColor:kBlueColor.CGColor];
}
@end
