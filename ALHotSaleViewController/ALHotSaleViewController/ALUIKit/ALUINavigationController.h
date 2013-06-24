//
//  ALUINavigationController.h
//  ALUIViewController
//
//  Created by andy on 13-4-27.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNavigationItem.h"
#import "ALNavigationBar.h"
#import "ALUIViewController.h"

@interface ALUINavigationController : UINavigationController <UINavigationBarDelegate>
{
    ALNavigationBar *_customNavigationBar;
    BOOL _isModal;
}

@property (nonatomic) BOOL isModal;

@property (nonatomic, retain) ALNavigationBar *customNavigationBar;

- (void)setBgImageName:(NSString *)bgImage;
- (void)setBackBtnImageName:(NSString *)backBtnImage;
- (void)setBtnImageName:(NSString *)btnImage;

- (void)updateNavigationBar;

@end
