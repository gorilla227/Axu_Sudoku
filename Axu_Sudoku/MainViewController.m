//
//  ViewController.m
//  Axu_Sudoku
//
//  Created by Andy on 13-12-17.
//  Copyright (c) 2013年 Xinyi Xu. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController{
    LabelCell *currentSelectedLabel;
    id<MainViewControllerDelegate>delegate;
    DataMatrix *dataMatrix;
    UIAlertView *finishAlertView;
    UIImageView *pauseView;
}

@synthesize timer;
@synthesize matrix;
@synthesize difficultySegement;
@synthesize questionOrAnswerSegement;
@synthesize playingTimerLabel;
@synthesize startAndStopButton;
@synthesize pauseAndResumeButton;
@synthesize enterNumberButtons;
@synthesize markNumberButtons;
@synthesize clearButton;
@synthesize promptButton;
@synthesize markLabelCellViews;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Initial data as index
    dataMatrix = [[DataMatrix alloc] init];
    delegate = dataMatrix;
    currentSelectedLabel = nil;
    markLabelCellViews = [[NSMutableArray alloc] initWithCapacity:81];
    
    //Initial LabelCells and markLabelCellViews
    for (LabelCell *cell in matrix) {
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.delegate = self;
        
        MarkLabelCellView *markLabelCellView = [[MarkLabelCellView alloc] initWithFrame:cell.frame];
        [markLabelCellView setBackgroundColor:cell.backgroundColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        [self.view insertSubview:markLabelCellView atIndex:0];
        [markLabelCellViews addObject:markLabelCellView];
    }
    
    //Initial Timer and timer label
    timer = [[PlayingTimer alloc] init];
    [timer addObserver:self forKeyPath:@"timeText" options:NSKeyValueObservingOptionNew context:NULL];
    [playingTimerLabel setText:@""];
    
    //Set enterNumberButton Click event
    for (UIButton *enterNumberButton in enterNumberButtons) {
        [enterNumberButton addTarget:self action:@selector(enterNumber:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //Set markNumberButton Click event
    for (UIButton *markNumberButton in markNumberButtons) {
        [markNumberButton addTarget:self action:@selector(markNumber:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //Set clearButton
    [clearButton addTarget:self action:@selector(clearSelectedLabel) forControlEvents:UIControlEventTouchUpInside];
    [clearButton.layer setCornerRadius:10.0];
    
    //Set promptButton
    [promptButton addTarget:self action:@selector(promptOneCell) forControlEvents:UIControlEventTouchUpInside];
    [promptButton.layer setCornerRadius:10.0];
    
    //Initial PauseView
//    CGRect pauseViewRect = CGRectMake(0, 55, 320, 513);
    CGRect pauseViewRect = CGRectMake(20, 55, 280, 451);
    pauseView = [[UIImageView alloc] initWithFrame:pauseViewRect];
    [pauseView setImage:[UIImage imageNamed:@"PauseViewBg.jpg"]];
    [pauseView setAlpha:0];
    [self.view addSubview:pauseView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [playingTimerLabel setText:timer.timeText];
}

-(void)changeEnterNumberButtonsStatus
{
    //Create the arrary for filled numbers of each Number
    NSMutableDictionary *filledNumbers = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 9; i++) {
        [filledNumbers setObject:[NSNumber numberWithInt: 0]
                          forKey:[NSString stringWithFormat:@"%i", i]];
    }
    
    //Caculate the filled numbers
    for (int i = 0; i < 81; i++) {
        if ([dataMatrix.playerAnswer[i] isEqual:dataMatrix.answer[i]]) {
            int number = [[filledNumbers objectForKey:dataMatrix.answer[i]] intValue];
            number++;
            [filledNumbers setObject:[NSNumber numberWithInt:number] forKey:dataMatrix.answer[i]];
        }
    }
    
    //Change the button status if the number is all filled in
    for (UIButton *enterNumberButton in enterNumberButtons) {
        [enterNumberButton setEnabled:![[filledNumbers objectForKey:enterNumberButton.currentTitle] isEqualToNumber:[NSNumber numberWithInt:9]]];
    }
}

-(void)changeMarkNumberButtonsStatus
{
    //Change the button status if the number is all filled in
    for (UIButton *markNumberButton in markNumberButtons) {
        [markNumberButton setEnabled:YES];
    }
}

-(BOOL)saveRecord:(NSNumber *)record
{
    NSString *readFileName = [[NSBundle mainBundle] pathForResource:@"BestRecords" ofType:@"plist"];
    NSString *writeFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *writeFileName = [writeFilePath stringByAppendingPathComponent:@"BestRecords.plist"];
    NSMutableDictionary *fileData;
    
    //Determine whether the BestRecords.plist is existed
    fileData = [[NSMutableDictionary alloc] initWithContentsOfFile:writeFileName];
    if (!fileData) {
        fileData = [[NSMutableDictionary alloc] initWithContentsOfFile:readFileName];
    }
    
    //Read last best record
    NSString *difficulty;
    BOOL result;
    switch (difficultySegement.selectedSegmentIndex) {
        case 0:
            difficulty = @"Easy";
            break;
        case 1:
            difficulty = @"Medium";
            break;
        case 2:
            difficulty = @"Hard";
            break;
        default:
            break;
    }
    NSNumber *bestRecord = [fileData valueForKey:difficulty];
    
    //Compare the last best record and current record
    if ([bestRecord intValue] == 0) {
        [fileData setObject:record forKey:difficulty];
        NSLog(@"First Record");
        result = YES;
    }
    else {
        if ([record compare:bestRecord] == NSOrderedAscending) {
            [fileData setObject:record forKey:difficulty];
            NSLog(@"New Record");
            result = YES;
        }
        else {
            NSLog(@"Old Record");
            result = NO;
        }
    }
    if (result) {
        [fileData writeToFile:writeFileName atomically:YES];
    }
    return result;
}

-(void)promptOneCell
{
    NSMutableArray *unfilledLabelCells = [[NSMutableArray alloc] init];
    int promptCellIndex = -1;
    if (currentSelectedLabel) {
        int index = (int)[matrix indexOfObject:currentSelectedLabel];
        if ([dataMatrix.playerAnswer objectAtIndex:index] != [dataMatrix.answer objectAtIndex:index]) {
            promptCellIndex = index;
        }
    }
    if (promptCellIndex == -1) {
        for (int i = 0; i < 81; i++) {
            if (![[dataMatrix.answer objectAtIndex:i] isEqual:[dataMatrix.playerAnswer objectAtIndex:i]]) {
                [unfilledLabelCells addObject:[NSNumber numberWithInt:i]];
            }
        }
        promptCellIndex = [[unfilledLabelCells objectAtIndex:(arc4random() % unfilledLabelCells.count)] intValue];
        currentSelectedLabel = [matrix objectAtIndex:promptCellIndex];
    }
    int numberIndex = [[dataMatrix.answer objectAtIndex:promptCellIndex] intValue] - 1;
    [self enterNumber:[enterNumberButtons objectAtIndex:numberIndex]];
    currentSelectedLabel.layer.borderColor = [UIColor blackColor].CGColor;
    currentSelectedLabel.layer.borderWidth = 1.0;
    currentSelectedLabel = nil;
    [self changeEnterNumberButtonsStatus];
    [self changeMarkNumberButtonsStatus];
}

-(void)changeBorder:(LabelCell *)newSelectedLabel
{
    int index = (int)[matrix indexOfObject:newSelectedLabel];
    if (![newSelectedLabel isEqual:currentSelectedLabel] && [dataMatrix.question[index] isEqual:@""] && timer.stats == 1) {
        newSelectedLabel.layer.borderColor = [UIColor greenColor].CGColor;
        newSelectedLabel.layer.borderWidth = 2.0;
//        CGRect layerFrame = newSelectedLabel.layer.frame;
//        layerFrame.size.height++;
//        layerFrame.size.width++;
        currentSelectedLabel.layer.borderColor = [UIColor blackColor].CGColor;
        currentSelectedLabel.layer.borderWidth = 1.0;
        currentSelectedLabel = newSelectedLabel;
        [self changeEnterNumberButtonsStatus];
        [self changeMarkNumberButtonsStatus];
    }
}

-(void)updateMarkNumber:(NSUInteger)index
{
    //Get the position and number index
    Coordinate *position = [[Coordinate alloc] initWithIndex:(int)index];
    int numberIndex = [[dataMatrix.answer objectAtIndex:index] intValue] - 1;
    
    //Clear the row marks and column marks
    for (int i = 0; i < 9; i++) {
        MarkLabelCellView *rowMarkLabelCellView = [markLabelCellViews objectAtIndex:(9 * position.rowCoordinate + i)];
        [[rowMarkLabelCellView.markLabelCells objectAtIndex:numberIndex] setHidden:YES];
        MarkLabelCellView *colMarkLabelCellView = [markLabelCellViews objectAtIndex:(9 * i + position.colCoordinate)];
        [[colMarkLabelCellView.markLabelCells objectAtIndex:numberIndex] setHidden:YES];
    }
    
    //Clear the zone marks
    for (int i = position.fromRowOfZone; i < position.fromRowOfZone + 3; i++) {
        for (int j = position.fromColOfZone; j < position.fromColOfZone + 3; j++) {
            MarkLabelCellView *zoneMarkLabelCellView = [markLabelCellViews objectAtIndex:(i * 9 + j)];
            [[zoneMarkLabelCellView.markLabelCells objectAtIndex:numberIndex] setHidden:YES];
        }
    }
}

-(void)enterNumber:(id)sender
{
    NSString *number = [NSString stringWithFormat:@"%lu",(unsigned long)[enterNumberButtons indexOfObject:sender] + 1];
    currentSelectedLabel.text = number;
    NSUInteger matrixIndex = [matrix indexOfObject:currentSelectedLabel];
    dataMatrix.playerAnswer[matrixIndex] = number;
    if ([dataMatrix.answer[matrixIndex] isEqual:number]) {
        currentSelectedLabel.textColor = [UIColor greenColor];
        [self updateMarkNumber:matrixIndex];
    }
    else {
        currentSelectedLabel.textColor = [UIColor redColor];
    }
    
    MarkLabelCellView *markNumberView = [markLabelCellViews objectAtIndex:matrixIndex];
    for (UILabel *markLabelCell in markNumberView.markLabelCells) {
        [markLabelCell setHidden:YES];
    }
    
    [self changeEnterNumberButtonsStatus];
    [self determineWhetherFinished];
}

-(void)markNumber:(id)sender
{
    NSUInteger markLabelIndex = [markNumberButtons indexOfObject:sender];
    NSUInteger matrixIndex = [matrix indexOfObject:currentSelectedLabel];
    currentSelectedLabel.text = @"";
    dataMatrix.playerAnswer[matrixIndex] = @"";
    MarkLabelCellView *markNumberView = [markLabelCellViews objectAtIndex:matrixIndex];
    UILabel *markLabelCell = [markNumberView.markLabelCells objectAtIndex:markLabelIndex];
    [markLabelCell setHidden:!markLabelCell.isHidden];
    [self changeEnterNumberButtonsStatus];
}

-(void)clearSelectedLabel
{
    if (currentSelectedLabel) {
        [currentSelectedLabel setText:@""];
        NSUInteger matrixIndex = [matrix indexOfObject:currentSelectedLabel];
        dataMatrix.playerAnswer[matrixIndex] = @"0";
        MarkLabelCellView *markNumberView = [markLabelCellViews objectAtIndex:matrixIndex];
        for (UILabel *markLabelCell in markNumberView.markLabelCells) {
            [markLabelCell setHidden:YES];
        }
        [self changeEnterNumberButtonsStatus];
    }
}

-(void)determineWhetherFinished
{
    //Determine the answer is totally correct
    NSMutableString *message;
    NSString *title;
    if ([dataMatrix.answer isEqualToArray:dataMatrix.playerAnswer]) {
        message = [NSMutableString stringWithFormat:@"Time used %@", timer.timeText];
        if ([self saveRecord:[timer record]]) {
            [message appendString:@"\nYou create the NEW record!"];
            title = @"Congratulations!";
        }
        else {
            title = @"Finished";
        }
        finishAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [timer stopTimer];
        [finishAlertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == finishAlertView) {
        [self stopGame];
    }
}

-(void)startGame
{
    //Start Timer
    [timer startTimer];
    
    //Change the button title as "Stop"
    [startAndStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    //Enable the Pause/Resume Button
    [pauseAndResumeButton setEnabled:YES];
    
    //Disable the difficulty selection
    [difficultySegement setEnabled:NO];
    
    //Enable prompt button
    [promptButton setEnabled:YES];
    
    //Initial the data
    currentSelectedLabel = nil;
    [questionOrAnswerSegement setSelectedSegmentIndex:0];
    [delegate initializeWithDifficulty:difficultySegement.selectedSegmentIndex];
    [delegate refreshLabels:matrix questionOrAnswer:questionOrAnswerSegement.selectedSegmentIndex];
}

-(void)stopGame
{
    //Stop Timer
    [timer stopTimer];
    
    //Change the button title as "Start"
    [startAndStopButton setTitle:@"Start" forState:UIControlStateNormal];
    
    //Clear the playing timer label
    [playingTimerLabel setText:@""];
    
    //Disable the Pause/Resume Button
    [pauseAndResumeButton setEnabled:NO];
    
    //Enable the difficulty selection
    [difficultySegement setEnabled:YES];
    
    //Disable prompt button
    [promptButton setEnabled:NO];
    
    //Disable the enter number buttons and mark number buttons
    for (UIButton *enterNumberButton in enterNumberButtons) {
        [enterNumberButton setEnabled:NO];
    }
    for (UIButton *markNumberButton in markNumberButtons) {
        [markNumberButton setEnabled:NO];
    }
    
    //Clear the selected label
    currentSelectedLabel.layer.borderColor = [UIColor blackColor].CGColor;
    currentSelectedLabel.layer.borderWidth = 1.0;
    
    //Clear the data and refresh the labels
    currentSelectedLabel = nil;
    dataMatrix = [[DataMatrix alloc] init];
    delegate = dataMatrix;
    for (LabelCell *label in matrix) {
        label.text = @"";
    }
    for (MarkLabelCellView *markLabelCellView in markLabelCellViews) {
        for (UILabel *markLabelCell in markLabelCellView.markLabelCells) {
            [markLabelCell setHidden:YES];
        }
    }
    
    //Hide PauseView
    [self.view sendSubviewToBack:pauseView];
    [pauseView setAlpha:0];
}

-(void)pauseGame
{
    //Pause the Timer,
    [timer pauseTimer];
    
    //Change the button title as "Resume"
    [pauseAndResumeButton setTitle:@"Resume" forState:UIControlStateNormal];
    
    //Display PauseView
    [self.view bringSubviewToFront:pauseView];
    [pauseView setAlpha:1];
}

-(void)resumeGame
{
    //Resume the Timer,
    [timer resumeTimer];
    
    //Change the button title as "Pause"
    [pauseAndResumeButton setTitle:@"Pause" forState:UIControlStateNormal];
    
    //Hide PauseView
    [self.view sendSubviewToBack:pauseView];
    [pauseView setAlpha:0];
}

-(IBAction)clickedStatsButtons:(id)sender
{
    if (sender == startAndStopButton) {
        //Click Start and Stop button
        if (timer.stats == 0) {
            [self startGame];
        }
        else {
            [self stopGame];
        }
    }
    else if(sender == pauseAndResumeButton) {
        //Click Pause and Resume button
        if (timer.stats == 1) {
            [self pauseGame];
        }
        else {
            [self resumeGame];
        }
    }

}

-(IBAction)selectedQuestionOrAnswer:(id)sender
{
    [delegate refreshLabels:matrix questionOrAnswer:questionOrAnswerSegement.selectedSegmentIndex];
    currentSelectedLabel = nil;
}
@end
