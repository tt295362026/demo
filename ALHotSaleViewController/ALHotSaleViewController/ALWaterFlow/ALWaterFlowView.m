//
//  ALWaterFlowView.m
//  ALWaterFlow
//
//  Created by andy on 13-5-29.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALWaterFlowView.h"
#import <QuartzCore/QuartzCore.h>

@interface ALWaterFlowView ()

- (void)initialize;

- (void)pageScroll;

/*
 waterflowview的布局
 */
- (CGFloat)getCellOriganXWithColumn:(NSInteger)i;
- (CGFloat)getCellWidth;

- (ALWaterFlowCell *)rowToDisplayWithColumn:(NSInteger)i;

- (ALWaterFlowCell *)addCellWithColumn:(NSInteger)i BetweenTopAndBaseCell:(ALWaterFlowCell *)cell;
- (void)recyleCellWithColumn:(NSInteger)i BetWeenTopAndBaseCell:(ALWaterFlowCell *)cell;

- (ALWaterFlowCell *)addCellToBottomWithColumn:(NSInteger)i BetweenBottomAndBaseCell:(ALWaterFlowCell *)cell;

- (void)recyleBottomCellWithColumn:(NSInteger)i BetweenBottomAndBaseCell:(ALWaterFlowCell *)cell;

/*
 waterflowview的cell的回收
 */
- (void)recycleCellIntoReusableQueue:(ALWaterFlowCell *)cell;

@end

@implementation ALWaterFlowView

@synthesize viewType = _viewType;

@synthesize waterFlowDatasource = _waterFlowDatasource;
@synthesize waterFlowDelegate = _waterFlowDelegate;

@synthesize cellHeights;

@synthesize numberOfColumns = _numberOfColumns;

@synthesize visibleCells;
@synthesize reusableCells;

@synthesize gabSize;

@synthesize isReflashing;
@synthesize refleshView;

@synthesize isloadingMore;
@synthesize loadingMoreView;

#pragma mark - public methods
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.gabSize = CGSizeMake(1.0f, 1.0f);
        _viewType = ALWaterFlowViewTypeDefault;
        [self setDelegate:self];

        _layoutedIndexPaths = [[NSMutableArray alloc] init];
        
        self.loadingMoreView = [[ALLoadingMoreView alloc] init];
        [self addSubview:self.loadingMoreView];
        
        self.refleshView = [[ALRefleshView alloc] init];
        [self addSubview:self.refleshView];
    }
    return self;
}

- (void)dealloc
{
    self.visibleCells = nil;
    self.reusableCells = nil;
    self.cellHeights = nil;
    self.waterFlowDatasource = nil;
    self.waterFlowDelegate = nil;

    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initialize];
}

- (void)setWaterFlowDatasource:(id<ALWaterFlowViewDatasource>)aWaterFlowDatasource
{
    _waterFlowDatasource = aWaterFlowDatasource;
    if (_waterFlowDelegate) {
        if (self.bounds.size.width > 0) {
            [self initialize];
        }
    }
}

- (void)setWaterFlowDelegate:(id<ALWaterFlowViewDelegate>)aWaterFlowDelegate
{
    _waterFlowDelegate = aWaterFlowDelegate;
    if (_waterFlowDatasource) {
        if (self.bounds.size.width > 0) {
            [self initialize];
        }
    }
}

- (void)reloadData
{
    //remove and recycle all visible cells
    for (int i = 0; i < _numberOfColumns; i++) {
        NSMutableArray *array = [self.visibleCells objectAtIndex:i];
        for (id cell in array) {
            [self recycleCellIntoReusableQueue:(ALWaterFlowCell *)cell];
            [cell removeFromSuperview];
        }
    }
    [_layoutedIndexPaths removeAllObjects];
    
    if(self.isloadingMore) {
        self.isloadingMore = NO;
        [self.loadingMoreView stopLoading];
    }
    
    [self initialize];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (!identifier || identifier == 0 ) return nil;
    
    NSArray *cellsWithIndentifier = [NSArray arrayWithArray:[self.reusableCells objectForKey:identifier]];
    if (cellsWithIndentifier &&  cellsWithIndentifier.count > 0)
    {
        ALWaterFlowCell *cell = [cellsWithIndentifier lastObject];
        [[cell retain] autorelease];
        [[self.reusableCells objectForKey:identifier] removeLastObject];
        return cell;
    }
    return nil;
}

