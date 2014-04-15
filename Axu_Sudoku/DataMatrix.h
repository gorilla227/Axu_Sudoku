//
//  DataMatrix.h
//  Axu_Sudoku
//
//  Created by Andy on 14-1-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
#import "LabelCell.h"

@protocol MainViewControllerDelegate <NSObject>
-(void)refreshLabels:(NSArray *)array questionOrAnswer:(NSInteger)selectedIndex;
-(void)generateQuestionWithDifficulty:(NSInteger)difficultyIndex;
-(void)initializeWithDifficulty:(NSInteger)difficultyIndex;
@end

@interface DataMatrix : NSObject<MainViewControllerDelegate>

@property NSMutableArray *question;
@property NSMutableArray *answer;
@property NSMutableArray *playerAnswer;

-(BOOL)check:(int)index;
-(NSMutableSet *)availableNumberPool:(int)index;

@end