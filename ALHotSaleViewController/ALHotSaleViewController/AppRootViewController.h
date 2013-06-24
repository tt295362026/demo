//
//  AppRootViewController.h
//  ALHotSaleViewController
//
//  Created by andy on 13-6-3.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUIKit.h"
#import "ALHotSaleViewController.h"
#import "ALWaterFlowVC.h"

@interface AppRootViewController : UIViewController
{
    ALUINavigationController *_hotNav;
    ALHotSaleViewController *_hotVC;
    
    UIView *_categoryView;
    ALUINavigationController *_categoryNav;
    ALUIViewController *_categoryVC;
}



@end