#pragma mark - private methods
- (void)initialize
{
    _numberOfColumns = [self.waterFlowDatasource numberOfColumnsInFlowView:self];
    
    self.reusableCells = [NSMutableDictionary dictionary];
    self.cellHeights = [NSMutableArray arrayWithCapacity:_numberOfColumns];
    self.visibleCells = [NSMutableArray arrayWithCapacity:_numberOfColumns];
    
    CGFloat scrollHeight = 0.0f;
    for (int i = 0; i < _numberOfColumns; i++)
    {
        [self.visibleCells addObject:[NSMutableArray array]];   //
        
        NSMutableArray *tempCellHeights = [NSMutableArray array];
        CGFloat columHeight = 0.0f;
        NSInteger rows = [self.waterFlowDatasource flowView:self numberOfRowsInColumn:i];
        for (int j = 0; j < rows; j++) {
            CGFloat height = [self.waterFlowDelegate flowView:self heightForRowAtIndexPath:[ALIndexPath indexPathForRow:j inCloumn:i inSection:i]];
            columHeight += height + self.gabSize.height;
            [tempCellHeights addObject:[NSNumber numberWithFloat:columHeight]];
        }
        [self.cellHeights addObject:tempCellHeights];
        scrollHeight = (columHeight >= scrollHeight)?columHeight:scrollHeight;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, scrollHeight + 1);
    [self.refleshView setFrame:CGRectMake(0, -REFLESHVIEW_HEIGHT, self.frame.size.width, REFLESHVIEW_HEIGHT)];
    [self.loadingMoreView setFrame:CGRectMake(0, scrollHeight, self.frame.size.width, LOADINGMOREVIEW_HEIGHT)];
    
    [self pageScroll];
}

- (void)pageScroll
{
    for (int i = 0 ; i < _numberOfColumns; i++) {
        ALWaterFlowCell *baseCell = [self rowToDisplayWithColumn:i];
        ALWaterFlowCell *curCell = nil;
        
        //base on this cell at rowToDisplay and process the other cells
        //1. add cell above this basic cell if there's margin between basic cell and top
        curCell = [self addCellWithColumn:i BetweenTopAndBaseCell:baseCell];
        
        //2. remove cell above this basic cell if there's no margin between basic cell and top
        [self recyleCellWithColumn:i BetWeenTopAndBaseCell:curCell];

        //3. add cells below this basic cell if there's margin between basic cell and bottom
        baseCell = [[self.visibleCells objectAtIndex:i] lastObject];
        curCell = [self addCellToBottomWithColumn:i BetweenBottomAndBaseCell:baseCell];
        
        //4. remove cells below this basic cell if there's no margin between basic cell and bottom
        [self recyleBottomCellWithColumn:i BetweenBottomAndBaseCell:curCell];
    }
    NSInteger count = 0;
    if ([self.visibleCells count] > 0) {
        for (NSArray *tempArray in self.visibleCells) {
            count += tempArray.count;
        }
    }
    if ([self.reusableCells objectForKey:@"Cell"]) {
        NSArray *tempArray = [self.reusableCells objectForKey:@"Cell"];
        count +=tempArray.count;
    }
//    NSLog(@"Total Cells count:%d", count);
}

- (CGFloat)getCellOriganXWithColumn:(NSInteger)i
{
    float origin_x = i * (self.frame.size.width / _numberOfColumns) + self.gabSize.width/2;
    return origin_x;
}

- (CGFloat)getCellWidth
{
    float width = self.frame.size.width / _numberOfColumns - self.gabSize.width;
    return width;
}

- (ALWaterFlowCell *)rowToDisplayWithColumn:(NSInteger)i
{
    ALWaterFlowCell *cell = nil;
    float origin_x = [self getCellOriganXWithColumn:i];
    float width = [self getCellWidth];
    
    ALIndexPath *cellIndex = nil;
    NSArray *cells = [self.visibleCells objectAtIndex:i];
    if (cells == nil || cells.count == 0) {
        int rowToDisplay = 0;
        //calculate which row to display in this column
        for( int j = 0; j < [[self.cellHeights objectAtIndex:i] count] - 1; j++) {
            float everyCellHeight = [[[self.cellHeights objectAtIndex:i] objectAtIndex:j] floatValue];
            if(everyCellHeight < self.contentOffset.y) {
                rowToDisplay ++;
            }
        }
#ifdef DEBUG
        NSLog(@"row to display %d", rowToDisplay);
#endif
        float origin_y = 0.0f, height = 0.0f;
        if (rowToDisplay == 0) {
            origin_y = self.gabSize.height/2;
            height = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue];
        }
        else if (rowToDisplay < [[self.cellHeights objectAtIndex:i] count]) {
            origin_y = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay - 1] floatValue] + self.gabSize.height/2;
            height  = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue] - origin_y;
        }
        origin_y += self.gabSize.height/2;
        height -= self.gabSize.height;
        
        cellIndex = [ALIndexPath indexPathForRow:rowToDisplay inCloumn:i inSection:i];
        cell = [_waterFlowDatasource flowView:self cellForRowAtIndexPath:cellIndex];
        cell.delegate = self;
        cell.indexPath = cellIndex;
        if (self.viewType == ALWaterFlowViewTypeFixedHeight) {
            [cell.imageView setImageType:AsyImageViewTypeScaled];
        }

        cell.frame = CGRectMake(origin_x, origin_y, width, height);
        [self insertSubview:cell atIndex:0];
        [[self.visibleCells objectAtIndex:i] insertObject:cell atIndex:0];
    }
    else   //there are cells in visibelCellArray
    {
        cell = [[self.visibleCells objectAtIndex:i] objectAtIndex:0];
    }
    return cell;
}

