//
//  AsyImageView.m
//  AsyImageDownloader
//
//  Created by andy on 13-5-31.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "AsyImageView.h"

@interface AsyImageView ()

- (void)layoutNow;
- (CGRect)getRectWithType:(NSInteger)type WithImage:(UIImage *)image;

- (void)AsyImageStartLoading;
- (void)AsyImageStopLoading;

@end

@implementation AsyImageView

@synthesize delegate;

@synthesize imageView;

@synthesize image = _image;

@synthesize placeHolder = _placeHolder;
@synthesize placeHolderName;

@synthesize loadingView;

@synthesize imageType = _imageType;

@synthesize imageLoader;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _imageType = AsyImageViewTypeFixedDefault;
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.loadingView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithImage:(UIImage *)aImage
{
    self = [self init];
    if (self) {
        // Initialization code
        self.image = aImage;
    }
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    self.loadingView = nil;
    self.imageLoader = nil;
    [super dealloc];
}

- (CGRect)getRectWithType:(NSInteger)type WithImage:(UIImage *)image
{
    CGRect result = CGRectMake(0, 0, 0, 0);
    assert(image !=nil);
    if (image) {
        switch (type) {
            case AsyImageViewTypeFilled:{
                result.size = self.bounds.size;
            }break;
            case AsyImageViewTypeScaled:{
                CGFloat wholeWHRat = self.bounds.size.width/self.bounds.size.height;
                CGFloat tempWHRat = image.size.width/image.size.height;
                
                if (tempWHRat > wholeWHRat) {
                    result.size.width = self.bounds.size.width;
                    result.size.height = self.bounds.size.width/tempWHRat;
                }
                else {
                    result.size.height = self.bounds.size.height;
                    result.size.width = self.bounds.size.height*tempWHRat;
                }
            }break;
            case AsyImageViewTypeFixedWidth:{
            }break;
            case AsyImageViewTypeFixedHeight:{
            }break;
            default:
                break;
        }
    }
    return result;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.loadingView setFrame:CGRectMake(0, 0, 50, 50)];
    [self.loadingView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    if (_image) {
        [self.imageView setFrame:[self getRectWithType:_imageType WithImage:_image]];
    }
    else if (_placeHolder) {
        [self.imageView setFrame:[self getRectWithType:_imageType WithImage:_placeHolder]];
    }
    [self.imageView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_image) {
        [self.imageView setFrame:[self getRectWithType:_imageType WithImage:_image]];
    }
    else if (_placeHolder) {
        [self.imageView setFrame:[self getRectWithType:_imageType WithImage:_placeHolder]];
    }
    [self.imageView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
}

- (void)layoutNow
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setImageType:(NSInteger)aImageType
{
    _imageType = aImageType;
    [self layoutNow];
}

- (void)setPlaceHolderName:(NSString *)aPlaceHolderName
{
    _placeHolderName = aPlaceHolderName;
    [self setPlaceHolder:[UIImage imageNamed:aPlaceHolderName]];
}

- (void)setImage:(UIImage *)aImage
{
    _image = aImage;
    [self.imageView setImage:aImage];
    [self layoutNow];
    [self.imageView setAlpha:0.0f];
}

- (void)setPlaceHolder:(UIImage *)aPlaceHolder
{
    _placeHolder = aPlaceHolder;
    [self.imageView setImage:aPlaceHolder];
    [self layoutNow];
}

- (void)AsyImageStartLoading
{
    [self.loadingView startAnimating];
    [self.loadingView setHidden:NO];
}

- (void)AsyImageStopLoading
{
    [self.loadingView stopAnimating];
    [self.loadingView setHidden:YES];
}

- (void)loadImageWithPath:(NSString *)path andPlaceHolderName:(NSString *)phName
{
    if (_image) {
        _image = nil;
    }
    [self setPlaceHolderName:phName];

    if (self.imageLoader == nil) {
        self.imageLoader = [[AsyImageLoader alloc] init];
    }
    [self.imageLoader loadImageWithDelegate:self WithPath:path];
}

#pragma mark - AsyImageLoaderDelegate <NSObject>
- (void)AsyImageLoader:(AsyImageLoader *)loader finishedLoadingImage:(UIImage *)image
{
    if (_image) {
        _image = nil;
    }
    [self setImage:image];
    [UIView animateWithDuration:0.2f animations:^{
        [self.imageView setAlpha:1.0f];
    }];
    
    [self AsyImageStopLoading];
    if (self.delegate && [self.delegate respondsToSelector:@selector(AsyImageView:withSize:)]) {
        if (self.image) {
            [self.delegate AsyImageView:self withSize:self.image.size];
        }
    }
}

- (void)AsyImageLoaderFailLoadingImage:(AsyImageLoader *)loader
{
    if (_placeHolderName) {
        [self setPlaceHolderName:_placeHolderName];
        [self AsyImageStopLoading];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(AsyImageView:withSize:)]) {
        if (self.placeHolder) {
            [self.delegate AsyImageView:self withSize:self.placeHolder.size];
        }
    }
}
@end
