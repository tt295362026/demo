//
//  ALIndexPath.m
//  ALWaterFlow
//
//  Created by andy on 13-5-30.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALIndexPath.h"

@interface ALIndexPath ()

- (NSComparisonResult)compareLeft:(NSInteger)left With:(NSInteger)right;

@end

@implementation ALIndexPath

@synthesize section;
@synthesize column;
@synthesize row;

+ (ALIndexPath *)indexPathForRow:(NSInteger)row inCloumn:(NSInteger)column inSection:(NSInteger)section
{
    ALIndexPath *result = [[ALIndexPath alloc] init];
    [result setColumn:column];
    [result setRow:row];
    [result setSection:section];
    return result;
}

// comparison support
- (NSComparisonResult)compare:(ALIndexPath *)indexPath
{
    NSComparisonResult result = 0;
    result = [self compareLeft:self.section With:indexPath.section];
    if (result == NSOrderedSame) {
        result = [self compareLeft:self.column With:indexPath.column];
    }
    if (result == NSOrderedSame) {
        result = [self compareLeft:self.row With:indexPath.row];
    }
    return result;
}

- (NSComparisonResult)compareLeft:(NSInteger)left With:(NSInteger)right
{
    if (left > right) {
        return NSOrderedDescending;
    }
    else if (left < right) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}

@end
