//
//  ALLoadingMoreView.m
//  ALHotSaleViewController
//
//  Created by andy on 13-6-4.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALLoadingMoreView.h"

@interface ALLoadingMoreView()

@end

@implementation ALLoadingMoreView

@synthesize loadingView;
@synthesize loadingLabel;
@synthesize loadingAIV;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.loadingView = [[UIView alloc] init];
        [self.loadingView setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:0.6f]];
        [self.loadingView setClipsToBounds:YES];
        [self addSubview:self.loadingView];
        
        self.loadingAIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.loadingView addSubview:self.loadingAIV];
        
        self.loadingLabel = [[UILabel alloc] init];
        [self.loadingLabel setTextColor:[UIColor whiteColor]];
        [self.loadingLabel setBackgroundColor:[UIColor clearColor]];
        [self.loadingLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.loadingLabel setText:@"更多内容正在加载中，请稍候..."];
        [self.loadingLabel setTextAlignment:UITextAlignmentCenter];
        [self.loadingView addSubview:self.loadingLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.loadingView) {
        [self.loadingView setFrame:self.bounds];
    }
    if (self.loadingLabel) {
        [self.loadingLabel setFrame:CGRectMake(0, 0, self.bounds.size.width - 40, self.bounds.size.height)];
    }
    if (self.loadingAIV) {
        [self.loadingAIV setFrame:CGRectMake(0, 0, 37, 37)];
        self.loadingAIV.center = CGPointMake(self.bounds.size.width - 20, self.bounds.size.height/2);
    }
}

- (void)startLoading
{
    [self.loadingView setHidden:NO];
    [self.loadingAIV startAnimating];
}

- (void)stopLoading
{
    [self.loadingView setHidden:YES];
    [self.loadingAIV stopAnimating];
}

@end
