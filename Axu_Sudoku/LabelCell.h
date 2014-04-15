//
//  LabelCell.h
//  Axu_Sudoku
//
//  Created by Andy on 14-1-25.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LabelCell;
@protocol LabelCellDelegate <NSObject>

-(void)changeBorder:(LabelCell *)newSelectedLabel;

@end
@interface LabelCell : UILabel
@property id<LabelCellDelegate>delegate;
@end
