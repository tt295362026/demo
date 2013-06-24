//
//  ALRefleshView.h
//  ALHotSaleViewController
//
//  Created by andy on 13-6-5.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ALRefleshType)
{
    ALRefleshTypeReadyToLoad,
    ALRefleshTypeNotReadyToLoad,
    ALRefleshTypeLoading
};

#define REFLESHVIEW_HEIGHT 60.0f

@interface ALRefleshView : UIView
{
    NSInteger _state;
}

@property (nonatomic) NSInteger state;

/*hint compontent*/
@property (nonatomic, retain) UIView *refleshView;

@property (nonatomic, retain) UILabel *refleshMainLabel;

@property (nonatomic, retain) UILabel *refleshSubLabel;

@property (nonatomic, retain) UIImageView *refleshArrow;

/*loading compontent*/
@property (nonatomic, retain) UIActivityIndicatorView *loadingAIV;

- (void)refleshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end