//1. add cell above "cell" if there's margin between basic cell and top
- (ALWaterFlowCell *)addCellWithColumn:(NSInteger)i BetweenTopAndBaseCell:(ALWaterFlowCell *)cell
{
    float origin_x = [self getCellOriganXWithColumn:i];
    float width = [self getCellWidth];
    
    while ( cell && ((cell.frame.origin.y - self.contentOffset.y) > 0.0001))
    {
        float origin_y = 0;
        float height = 0;
        int rowToDisplay = cell.indexPath.row;
        
        if(rowToDisplay == 0) {
            cell = nil;
            break;
        } else if (rowToDisplay == 1) {
            origin_y = 0;
            height = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay  -1] floatValue];
        } else if (cell.indexPath.row < [[self.cellHeights objectAtIndex:i] count]) {
            origin_y = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay -2] floatValue];
            height = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay - 1] floatValue] - origin_y;
        }
        origin_y += self.gabSize.height/2;
        height -= self.gabSize.height;
        
        ALIndexPath *curIndexPath = [ALIndexPath indexPathForRow: rowToDisplay > 0 ? (rowToDisplay - 1) : 0 inCloumn:i inSection:i];
        cell = [_waterFlowDatasource flowView:self cellForRowAtIndexPath:curIndexPath];
        cell.delegate = self;
        cell.indexPath = curIndexPath;
        if (self.viewType == ALWaterFlowViewTypeFixedHeight) {
            [cell.imageView setImageType:AsyImageViewTypeScaled];
        }
        cell.frame = CGRectMake(origin_x, origin_y, width, height);
        [[self.visibleCells objectAtIndex:i] insertObject:cell atIndex:0];
        [self insertSubview:cell atIndex:0];
    }
    return cell;
}

//2. remove cell above this basic cell if there's no margin between basic cell and top
- (void)recyleCellWithColumn:(NSInteger)i BetWeenTopAndBaseCell:(ALWaterFlowCell *)cell
{
    while (cell &&  ((cell.frame.origin.y + cell.frame.size.height  - self.contentOffset.y) <  0.0001))
    {
        [cell removeFromSuperview];
        [self recycleCellIntoReusableQueue:cell];
        [[self.visibleCells objectAtIndex:i] removeObject:cell];
        
        if(((NSMutableArray*)[self.visibleCells objectAtIndex:i]).count > 0)
        {
            cell = [[self.visibleCells objectAtIndex:i] objectAtIndex:0];
        }
        else
        {
            cell = nil;
        }
    }
}

//3. add cells below this basic cell if there's margin between basic cell and bottom
- (ALWaterFlowCell *)addCellToBottomWithColumn:(NSInteger)i BetweenBottomAndBaseCell:(ALWaterFlowCell *)cell
{
    float origin_x = [self getCellOriganXWithColumn:i];
    float width = [self getCellWidth];
    
    while (cell &&  ((cell.frame.origin.y + cell.frame.size.height - self.frame.size.height - self.contentOffset.y) <  0.0001)) {
        float origin_y = 0;
        float height = 0;
        int rowToDisplay = cell.indexPath.row;
        
        if(rowToDisplay == [[self.cellHeights objectAtIndex:i] count] - 1) {
            origin_y = 0;
            cell = nil;
            break;
        }
        else {
            origin_y = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue];
            height = [[[self.cellHeights objectAtIndex:i] objectAtIndex:rowToDisplay + 1] floatValue] -  origin_y;
        }
        origin_y += self.gabSize.height/2;
        height -= self.gabSize.height;
        
        cell = [_waterFlowDatasource flowView:self cellForRowAtIndexPath:[ALIndexPath indexPathForRow:rowToDisplay + 1 inCloumn:i inSection:i]];
        cell.delegate = self;
        if (self.viewType == ALWaterFlowViewTypeFixedHeight) {
            [cell.imageView setImageType:AsyImageViewTypeScaled];
        }
        cell.indexPath = [ALIndexPath indexPathForRow:rowToDisplay + 1 inCloumn:i inSection:i];
        cell.frame = CGRectMake(origin_x, origin_y, width, height);
        
        [[self.visibleCells objectAtIndex:i] addObject:cell];
        [self insertSubview:cell atIndex:0];
    }
    return cell;
}

