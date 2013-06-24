//
//  ALNavigationBar.m
//  ALUIViewController
//
//  Created by andy on 13-4-28.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALNavigationBar.h"

/*
 ALNavigationBar
 
 This is used to cover the UINavigationBar of the UINavigationController.
 
 It has server items used as the same way of the UINavigationBar.
 
 */

@interface ALNavigationBar ()

- (UIImage *)getImageWith:(NSString *)imageName;

- (UILabel *)getTitleLabel;

- (UIButton *)getBackBtn;

- (NSMutableArray *)getLeftBtnAray;

- (NSMutableArray *)getRightBtnAray;

- (void)updateGeometry;

- (void)setupBackBtnWithActionType:(NSInteger)type WithAnimated:(BOOL)animated;

- (void)setupTitleWithActionType:(NSInteger)type WithAnimated:(BOOL)animated;

- (void)setupLeftItemsWithActionType:(NSInteger)type WithAnimated:(BOOL)animated;

- (void)setupRightItemsWithActionType:(NSInteger)type WithAnimated:(BOOL)animated;

@end

@implementation ALNavigationBar

@synthesize delegate = _delegate;
@synthesize topItem = _topItem;
@synthesize backItem = _backItem;
@synthesize items = _items;

@synthesize bgImageName = _bgImageName;
@synthesize backBtnImageName = _backBtnImageName;
@synthesize btnImageName = _btnImageName;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blueColor]];
        _backBtnType = ALNavigationBackBtnTypePreviousTitle;
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_backBtn) {
        _backBtn = nil;
    }
    if (_titleLabel) {
        [_titleLabel release];
        _titleLabel = nil;
    }
    if (_items) {
        [_items removeAllObjects];
        [_items release];
        _items = nil;
    }
    
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateGeometry];
}

- (void)updateGeometry
{
    if (_titleLabel) {
        [_titleLabel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    }
}

- (void)setBgImageName:(NSString *)aBgImageName
{
    _bgImageName = aBgImageName;
    UIImage *tempBg = [UIImage imageNamed:aBgImageName];
    if (tempBg) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:tempBg]];
    }
}

#pragma mark - ALNavigtaionBar ()
- (UIImage *)getImageWith:(NSString *)imageName
{
    UIImage *result = nil;
    if (imageName) {
        result = [UIImage imageNamed:imageName];
    }
    return result;
}

