//
//  AppRootViewController.m
//  ALHotSaleViewController
//
//  Created by andy on 13-6-3.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "AppRootViewController.h"

@implementation AppRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _hotVC = [[ALHotSaleViewController alloc] init];
        _hotNav = [[ALUINavigationController alloc] initWithRootViewController:_hotVC];
        [_hotNav setBgImageName:@"bg_darkyellow.png"];
        [_hotNav setBtnImageName:@"btn_darkyellow.png"];
        [_hotNav setBackBtnImageName:@"backbtn_darkred.png"];
        [_hotVC setTitle:@"热销榜"];
        [self.view addSubview:_hotNav.view];
        [_hotNav.view setFrame:self.view.bounds];
        
        UIBarButtonItem *tempItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(OnCategoryOpen)];
        _hotVC.navigationItem.leftBarButtonItem = tempItem;
        
        _categoryView = [[UIView alloc] init];
        [_categoryView setFrame:CGRectMake(0.0f, 0.0f, 100.0f, self.view.bounds.size.height)];
        UIButton *temp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [temp setTitle:@"你好" forState:UIControlStateNormal];
        [_categoryView addSubview:temp];
        [temp setFrame:CGRectMake(20, 40, 50, 50)];
        
        
        _categoryVC = [[ALUIViewController alloc] init];
        [_categoryVC setTitle:@"分类"];
        [_categoryVC setView:_categoryView];
        _categoryNav = [[ALUINavigationController alloc] initWithRootViewController:_categoryVC];
        [self.view addSubview:_categoryNav.view];
        [_categoryNav.view setFrame:CGRectMake(- 100.0f, self.view.bounds.origin.y, 100.0f, self.view.bounds.size.height)];
    }
    return self;
}

- (void)OnCategoryOpen
{
    CGPoint tempCenter1 = _hotNav.view.center;
    CGPoint tempCenter2 = _categoryNav.view.center;
    [UIView animateWithDuration:0.3f animations:^{
        _hotNav.view.center = CGPointMake(tempCenter1.x + 100, tempCenter1.y);
        _categoryNav.view.center = CGPointMake(tempCenter2.x + 100, tempCenter2.y);
    } completion:^(BOOL finished) {
        UIBarButtonItem *tempItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(OnCategoryClose)] autorelease];
        _hotVC.navigationItem.leftBarButtonItem = tempItem;
    }];
}

- (void)OnCategoryClose
{
    CGPoint tempCenter1 = _hotNav.view.center;
    CGPoint tempCenter2 = _categoryNav.view.center;
    [UIView animateWithDuration:0.3f animations:^{
        _hotNav.view.center = CGPointMake(tempCenter1.x - 100, tempCenter1.y);
        _categoryNav.view.center = CGPointMake(tempCenter2.x - 100, tempCenter2.y);
    } completion:^(BOOL finished) {
        UIBarButtonItem *tempItem = [[[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(OnCategoryOpen)] autorelease];
        _hotVC.navigationItem.leftBarButtonItem = tempItem;
    }];
}
@end