//4. remove cells below this basic cell if there's no margin between basic cell and bottom
- (void)recyleBottomCellWithColumn:(NSInteger)i BetweenBottomAndBaseCell:(ALWaterFlowCell *)cell
{
    while (cell &&  ((cell.frame.origin.y - self.frame.size.height - self.contentOffset.y) > 0.0001))
    {
        [cell removeFromSuperview];
        [self recycleCellIntoReusableQueue:cell];
        [[self.visibleCells objectAtIndex:i] removeObject:cell];
        
        if(((NSMutableArray*)[self.visibleCells objectAtIndex:i]).count > 0)
        {
            cell = [[self.visibleCells objectAtIndex:i] lastObject];
        }
        else
        {
            cell = nil;
        }
    }
}

- (void)recycleCellIntoReusableQueue:(ALWaterFlowCell *)cell
{
    [cell clearContent];
    if(!self.reusableCells) {
        self.reusableCells = [NSMutableDictionary dictionary];
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
        [self.reusableCells setObject:array forKey:cell.reuseIdentifier];
    }
    else {
        if (![self.reusableCells objectForKey:cell.reuseIdentifier]) {
            NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
            [self.reusableCells setObject:array forKey:cell.reuseIdentifier];
        }
        else {
            [[self.reusableCells objectForKey:cell.reuseIdentifier] addObject:cell];
        }
    }
}

#pragma mark - UIScrollViewDelegate<NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double curCallTime = CACurrentMediaTime();
    
    double timeDelta = curCallTime - prevCallTime;
    
    double curCallOffset = scrollView.contentOffset.y;
    
    double offsetDelta = curCallOffset - prevCallOffset;
    
    double velocity = fabs(offsetDelta / timeDelta);
    
    prevCallTime = curCallTime;
    prevCallOffset = curCallOffset;
    
    if (velocity < 10000 ) {
        [self pageScroll];
    }
    else {
        NSLog(@"===========your speed over 800");
    }
    [self.refleshView refleshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.refleshView refreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height - 1)
    {
        if (self.isloadingMore)
            return;
        
        self.isloadingMore = YES;
        [self.loadingMoreView startLoading];
    }
}




#pragma mark - ALWaterFlowCellDelegate <NSObject>
- (void)ALWaterFlowCell:(ALWaterFlowCell *)cell WithSize:(CGSize)size
{
    if (_viewType == ALWaterFlowViewTypeFixedHeight) {
        return;
    }
    for (NSNumber *tempNumber in _layoutedIndexPaths) {
        if (tempNumber.intValue == cell.indexPath.row * self.numberOfColumns + cell.indexPath.column) {
            return;
        }
    }
    [_layoutedIndexPaths addObject:[NSNumber numberWithInt:cell.indexPath.row * self.numberOfColumns + cell.indexPath.column]];

    float width = (self.frame.size.width / _numberOfColumns) - 1;
    float WHRat = size.width/size.height;
    float height = width/WHRat;
    float cellHeight = cell.bounds.size.height;
    float gab = height - cellHeight;
    

    CGRect cellFrame = cell.frame;
    cellFrame.size.height += gab;
    [cell setFrame:cellFrame];

    
    NSMutableArray *tempCells = [self.visibleCells objectAtIndex:cell.indexPath.column];
    NSInteger curIndex = [tempCells indexOfObject:cell];
    for (int i = curIndex + 1; i < [tempCells count]; i++) {
        ALWaterFlowCell *cell = [tempCells objectAtIndex:i];
        CGRect cellFrame = cell.frame;
        cellFrame.origin.y += gab;
        [cell setFrame:cellFrame];
    }

    NSMutableArray *tempArray = [self.cellHeights objectAtIndex:cell.indexPath.column];
    for (int i = cell.indexPath.row; i < tempArray.count; i++) {
        NSNumber *tempHeight = [tempArray objectAtIndex:i];
        float curHeight = (tempHeight.floatValue + gab);
        [tempArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:curHeight]];
    }

    CGFloat scrollHeight = 0.0f;
    for (NSArray *array in self.cellHeights) {
        NSNumber *lastHeight = [array lastObject];
        CGFloat columHeight = lastHeight.floatValue;
        scrollHeight = (columHeight >= scrollHeight)?columHeight:scrollHeight;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, scrollHeight + 1);
    [self.loadingMoreView setFrame:CGRectMake(0, scrollHeight, self.frame.size.width, LOADINGMOREVIEW_HEIGHT)];
}

- (void)ALWaterFlowCellDidselected:(ALWaterFlowCell *)cell
{
    if (_waterFlowDelegate && [_waterFlowDelegate respondsToSelector:@selector(flowView:didSelectRowAtIndexPath:)]) {
        [_waterFlowDelegate flowView:self didSelectRowAtIndexPath:cell.indexPath];
    }
}

@end
