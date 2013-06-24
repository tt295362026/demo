//
//  AsyImageCache.m
//  ALWaterFlow
//
//  Created by andy on 13-6-3.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "AsyImageCache.h"

#define MAX_CACHED_COUNT 100

static AsyImageCache *sharedAsyImageCache;

@implementation AsyImageCache

@synthesize imageDict;
@synthesize maxCount;


+ (AsyImageCache *)getImageCache
{
    @synchronized(self)
    {
        if (sharedAsyImageCache == nil)
        {
            sharedAsyImageCache = [[self alloc] init];
        }
    }
    return sharedAsyImageCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.imageDict = [[NSMutableDictionary alloc] init];
        self.maxCount = MAX_CACHED_COUNT;
    }
    return self;
}

- (void)dealloc
{
    self.imageDict = nil;
    [super dealloc];
}

- (void)emptyCache
{
    for (int i = 0; i < self.imageDict.allKeys.count/2; i++) {
        NSString *tempKey = [self.imageDict.allKeys objectAtIndex:i];
        [self.imageDict removeObjectForKey:tempKey];
    }
}

- (BOOL)imageFromCacheWithURL:(NSString *)url
{
    if (url == nil) {
        return NO;
    }
    return ([self.imageDict objectForKey:url] != nil);
}

- (UIImage *)imageWithURL:(NSString *)url
{
    if (url.length == 0)
        return nil;

    UIImage *image = nil;
    if ((image = [self.imageDict objectForKey:url])) {
        return image;
    }
    return nil;
}

- (void)cacheImage:(UIImage *)image WithUrl:(NSString *)url
{
    if (url == nil)
        return;
    
    if ([self.imageDict.allValues count] > self.maxCount) {
        [self emptyCache];
    }
    
    if (image) {
        [self.imageDict setObject:image forKey:url];
    }
}

@end
