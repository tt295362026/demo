//
//  AsyImageCache.h
//  ALWaterFlow
//
//  Created by andy on 13-6-3.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyImageCache : NSObject

@property (nonatomic, retain) NSMutableDictionary *imageDict;
@property (nonatomic) NSInteger maxCount;

+ (AsyImageCache *)getImageCache;

- (void)emptyCache;

- (BOOL)imageFromCacheWithURL:(NSString *)url;
- (UIImage *)imageWithURL:(NSString *)url;

- (void)cacheImage:(UIImage *)image WithUrl:(NSString *)url;


@end
