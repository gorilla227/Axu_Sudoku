//
//  LabelCell.m
//  Axu_Sudoku
//
//  Created by Andy on 14-1-25.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "LabelCell.h"

@implementation LabelCell
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate changeBorder:self];
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
