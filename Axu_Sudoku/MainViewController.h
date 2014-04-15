//
//  ViewController.h
//  Axu_Sudoku
//
//  Created by Andy on 13-12-17.
//  Copyright (c) 2013年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataMatrix.h"
#import "PlayingTimer.h"
#import "MarkLabelCellView.h"

@interface MainViewController : UIViewController<LabelCellDelegate, UIAlertViewDelegate>
@property PlayingTimer *timer;
@property IBOutletCollection(LabelCell) NSArray *matrix;
@property IBOutlet UISegmentedControl *difficultySegement;
@property IBOutlet UISegmentedControl *questionOrAnswerSegement;
@property IBOutlet UILabel *playingTimerLabel;
@property IBOutlet UIButton *startAndStopButton;
@property IBOutlet UIButton *pauseAndResumeButton;
@property IBOutlet UIButton *clearButton;
@property IBOutlet UIButton *promptButton;
@property IBOutletCollection(UIButton) NSArray *enterNumberButtons;
@property IBOutletCollection(UIButton) NSArray *markNumberButtons;
@property NSMutableArray *markLabelCellViews;
-(IBAction)selectedQuestionOrAnswer:(id)sender;
-(IBAction)clickedStatsButtons:(id)sender;
-(void)enterNumber:(id)sender;
-(void)markNumber:(id)sender;
-(void)startGame;
-(void)stopGame;
-(void)pauseGame;
-(void)resumeGame;
-(void)determineWhetherFinished;
-(void)changeEnterNumberButtonsStatus;
-(void)changeMarkNumberButtonsStatus;
-(void)clearSelectedLabel;
-(BOOL)saveRecord:(NSNumber *)record;
-(void)updateMarkNumber:(NSUInteger)index;
-(void)promptOneCell;
@end