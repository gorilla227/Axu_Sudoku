//
//  MarkLabelCellView.m
//  Axu_Sudoku
//
//  Created by Andy on 14-2-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MarkLabelCellView.h"

@implementation MarkLabelCellView
@synthesize markLabelCells;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        markLabelCells = [[NSMutableArray alloc] initWithCapacity:9];
        CGFloat cellWidth = frame.size.width / 3 - 1;
        CGFloat cellHeight = frame.size.height / 3 - 1;
        
        //Generate the label cells
        for(int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                UILabel *cell = [[UILabel alloc] initWithFrame:CGRectMake(j * cellHeight + 1.5, i * cellWidth + 1.5, cellWidth, cellHeight)];
                [cell setText:[NSString stringWithFormat:@"%i", i * 3 + j + 1]];
                [cell setTextColor:[UIColor yellowColor]];
                [cell setTextAlignment:NSTextAlignmentCenter];
                [cell setFont:[UIFont fontWithName:@"Helvetica Neue" size:9]];
                [cell setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
                [cell setHidden:YES];
                [markLabelCells addObject:cell];
                [self addSubview:cell];
            }
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
