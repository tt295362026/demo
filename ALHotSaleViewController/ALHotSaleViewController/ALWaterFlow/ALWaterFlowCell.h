//
//  ALWaterFlowCell.h
//  ALWaterFlow
//
//  Created by andy on 13-5-29.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALIndexPath.h"
#import "AsyImageView.h"

@class ALWaterFlowCell;

@protocol ALWaterFlowCellDelegate <NSObject>

- (void)ALWaterFlowCell:(ALWaterFlowCell *)cell WithSize:(CGSize)size;
- (void)ALWaterFlowCellDidselected:(ALWaterFlowCell *)cell;

@end

@interface ALWaterFlowCell : UIView <AsyImageViewDelegate>
{
    ALIndexPath *_indexPath;
    NSString *_reuseIdentifier;
}

@property (nonatomic, assign) id <ALWaterFlowCellDelegate> delegate;

@property (nonatomic, retain) ALIndexPath *indexPath;
@property (nonatomic, retain) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) UILabel *textView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) AsyImageView *imageView;

- (void)clearContent;

@end