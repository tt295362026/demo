//
//  ALRefleshView.m
//  ALHotSaleViewController
//
//  Created by andy on 13-6-5.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALRefleshView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALRefleshView

@synthesize state = _state;

@synthesize refleshView;
@synthesize refleshMainLabel;
@synthesize refleshSubLabel;
@synthesize refleshArrow;

@synthesize loadingAIV;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.refleshView = [[UIView alloc] init];
        [self.refleshView setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:0.6f]];
        [self.refleshView setClipsToBounds:YES];
        [self addSubview:self.refleshView];
        
        self.refleshMainLabel = [[UILabel alloc] init];
        [self.refleshMainLabel setTextColor:[UIColor whiteColor]];
        [self.refleshMainLabel setBackgroundColor:[UIColor clearColor]];
        [self.refleshMainLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.refleshMainLabel setText:@"刷新"];
        [self.refleshMainLabel setTextAlignment:UITextAlignmentCenter];
        [self.refleshView addSubview:self.refleshMainLabel];
        
        self.refleshSubLabel = [[UILabel alloc] init];
        [self.refleshSubLabel setTextColor:[UIColor whiteColor]];
        [self.refleshSubLabel setBackgroundColor:[UIColor clearColor]];
        [self.refleshSubLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.refleshSubLabel setTextAlignment:UITextAlignmentCenter];
        [self.refleshView addSubview:self.refleshSubLabel];
        
        self.refleshArrow = [[UIImageView alloc] init];
        [self.refleshArrow setBackgroundColor:[UIColor redColor]];
        [self.refleshView addSubview:self.refleshArrow];
        
        self.loadingAIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.refleshView addSubview:self.loadingAIV];
        [self setState:ALRefleshTypeNotReadyToLoad];
    }
    return self;
}

- (void)dealloc
{
    self.loadingAIV = nil;
    self.refleshMainLabel = nil;
    self.refleshSubLabel = nil;
    self.refleshView = nil;
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.refleshView) {
        [self.refleshView setFrame:self.bounds];
    }
    if (self.refleshMainLabel) {
        [self.refleshMainLabel setFrame:CGRectMake(40, 0, self.bounds.size.width - 80, self.bounds.size.height/2.0f)];
    }
    if (self.refleshSubLabel) {
        [self.refleshSubLabel setFrame:CGRectMake(40, self.bounds.size.height/2.0f, self.bounds.size.width - 80, self.bounds.size.height/2.0f)];
    }
    if (self.refleshArrow) {
        [self.refleshArrow setFrame:CGRectMake(0, 0, 40.0f, self.bounds.size.height)];
    }
    
    if (self.loadingAIV) {
        [self.loadingAIV setFrame:CGRectMake(0, 0, 37, 37)];
        self.loadingAIV.center = CGPointMake(20, self.bounds.size.height/2);
    }
}

- (void)setState:(NSInteger)aState
{
    _state = aState;
    switch (_state) {
        case ALRefleshTypeReadyToLoad:{
            [self.refleshArrow setHidden:NO];
            [self.loadingAIV setHidden:YES];
            [self.loadingAIV stopAnimating];
            [self.refleshSubLabel setText:@"松开刷新"];
            [UIView animateWithDuration:0.3f animations:^{
                self.refleshArrow.transform = CATransform3DGetAffineTransform(CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f));
            }];
        }break;
        case ALRefleshTypeNotReadyToLoad:{
            [self.refleshArrow setHidden:NO];
            [self.loadingAIV setHidden:YES];
            [self.loadingAIV stopAnimating];
            [self.refleshSubLabel setText:@"下拉刷新"];
            [UIView animateWithDuration:0.3f animations:^{
                self.refleshArrow.transform = CATransform3DGetAffineTransform(CATransform3DMakeRotation(0, 0.0f, 0.0f, 1.0f));
            }];
        }break;
        case ALRefleshTypeLoading:{
            [self.refleshSubLabel setText:@"正在加载中..."];
            [self.refleshArrow setHidden:YES];
            [self.loadingAIV setHidden:NO];
            [self.loadingAIV startAnimating];
        }break;
        default:
            break;
    }
}

- (void)startLoading
{
    [self.loadingAIV startAnimating];
}

- (void)stopLoading
{
    [self.loadingAIV stopAnimating];
}

- (void)refleshScrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.contentOffset.y > 0)
        return;
    if (scrollView.contentOffset.y < -50.0f && _state == ALRefleshTypeNotReadyToLoad) {
        [self setState:ALRefleshTypeReadyToLoad];
        return;
    }
    if (scrollView.contentOffset.y > -50.0f && _state == ALRefleshTypeReadyToLoad) {
        [self setState:ALRefleshTypeNotReadyToLoad];
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    
	if (scrollView.contentOffset.y <= - 40.0f && !_loading) {
		[self setState:ALRefleshTypeLoading];
	}
}

@end
