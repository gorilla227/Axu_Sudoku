//
//  DataMatrix.m
//  Axu_Sudoku
//
//  Created by Andy on 14-1-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "DataMatrix.h"

@implementation DataMatrix{
    NSSet *originalSet;
    NSArray *difficulty;
}
@synthesize question;
@synthesize answer;
@synthesize playerAnswer;

-(NSMutableSet *)availableNumberPool:(int)index
{
    Coordinate *position = [[Coordinate alloc] initWithIndex:index];
    NSMutableSet *availableNumberPool = [originalSet mutableCopy];
    for (int i = 0; i < 9; i++) {
        [availableNumberPool removeObject:answer[position.rowCoordinate * 9 + i]];
        [availableNumberPool removeObject:answer[i * 9 + position.colCoordinate]];
    }
    for (int i = position.fromRowOfZone; i < position.fromRowOfZone + 3; i++) {
        for (int j = position.fromColOfZone; j < position.fromColOfZone + 3; j++) {
            [availableNumberPool removeObject:answer[i * 9 + j]];
        }
    }
    return availableNumberPool;
}

- (BOOL)check:(int)index
{
    NSMutableSet *availableNumberPool = [[NSMutableSet alloc] init];
    if (index < 81) {
        availableNumberPool = [self availableNumberPool:index];
        while ([availableNumberPool count]) {
            NSNumber *randomNumber = [[availableNumberPool allObjects] objectAtIndex:arc4random()%[availableNumberPool count]];
            answer[index] = [randomNumber copy];
            if (![self check:(index + 1)]) {
                answer[index] = @"0";
                [availableNumberPool removeObject:randomNumber];
            }
            else {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

//Methods for protocal <MainViewControllerDelegate>
-(void)initializeWithDifficulty:(NSInteger)difficultyIndex
{
    question = [[NSMutableArray alloc] initWithCapacity:81];
    answer = [[NSMutableArray alloc] initWithCapacity:81];
    difficulty = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:32], [NSNumber numberWithInt:28], [NSNumber numberWithInt:24], nil];
    
    //Initialize the empty question
    for (int i = 0 ; i < 81; i++) {
        [answer addObject:@""];
    }
    
    //Initialize the answer
    originalSet = [[NSSet alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    [self check:0];
    
    //Generate the question
    [self generateQuestionWithDifficulty:difficultyIndex];
}

-(void)refreshLabels:(NSArray *)array questionOrAnswer:(NSInteger)selectedIndex;
{
    NSMutableArray *dataSource = selectedIndex ? answer : question;
    NSUInteger index;
    for (LabelCell *label in array) {
        index = [array indexOfObject:label];
        label.text = dataSource[index];
        if ([dataSource isEqual:answer]) {
            label.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
            label.textColor = [UIColor blackColor];
            label.layer.borderWidth = 1.0;
            label.layer.borderColor = [UIColor blackColor].CGColor;
        }
        else {
            label.textColor = [UIColor blackColor];
            label.layer.borderWidth = 1.0;
            label.layer.borderColor = [UIColor blackColor].CGColor;
            if (![dataSource[index] isEqual: @""]) {
                label.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
            }
            else {
                label.font = [UIFont fontWithName:@"ArialMT" size:17];
            }
        }
    }
}

-(void)generateQuestionWithDifficulty:(NSInteger)difficultyIndex
{
    //Initialize the empty question
    [question removeAllObjects];
    for (int i = 0 ; i < 81; i++) {
        [question addObject:@""];
    }
    
    int numberOfDisplayedCells = [difficulty[difficultyIndex] intValue];
    for (int i = 0; i < numberOfDisplayedCells; i++) {
        int randomIndex = arc4random() % 81;
        while ([question[randomIndex] intValue]) {
            randomIndex = arc4random() % 81;
        }
        question[randomIndex] = [answer[randomIndex] copy];
    }
    playerAnswer = [question mutableCopy];
}
@end
