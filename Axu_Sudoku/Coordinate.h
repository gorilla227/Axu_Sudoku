//
//  Coordinate.h
//  Axu_Sudoku
//
//  Created by Andy on 14-1-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coordinate : NSObject
@property int rowCoordinate;
@property int colCoordinate;
@property int zoneIndex;
@property int fromRowOfZone;
@property int fromColOfZone;
-(id)initWithIndex:(int)index;
-(int)indexOfCoordinate;
@end