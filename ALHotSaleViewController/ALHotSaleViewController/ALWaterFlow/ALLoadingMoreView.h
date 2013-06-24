//
//  ALLoadingMoreView.h
//  ALHotSaleViewController
//
//  Created by andy on 13-6-4.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>



#define LOADINGMOREVIEW_HEIGHT 60.0f

@interface ALLoadingMoreView : UIView

@property (nonatomic, retain) UIView *loadingView;

@property (nonatomic, retain) UIActivityIndicatorView *loadingAIV;

@property (nonatomic, retain) UILabel *loadingLabel;

- (void)startLoading;

- (void)stopLoading;

@end
