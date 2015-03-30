//
//  FilterViewController.h
//  NeighborhoodAtAGlance
//
//  Created by Christopher Zega on 3/26/15.
//  Copyright (c) 2015 ChrisZega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController  <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doneButtonSelected:(id)sender;
- (IBAction)clearAllButtonSelected:(id)sender;

@end
