//
//  AsyImageView.h
//  AsyImageDownloader
//
//  Created by andy on 13-5-31.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyImageLoader.h"

@class AsyImageView;

typedef NS_ENUM(NSInteger, AsyImageViewType) {
    AsyImageViewTypeFilled = 0,
    AsyImageViewTypeScaled = 1,
    AsyImageViewTypeFixedHeight = 2,
    AsyImageViewTypeFixedWidth = 3,
    AsyImageViewTypeFixedDefault = AsyImageViewTypeFilled
};

@protocol AsyImageViewDelegate <NSObject>

- (void)AsyImageView:(AsyImageView*)view withSize:(CGSize)size;

@end

@interface AsyImageView : UIView <AsyImageLoaderDelegate>
{
    UIImage *_image;
    
    NSInteger _imageType;
    
    NSString *_placeHolderName;
    UIImage *_placeHolder;
}

@property (nonatomic, assign) id <AsyImageViewDelegate> delegate;

- (id)initWithImage:(UIImage *)image;

- (void)loadImageWithPath:(NSString *)path andPlaceHolderName:(NSString *)phName;

@property (nonatomic) NSInteger imageType;

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UIImage *image; // default is nil

@property (nonatomic, retain) NSString *placeHolderName;     // default is nil
@property (nonatomic, retain) UIImage *placeHolder;  // default is nil

@property (nonatomic,retain) UIActivityIndicatorView *loadingView;

@property (nonatomic,retain) AsyImageLoader *imageLoader;

@end
