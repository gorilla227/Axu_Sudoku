//
//  Coordinate.m
//  Axu_Sudoku
//
//  Created by Andy on 14-1-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate
@synthesize rowCoordinate;
@synthesize colCoordinate;
@synthesize zoneIndex;
@synthesize fromRowOfZone;
@synthesize fromColOfZone;

-(int)indexOfCoordinate
{
    return rowCoordinate * 9 + colCoordinate;
}

-(id)initWithIndex:(int)index
{
    Coordinate *newCoordinate = [[Coordinate alloc] init];
    newCoordinate.rowCoordinate = index / 9;
    newCoordinate.colCoordinate = index % 9;
    if (newCoordinate.rowCoordinate < 3){
        if (newCoordinate.colCoordinate < 3) {
            newCoordinate.zoneIndex = 0;
            newCoordinate.fromRowOfZone = 0;
            newCoordinate.fromColOfZone = 0;
        }
        else if(newCoordinate.colCoordinate < 6){
            newCoordinate.zoneIndex = 1;
            newCoordinate.fromRowOfZone = 0;
            newCoordinate.fromColOfZone = 3;
        }
        else{
            newCoordinate.zoneIndex = 2;
            newCoordinate.fromRowOfZone = 0;
            newCoordinate.fromColOfZone = 6;
        }
    }
    else if (newCoordinate.rowCoordinate < 6){
        if (newCoordinate.colCoordinate < 3) {
            newCoordinate.zoneIndex = 3;
            newCoordinate.fromRowOfZone = 3;
            newCoordinate.fromColOfZone = 0;
        }
        else if(newCoordinate.colCoordinate < 6){
            newCoordinate.zoneIndex = 4;
            newCoordinate.fromRowOfZone = 3;
            newCoordinate.fromColOfZone = 3;
        }
        else{
            newCoordinate.zoneIndex = 5;
            newCoordinate.fromRowOfZone = 3;
            newCoordinate.fromColOfZone = 6;
        }
    }
    else{
        if (newCoordinate.colCoordinate < 3) {
            newCoordinate.zoneIndex = 6;
            newCoordinate.fromRowOfZone = 6;
            newCoordinate.fromColOfZone = 0;
        }
        else if(newCoordinate.colCoordinate < 6){
            newCoordinate.zoneIndex = 7;
            newCoordinate.fromRowOfZone = 6;
            newCoordinate.fromColOfZone = 3;
        }
        else{
            newCoordinate.zoneIndex = 8;
            newCoordinate.fromRowOfZone = 6;
            newCoordinate.fromColOfZone = 6;
        }
    }
    return newCoordinate;
}
@end