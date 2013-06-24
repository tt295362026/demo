//
//  ALWaterFlowCell.m
//  ALWaterFlow
//
//  Created by andy on 13-5-29.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALWaterFlowCell.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - ALWaterFlowCell

@interface ALWaterFlowCell ()

@end

@implementation ALWaterFlowCell

@synthesize indexPath = _indexPath;
@synthesize reuseIdentifier = _reuseIdentifier;

@synthesize textView;
@synthesize imageView;

@synthesize contentView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setClipsToBounds:YES];
        self.reuseIdentifier = reuseIdentifier;
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[AsyImageView alloc] init];
        [self.imageView setDelegate:self];
        [self addSubview:self.imageView];
        
        self.textView = [[UILabel alloc] init];
        [self.textView setTextAlignment:UITextAlignmentCenter];
        [self.textView setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:0.6f]];
        [self addSubview:self.textView];
        
        self.contentView = [[UIView alloc] init];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.contentView];
                
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    [self.textView setFrame:CGRectMake(0, self.bounds.size.height - 15.0f, self.bounds.size.width, 15.0f)];
    [self.contentView setFrame:self.bounds];
    [self.imageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.imageView setBackgroundColor:[UIColor redColor]];
}

- (void)dealloc
{
    self.indexPath = nil;
    self.reuseIdentifier = nil;
    self.textView = nil;
    self.contentView = nil;
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALWaterFlowCellDidselected:)]) {
        [self.delegate ALWaterFlowCellDidselected:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setAlpha:1.0f];
}

- (void)clearContent
{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}

#pragma mark - AsyImageViewDelegate <NSObject>
- (void)AsyImageView:(AsyImageView*)view withSize:(CGSize)size
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALWaterFlowCell:WithSize:)]) {
        [self.delegate ALWaterFlowCell:self WithSize:size];
    }
}

@end

