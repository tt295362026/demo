//
//  AsyImageDownloader.h
//  AsyImageDownloader
//
//  Created by andy on 13-5-31.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "AsyImageCache.h"

#pragma mark - name operation
static inline char asyImageLoader_hexChar(unsigned char c);
static inline void asyImageLoader_hexString(unsigned char *from, char *to, NSUInteger length);
NSString * asyImageLoader_sha(const char *string);

@class AsyImageLoader;

typedef NS_ENUM(NSInteger, AsyImageLoaderPolicy)
{
    AsyImageLoaderPolicyAsyn = 0,
    AsyImageLoaderPolicySyn = 1,
    AsyImageLoaderPolicyDefault = AsyImageLoaderPolicyAsyn
};

#pragma mark - AsyImageLoaderDelegate
@protocol AsyImageLoaderDelegate <NSObject>

- (void)AsyImageLoader:(AsyImageLoader *)loader finishedLoadingImage:(UIImage *)image;
- (void)AsyImageLoaderFailLoadingImage:(AsyImageLoader *)loader;

@end

#pragma mark - AsyImageLoader
@interface AsyImageLoader : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSString *_imageFile;
    AsyImageCache *_imageCache;
    NSInteger _loadPolicy;
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSURLConnection *connection;

@property (nonatomic, retain) NSMutableData *receivedData;

@property (nonatomic, retain) NSString *currentMIMEType;

@property (nonatomic, retain) NSString *target;

- (void)loadImageWithDelegate:(id)aDelegate WithPath:(NSString *)path;

- (void)loadImageWithDelegate:(id)aDelegate WithArray:(NSArray *)pathArray;

@end
