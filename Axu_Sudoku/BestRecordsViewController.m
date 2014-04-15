//
//  BestRecordsViewController.m
//  Axu_Sudoku
//
//  Created by Andy on 14-2-9.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "BestRecordsViewController.h"

@interface BestRecordsViewController ()

@end

@implementation BestRecordsViewController{
    NSString *bestRecordTableCellIdentifier;
    NSDictionary *fileData;
    NSString *fileName;
}
@synthesize bestRecordsTable;
@synthesize resetAllButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    fileData = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    if (!fileData) {
        fileName = [[NSBundle mainBundle] pathForResource:@"BestRecords" ofType:@"plist"];
        fileData = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    bestRecordTableCellIdentifier = @"BestRecordTableViewCell";
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = [filePath stringByAppendingPathComponent:@"BestRecords.plist"];
    [resetAllButton addTarget:self action:@selector(resetAllBestRecords) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bestRecordTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bestRecordTableCellIdentifier];
    }
    NSString *key;
    switch (indexPath.row) {
        case 0:
            key = @"Easy";
            break;
        case 1:
            key = @"Medium";
            break;
        case 2:
            key = @"Hard";
            break;
        default:
            break;
    }
    int record = [[fileData objectForKey:key] intValue];
    int sec = record % 60;
    int min = record / 60;
    int hr = min / 60;
    min = min % 60;
    NSString *hour, *minute, *second;
    hour = [NSString stringWithFormat:@"%i", hr];
    if (min < 10) {
        minute = [NSString stringWithFormat:@"0%i", min];
    }
    else {
        minute = [NSString stringWithFormat:@"%i", min];
    }
    if (sec < 10) {
        second = [NSString stringWithFormat:@"0%i", sec];
    }
    else {
        second = [NSString stringWithFormat:@"%i", sec];
    }
    NSString *recordString = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    [cell.textLabel setText:key];
    [cell.detailTextLabel setText:recordString];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fileData.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Best Records";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key;
        switch (indexPath.row) {
            case 0:
                key = @"Easy";
                break;
            case 1:
                key = @"Medium";
                break;
            case 2:
                key = @"Hard";
                break;
            default:
                break;
        }
        [fileData setValue:[NSNumber numberWithInt:0] forKey:key];
        [fileData writeToFile:fileName atomically:YES];
        [bestRecordsTable reloadData];
    }
}

-(void)resetAllBestRecords
{
    for (NSString *key in [fileData allKeys]) {
        [fileData setValue:[NSNumber numberWithInt:0] forKey:key];
    }
    [fileData writeToFile:fileName atomically:YES];
    [bestRecordsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
