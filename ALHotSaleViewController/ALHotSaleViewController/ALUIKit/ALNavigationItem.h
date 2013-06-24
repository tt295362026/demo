//
//  ALNavigationItem.h
//  ALUIViewController
//
//  Created by andy on 13-4-28.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALBarItem;

@interface ALNavigationItem : NSObject
{
    NSString        *_title;
    NSString        *_backButtonTitle;
    
    ALBarItem       *_backBarButtonItem;

    NSArray         *_leftBarButtonItems;
    NSArray         *_rightBarButtonItems;
    
    BOOL             _hidesBackButton;
    BOOL             _leftItemsSupplementBackButton;    
}

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *backButtonTitle;

@property (nonatomic, retain) NSArray   *leftBarButtonItems;
@property (nonatomic, retain) NSArray   *rightBarButtonItems;

@property (nonatomic, assign) UIViewController *currentViewController;

@end
