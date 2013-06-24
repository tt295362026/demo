//
//  ALWaterFlowView.h
//  ALWaterFlow
//
//  Created by andy on 13-5-29.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALWaterFlowCell.h"
#import "ALRefleshView.h"
#import "ALLoadingMoreView.h"

@class ALWaterFlowView;

typedef NS_ENUM(NSInteger, ALWaterFlowViewType) {
    ALWaterFlowViewTypeFixedHeight = 0,
    ALWaterFlowViewTypeScaledHeight = 1,
    ALWaterFlowViewTypeDefault = ALWaterFlowViewTypeScaledHeight
};

#pragma mark - ALWaterFlowViewDatasource
@protocol ALWaterFlowViewDatasource <NSObject>

@required

- (NSInteger)numberOfColumnsInFlowView:(ALWaterFlowView *)flowView;

- (NSInteger)flowView:(ALWaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column;

- (ALWaterFlowCell *)flowView:(ALWaterFlowView *)flowView cellForRowAtIndexPath:(ALIndexPath *)indexPath;

@end

#pragma mark - ALWaterFlowViewDelegate
@protocol ALWaterFlowViewDelegate <NSObject>

@required

- (CGFloat)flowView:(ALWaterFlowView *)flowView heightForRowAtIndexPath:(ALIndexPath *)indexPath;

@optional

- (void)flowView:(ALWaterFlowView *)flowView didSelectRowAtIndexPath:(ALIndexPath *)indexPath;

@end

#pragma mark - ALWaterFlowView
@interface ALWaterFlowView : UIScrollView <UIScrollViewDelegate, ALWaterFlowCellDelegate>
{
    NSInteger _viewType;
    NSInteger _numberOfColumns;
    
    id <ALWaterFlowViewDelegate> _waterFlowDelegate;
    id <ALWaterFlowViewDatasource> _waterFlowDatasource;
    
    NSMutableArray *_layoutedIndexPaths;
    
    double prevCallTime;
    double prevCallOffset;
}

@property (nonatomic, readonly) NSInteger numberOfColumns;
@property (nonatomic) NSInteger viewType;

@property (nonatomic, assign) id <ALWaterFlowViewDelegate> waterFlowDelegate;
@property (nonatomic, assign) id <ALWaterFlowViewDatasource> waterFlowDatasource;

@property (nonatomic) CGSize gabSize;

@property (nonatomic, retain) NSMutableArray *cellHeights;   //array of cells height arrays, count = numberofcolumns, and elements in each single child array represents is a total height from this cell to the top

@property (nonatomic, retain) NSMutableArray *visibleCells; //array of visible cell arrays, count = numberofcolumns
@property (nonatomic, retain) NSMutableDictionary *reusableCells;   //key- identifier, value- array of cells

- (void)reloadData;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@property (nonatomic) BOOL isReflashing;
@property (nonatomic, retain) ALRefleshView *refleshView;

@property (nonatomic) BOOL isloadingMore;
@property (nonatomic, retain) ALLoadingMoreView *loadingMoreView;

@end
