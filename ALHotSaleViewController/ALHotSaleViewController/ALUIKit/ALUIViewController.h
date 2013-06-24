//
//  ALUIViewController.h
//  ALUIViewController
//
//  Created by andy on 13-4-27.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNavigationItem.h"

@interface ALUIViewController : UIViewController
{
    ALNavigationItem *_customNavigationItem;
}

@property (nonatomic, readonly) ALNavigationItem *customNavigationItem;

@property (nonatomic, assign) id customNavigationController;

@end
