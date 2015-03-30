//
//  ValueOptionTableViewCell.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/27/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionTableViewCell.h"

@interface ValueOptionTableViewCell : OptionTableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
