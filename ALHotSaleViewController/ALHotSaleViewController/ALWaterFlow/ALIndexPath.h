//
//  ALIndexPath.h
//  ALWaterFlow
//
//  Created by andy on 13-5-30.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALIndexPath : NSObject

+ (ALIndexPath *)indexPathForRow:(NSInteger)row inCloumn:(NSInteger)column inSection:(NSInteger)section;

- (NSComparisonResult)compare:(ALIndexPath *)otherObject;

@property(nonatomic) NSInteger section;
@property(nonatomic) NSInteger column;
@property(nonatomic) NSInteger row;

@end