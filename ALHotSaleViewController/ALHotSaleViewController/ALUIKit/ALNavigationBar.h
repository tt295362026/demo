//
//  ALNavigationBar.h
//  ALUIViewController
//
//  Created by andy on 13-4-28.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNavigationItem.h"

/*
 Used to determine the navigation action.
 */
typedef NS_ENUM(NSInteger, ALNavigationActionType)
{
    ALNavigationActionTypePush = 0,
    ALNavigationActionTypePop,
    ALNavigationActionTypeUpdate
};

/*
 Used to define the title of the back button.
 */
typedef NS_ENUM(NSInteger, ALNavigationBackBtnType)
{
    ALNavigationBackBtnTypePreviousTitle,
    ALNavigationBackBtnTypeGoBack
};

#define ALNavigationGoBack @"返回"

@interface ALNavigationBar : UIView
{
    id _delegate;
    
    UIView  *_backgroundView;
    UILabel *_titleLabel;
    
    UIButton *_backBtn;
    NSInteger _backBtnType;
    
    NSMutableArray *_leftItems;
    NSMutableArray *_rightItems;
    
    NSMutableArray *_items;
    ALNavigationItem *_topItem;
    ALNavigationItem *_backItem;
    
    NSString *_bgImageName;
    NSString *_backBtnImageName;
    NSString *_btnImageName;
}

@property (nonatomic, assign) id delegate;

- (void)setupWithActionType:(NSInteger)direction WithAnimated:(BOOL)animated;

@property (nonatomic, retain) NSString *bgImageName;
@property (nonatomic, retain) NSString *backBtnImageName;
@property (nonatomic, retain) NSString *btnImageName;

/*
 This is used to do the same action as the UINavigationBar.
 */
- (void)presentModalViewController:(ALNavigationItem *)item animated:(BOOL)animated;
- (void)pushNavigationItem:(ALNavigationItem *)item animated:(BOOL)animated;
- (ALNavigationItem *)popNavigationItemAnimated:(BOOL)animated;

@property (nonatomic,readonly,retain) ALNavigationItem *topItem;
@property (nonatomic,readonly,retain) ALNavigationItem *backItem;

@property(nonatomic,copy) NSMutableArray *items;

@end
