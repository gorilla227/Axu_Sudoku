//
//  BestRecordsViewController.h
//  Axu_Sudoku
//
//  Created by Andy on 14-2-9.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestRecordsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITableView *bestRecordsTable;
@property IBOutlet UIButton *resetAllButton;
-(void)resetAllBestRecords;
@end