- (UILabel *)getTitleLabel
{
    UILabel *tempLabel = [[UILabel alloc] init];
    [tempLabel setFrame:CGRectMake(0, 0, 350, self.bounds.size.height)];
    [tempLabel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [tempLabel setTextAlignment:UITextAlignmentCenter];
    [tempLabel setBackgroundColor:[UIColor clearColor]];
    [tempLabel setTextColor:[UIColor whiteColor]];
    return tempLabel;
}

- (UIButton *)getBackBtn
{
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempBtn setBackgroundImage:[self getImageWith:_backBtnImageName] forState:UIControlStateNormal];
    
    CGSize maxSize = CGSizeMake(90, self.bounds.size.height);
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize textSize = [_topItem.backButtonTitle sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeClip];
    textSize.width += 20;
    textSize.height = self.bounds.size.height - 10;
    
    [tempBtn.titleLabel setFont:font];
    [tempBtn setFrame:CGRectMake(10, 5, textSize.width, textSize.height)];
    if (_delegate) {
        [tempBtn addTarget:_delegate action:@selector(OnBackBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return tempBtn;
}

- (NSArray *)getLeftBtnAray
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    UIViewController *tempVC = (UIViewController *)_topItem.currentViewController;
    NSArray *tempArray = tempVC.navigationItem.leftBarButtonItems;
    
    CGFloat curX = 10;
    for (int i = 0; i < [tempArray count]; i++) {
        UIBarButtonItem *tempItem = [tempArray objectAtIndex:i];
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (tempItem.image) {
            [tempBtn setBackgroundImage:tempItem.image forState:UIControlStateNormal];
            CGSize imageSize = tempItem.image.size;
            CGFloat btnHeight = self.bounds.size.height - 10;
            CGSize btnSize = CGSizeMake(btnHeight*imageSize.width/imageSize.height, btnHeight);
            [tempBtn setFrame:CGRectMake(curX, 5, btnSize.width, btnSize.height)];
            curX += btnSize.width + 10;
        }
        if (tempItem.title) {
            [tempBtn setTitle:tempItem.title forState:UIControlStateNormal];
            CGSize maxSize = CGSizeMake(90, self.bounds.size.height);
            UIFont *font = [UIFont systemFontOfSize:15];
            CGSize textSize = [tempItem.title sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeClip];
            textSize.width += 20;
            textSize.height = self.bounds.size.height - 10;
            [tempBtn.titleLabel setFont:font];
            [tempBtn setFrame:CGRectMake(curX, 5, textSize.width, textSize.height)];
            curX += textSize.width + 10;
            [tempBtn setBackgroundImage:[self getImageWith:_btnImageName] forState:UIControlStateNormal];
        }
        
        [tempBtn addTarget:tempItem.target action:tempItem.action forControlEvents:UIControlEventTouchUpInside];
        [result addObject:tempBtn];
    }
    return result;
}

- (NSMutableArray *)getRightBtnAray
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    UIViewController *tempVC = (UIViewController *)_topItem.currentViewController;
    NSArray *tempArray = tempVC.navigationItem.rightBarButtonItems;

    NSLog(@"you have %d right items", [tempArray count]);
    CGFloat curX = self.bounds.size.width;
    for (int i = 0; i < [tempArray count]; i++) {
        UIBarButtonItem *tempItem = [tempArray objectAtIndex:i];
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        if (tempItem.image) {
            [tempBtn setBackgroundImage:tempItem.image forState:UIControlStateNormal];
            CGSize imageSize = tempItem.image.size;
            CGFloat btnHeight = self.bounds.size.height - 10;
            CGSize btnSize = CGSizeMake(btnHeight*imageSize.width/imageSize.height, btnHeight);
            curX -= btnSize.width + 10;
            [tempBtn setFrame:CGRectMake(curX, 5, btnSize.width, btnSize.height)];
        }
        if (tempItem.title) {
            [tempBtn setTitle:tempItem.title forState:UIControlStateNormal];
            CGSize maxSize = CGSizeMake(90, self.bounds.size.height);
            UIFont *font = [UIFont systemFontOfSize:15];
            CGSize textSize = [tempItem.title sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeClip];
            textSize.width += 20;
            textSize.height = self.bounds.size.height - 10;
            curX -= textSize.width + 10;
            [tempBtn.titleLabel setFont:font];
            [tempBtn setFrame:CGRectMake(curX, 5, textSize.width, textSize.height)];
            [tempBtn setBackgroundImage:[self getImageWith:_btnImageName] forState:UIControlStateNormal];
        }
        
        [tempBtn addTarget:tempItem.target action:tempItem.action forControlEvents:UIControlEventTouchUpInside];
        [result addObject:tempBtn];
    }
    return result;
}

- (void)setupBackBtnWithActionType:(NSInteger)type WithAnimated:(BOOL)animated
{
    if (_topItem.backButtonTitle) {
        if (_backBtn == nil) {
            _backBtn = [self getBackBtn];
            [self addSubview:_backBtn];
            [_backBtn setAlpha:0.0f];
        }
        if (animated) {
            UIButton *tempBtn = [self getBackBtn];
            [tempBtn setTitle:_topItem.backButtonTitle forState:UIControlStateNormal];
            
            [self addSubview:tempBtn];
            [tempBtn setAlpha:0.0f];
            [tempBtn setFrame:_backBtn.frame];
            CGFloat xOffset = 0;
            switch (type) {
                case ALNavigationActionTypePush:{
                    xOffset = self.bounds.size.width/2;
                }break;
                case ALNavigationActionTypePop:{
                    xOffset = -self.bounds.size.width/2;
                }break;
                default:
                    break;
            }
            [tempBtn setCenter:CGPointMake(_backBtn.center.x + xOffset, _backBtn.center.y)];
            
            [UIView animateWithDuration:0.3f animations:^{
                [tempBtn setCenter:CGPointMake(_backBtn.center.x, _backBtn.center.y)];
                [tempBtn setAlpha:1.0f];
                [_backBtn setCenter:CGPointMake(_backBtn.center.x -xOffset, _backBtn.center.y)];
                [_backBtn setAlpha:0.4f];
            } completion:^(BOOL finished) {
                [_backBtn removeFromSuperview];
                _backBtn = tempBtn;
            }];
        }
        else {
            [UIView animateWithDuration:0.3f animations:^{
                [_backBtn setTitle:_topItem.backButtonTitle forState:UIControlStateNormal];
                [_backBtn setAlpha:1.0f];
            }];
        }
    }
    else {
        if (_backBtn) {
            [UIView animateWithDuration:0.3f animations:^{
                [_backBtn setAlpha:0.0f];
            }];
        }
    }
}

- (void)setupTitleWithActionType:(NSInteger)type WithAnimated:(BOOL)animated
{
    if (_topItem.title) {
        if (_titleLabel == nil) {
            _titleLabel = [self getTitleLabel];
            [self addSubview:_titleLabel];
        }
        if (animated) {
            UILabel *tempLabel = [self getTitleLabel];
            [tempLabel setText:_topItem.title];
            [self addSubview:tempLabel];
            [tempLabel setAlpha:0.0f];
            [tempLabel setFrame:_titleLabel.frame];
            CGFloat xOffset = 0;
            switch (type) {
                case ALNavigationActionTypePush:{
                    xOffset = self.bounds.size.width/2;
                }break;
                case ALNavigationActionTypePop:{
                    xOffset = -self.bounds.size.width/2;
                }break;
                default:
                    break;
            }
            [tempLabel setCenter:CGPointMake(_titleLabel.center.x + xOffset, _titleLabel.center.y)];
            
            [UIView animateWithDuration:0.3f animations:^{
                [tempLabel setCenter:CGPointMake(_titleLabel.center.x, _titleLabel.center.y)];
                [tempLabel setAlpha:1.0f];
                [_titleLabel setCenter:CGPointMake(_titleLabel.center.x -xOffset, _titleLabel.center.y)];
                [_titleLabel setAlpha:0.4f];
            } completion:^(BOOL finished) {
                [_titleLabel removeFromSuperview];
                [_titleLabel release];
                _titleLabel = tempLabel;
            }];   
        }
        else {
            [_titleLabel setText:_topItem.title];
        }
    }
    else {
        if (_titleLabel) {
            [UIView animateWithDuration:0.3f animations:^{
                [_titleLabel setAlpha:0.0f];
            }];
        }
    }
}

- (void)setupLeftItemsWithActionType:(NSInteger)type WithAnimated:(BOOL)animated
{
    if (_topItem.currentViewController) {
        if (_leftItems) {
            [UIView animateWithDuration:0.1f animations:^{
                for (UIButton *tempBtn in _leftItems) {
                    [tempBtn setAlpha:0.5f];
                }
            }];
            for (UIButton *tempBtn in _leftItems) {
                [tempBtn removeFromSuperview];
            }
        }
        _leftItems = [self getLeftBtnAray];
        for (UIButton *tempBtn in _leftItems) {
            [tempBtn setAlpha:0.5f];
            [self addSubview:tempBtn];
        }
        [UIView animateWithDuration:0.2f animations:^{
            for (UIButton *tempBtn in _leftItems) {
                [tempBtn setAlpha:1.0f];
            }
        }];
    }
}

- (void)setupRightItemsWithActionType:(NSInteger)type WithAnimated:(BOOL)animated
{
    if (_topItem.currentViewController) {
        if (_rightItems) {
            [UIView animateWithDuration:0.1f animations:^{
                for (UIButton *tempBtn in _rightItems) {
                    [tempBtn setAlpha:0.5f];
                }
            }];
            for (UIButton *tempBtn in _rightItems) {
                [tempBtn removeFromSuperview];
            }
        }
        _rightItems = [self getRightBtnAray];
        for (UIButton *tempBtn in _rightItems) {
            [tempBtn setAlpha:0.5f];
            [self addSubview:tempBtn];
        }
        [UIView animateWithDuration:0.2f animations:^{
            for (UIButton *tempBtn in _rightItems) {
                [tempBtn setAlpha:1.0f];
            }
        }];
        
    }
}

#pragma mark -
- (void)setupWithActionType:(NSInteger) type WithAnimated:(BOOL)animated
{
    [self setupBackBtnWithActionType:type WithAnimated:animated];
    [self setupTitleWithActionType:type WithAnimated:animated];
    [self setupLeftItemsWithActionType:type WithAnimated:animated];
    [self setupRightItemsWithActionType:type WithAnimated:animated];
}

#pragma mark -
- (void)presentModalViewController:(ALNavigationItem *)item animated:(BOOL)animated
{
    if (item == nil) {
        return;
    }
    if (_backBtnType == ALNavigationBackBtnTypeGoBack) {
        [item setBackButtonTitle:ALNavigationGoBack];
    }
    else if (_backBtnType == ALNavigationBackBtnTypePreviousTitle) {
        [item setBackButtonTitle:_topItem.title];
    }
    _topItem = item;
    [self setupWithActionType:ALNavigationActionTypePush WithAnimated:animated];
}

- (void)pushNavigationItem:(ALNavigationItem *)item animated:(BOOL)animated
{
    if (item == nil) {
        return;
    }
    
    if (_items) {
        [_items addObject:item];
        if ([_items count] > 1) {
            if (_backBtnType == ALNavigationBackBtnTypeGoBack) {
                [item setBackButtonTitle:ALNavigationGoBack];
            }
            else if (_backBtnType == ALNavigationBackBtnTypePreviousTitle) {
               [item setBackButtonTitle:_topItem.title]; 
            }
        }
    }
    _topItem = item;
    [self setupWithActionType:ALNavigationActionTypePush WithAnimated:animated];
}

- (ALNavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    ALNavigationItem *result = nil;
    if (_items && [_items count] > 1) {
        [_items removeLastObject];
        result = [_items lastObject];
    }
    if (result) {
        _topItem = result;
        [self setupWithActionType:ALNavigationActionTypePop WithAnimated:animated];
    }
    return result;
}

@end
