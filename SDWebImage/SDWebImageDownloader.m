/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDownloader.h"
#import "SDWebImageDecoder.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import <ImageIO/ImageIO.h>

#define kDownLoadTask_TempSuffix  @".TempDownload"
#define kEnableDuandian 1
#define kUseFileTempThreshold  1024000   //大于1m的文件使用文件缓存边下边写文件，小于1m的文件取消下载后写文件

@interface SDWebImageDownloader (ImageDecoder) <SDWebImageDecoderDelegate>
@end

NSString *const SDWebImageDownloadStartNotification = @"SDWebImageDownloadStartNotification";
NSString *const SDWebImageDownloadStopNotification = @"SDWebImageDownloadStopNotification";

@interface SDWebImageDownloader ()
@property (nonatomic, retain) NSURLConnection   *connection;
@property (nonatomic, retain) NSFileHandle      *fileHandle;
@property (nonatomic, retain) NSString          *destinationPath;
@property (nonatomic, retain) NSString          *tempPath;
@property (nonatomic, assign) BOOL				directWriteToTempFile;

@end

@implementation SDWebImageDownloader
@synthesize url, delegate, connection, imageData, userInfo, lowPriority, progressive, progressDisplay,fileHandle,destinationPath,tempPath, directWriteToTempFile;

#pragma mark Public Methods

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate
{
    return [self downloaderWithURL:url delegate:delegate userInfo:nil];
}

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo
{
    return [self downloaderWithURL:url delegate:delegate userInfo:userInfo lowPriority:NO];
}

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority
{
    // Bind SDNetworkActivityIndicator if available (download it here: http://github.com/rs/SDNetworkActivityIndicator )
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the SDWebImage import
    if (NSClassFromString(@"SDNetworkActivityIndicator"))
    {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id activityIndicator = [NSClassFromString(@"SDNetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
#pragma clang diagnostic pop
		
        // Remove observer in case it was previously added.
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStopNotification object:nil];
		
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:SDWebImageDownloadStopNotification object:nil];
    }
	
    SDWebImageDownloader *downloader = SDWIReturnAutoreleased([[SDWebImageDownloader alloc] init]);
    downloader.url = url;
    downloader.delegate = delegate;
    downloader.userInfo = userInfo;
    downloader.lowPriority = lowPriority;
    [downloader performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    return downloader;
}

+ (void)setMaxConcurrentDownloads:(NSUInteger)max
{
    // NOOP
}

- (void)start
{
    // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
	
    self.connection = SDWIReturnAutoreleased([[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO]);
	
    // If not in low priority mode, ensure we aren't blocked by UI manipulations (default runloop mode for NSURLConnection is NSEventTrackingRunLoopMode)
    if (!lowPriority)
    {
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
	
    [connection start];
    SDWIRelease(request);
	
    if (connection)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStartNotification object:nil];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)])
        {
            [delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:nil];
        }
    }
}

- (void)cancel
{
    if (connection)
    {
        [connection cancel];
        self.connection = nil;
#if kEnableDuandian
        //===================================================
        //add by xjy
		[self closeFileHandle];
		[self saveImageToTempWhenUnFinish];
		
        self.imageData = nil;
		
        //===================================================
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];
    }
}

#pragma mark NSURLConnection (delegate)
#if 1//zhoufei add for remove httpheaders
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSMutableURLRequest *newRequest = [request mutableCopy];
    if ([newRequest isKindOfClass:[NSMutableURLRequest class]])
    {
        [newRequest setValue:nil forHTTPHeaderField:@"Accept-Encoding"];
        [newRequest setValue:nil forHTTPHeaderField:@"Accept"];
        [newRequest setValue:nil forHTTPHeaderField:@"Accept-Language"];
		[newRequest setHTTPShouldHandleCookies:NO];
		
#if kEnableDuandian
		//===================================================
		//add by xjy
		// 目标地址与断点下载缓存地址
		self.destinationPath=[[SDImageCache sharedImageCache] cachePathForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
		self.tempPath=[self.destinationPath stringByAppendingFormat:kDownLoadTask_TempSuffix];
		
		//设置fileHandle
		[self closeFileHandle];
		
		//缓存文件不存在，则创建缓存文件
		unsigned long long offset = 0;
		if (![[NSFileManager defaultManager] fileExistsAtPath:self.tempPath])
		{
			BOOL createSucces = [[NSFileManager defaultManager] createFileAtPath:self.tempPath contents:nil attributes:nil];
			if (!createSucces)
			{
				if ([delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)])
				{
					[delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:nil];
				}
				return [newRequest autorelease];
			}
		}
		else 
		{
			NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:self.tempPath];
			offset = [fh seekToEndOfFile];
			[fh closeFile];
			
            if (offset > 0)
            {
                NSString *range = [NSString stringWithFormat:@"bytes=%llu-",offset];
                NSLog(@"Range =%@",range);
                //设置下载的一些属性
                [newRequest setValue:range forHTTPHeaderField:@"Range"];
            }
		}
		
		//===================================================
#endif
    }
	
    return [newRequest autorelease];
}
#endif

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response
{
    
    directWriteToTempFile = NO;
	//修正路由器安全提示问题，by erlangZhang
	BOOL isImageType = NO;
	
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)
    {
		NSString* dataType = [response MIMEType];
		if ([dataType hasPrefix:@"image/"])
		{
			isImageType = YES;
		}
	}
    if (isImageType)
    {
#if kEnableDuandian
        //===================================================
        //add by xjy
        expectedSize = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
        totalSize = expectedSize;
        
        if (![[response URL] isFileURL] && [response respondsToSelector:@selector(allHeaderFields)])
        {
            NSDictionary* headDic = [(NSHTTPURLResponse *)response allHeaderFields];
            NSString* contentRangeStr = [headDic objectForKey:@"Content-Range"];
            if ([contentRangeStr length])
            {
                NSInteger indexOfSeparator=[contentRangeStr rangeOfString:@"/"].location;
                if (indexOfSeparator != NSNotFound)
                {
                    totalSize = [[contentRangeStr substringFromIndex:indexOfSeparator+1] longLongValue];
                }
            }
            
            totalSize = totalSize <= 0 ? expectedSize : totalSize;
            NSLog(@"total Size = %d",totalSize);
            self.imageData = nil;
            
            //待下载的大小超出阈值，使用文件，放弃内存
            [self closeFileHandle];
            
            if(totalSize>kUseFileTempThreshold)
            {
				directWriteToTempFile = YES;
                //write to file
                self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempPath];
                [self.fileHandle seekToEndOfFile];
                //不关闭文件了，每次接到新数据都要写
                //[self.fileHandle closeFile];
            }
            else
            {
                self.imageData = SDWIReturnAutoreleased([[NSMutableData alloc] initWithCapacity:totalSize]);
                NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:self.tempPath];
                [self.imageData appendData:[fh readDataToEndOfFile]];
                [fh closeFile];
            }
            //===================================================
        }
        else
        {
            self.imageData = SDWIReturnAutoreleased([[NSMutableData alloc] initWithCapacity:totalSize]);
        }

#else
        expectedSize = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
		totalSize = expectedSize;
        self.imageData = SDWIReturnAutoreleased([[NSMutableData alloc] initWithCapacity:expectedSize]);
#endif
    }
    else
    {
        [aConnection cancel];
		
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];
		
        if ([delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)])
        {
            NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain
                                                        code:[((NSHTTPURLResponse *)response) statusCode]
                                                    userInfo:nil];
            [delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:error];
            SDWIRelease(error);
        }
		
        self.connection = nil;
        self.imageData = nil;
    }
}

-(NSUInteger)downloadedSize
{
    if (directWriteToTempFile)
	{
		return self.fileHandle.offsetInFile;
	}
	return [imageData length];
}

-(void)closeFileHandle
{
	[self.fileHandle closeFile];
	self.fileHandle = nil;
}

-(void)saveImageToTempWhenUnFinish
{
	if (!directWriteToTempFile && [imageData length] && self.tempPath)
	{
		NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:self.tempPath];
		[fh truncateFileAtOffset:0];
		[fh writeData:imageData];
		[fh closeFile];
		self.tempPath = nil;
	}
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    //modified by xjy
    //[imageData appendData:data];
    
#if kEnableDuandian
    //===================================================
    //add by xjy
	if (directWriteToTempFile)
	{
		[self.fileHandle writeData:data];
	}
    else
    {
        [imageData appendData:data];
    }
    //===================================================
#else
    [imageData appendData:data];
#endif
	
	//===================================================
	//add by erlangZhang
	if (self.progressDisplay && totalSize > 0 && [delegate respondsToSelector:@selector(imageDownloader:totalSize:receiveSize:)])
	{
		[delegate imageDownloader:self totalSize:totalSize receiveSize:[self downloadedSize]];
	}
	//===================================================
    
    if (CGImageSourceCreateImageAtIndex == NULL)
    {
        // ImageIO isn't present in iOS < 4
        self.progressive = NO;
    }
	
    if (self.progressive && expectedSize > 0 && [imageData length] && [delegate respondsToSelector:@selector(imageDownloader:didUpdatePartialImage:)])
    {
        // The following code is from http://www.cocoaintheshell.com/2011/05/progressive-images-download-imageio/
        // Thanks to the author @Nyx0uf
		
        // Get the total bytes downloaded
        const NSUInteger downLoadSize = [imageData length];
		
        // Update the data source, we must pass ALL the data, not just the new bytes
        CGImageSourceRef imageSource = CGImageSourceCreateIncremental(NULL);
#if __has_feature(objc_arc)
        CGImageSourceUpdateData(imageSource, (__bridge  CFDataRef)imageData, downLoadSize == expectedSize);
#else
        CGImageSourceUpdateData(imageSource, (CFDataRef)imageData, downLoadSize == expectedSize);
#endif
		
        if (width + height == 0)
        {
            CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
            if (properties)
            {
                CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &height);
                val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &width);
                CFRelease(properties);
            }
        }
		
        if (width + height > 0 && downLoadSize < expectedSize)
        {
            // Create the image
            CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
			
#ifdef TARGET_OS_IPHONE
            // Workaround for iOS anamorphic image
            if (partialImageRef)
            {
                const size_t partialHeight = CGImageGetHeight(partialImageRef);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
                CGColorSpaceRelease(colorSpace);
                if (bmContext)
                {
                    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = partialHeight}, partialImageRef);
                    CGImageRelease(partialImageRef);
                    partialImageRef = CGBitmapContextCreateImage(bmContext);
                    CGContextRelease(bmContext);
                }
                else
                {
                    CGImageRelease(partialImageRef);
                    partialImageRef = nil;
                }
            }
#endif
			
            if (partialImageRef)
            {
                UIImage *image = SDScaledImageForPath(url.absoluteString, [UIImage imageWithCGImage:partialImageRef]);
                [[SDWebImageDecoder sharedImageDecoder] decodeImage:image
                                                       withDelegate:self
                                                           userInfo:[NSDictionary dictionaryWithObject:@"partial" forKey:@"type"]];
				
                CGImageRelease(partialImageRef);
            }
        }
		
        CFRelease(imageSource);
    }
}

#pragma GCC diagnostic ignored "-Wundeclared-selector"
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    self.connection = nil;
	
#if kEnableDuandian
    //===================================================
    //add by xjy
    //下完以后统一使用imageData回调delegate，所以将文件内容读入内存
	[self closeFileHandle];
	if (directWriteToTempFile)
	{
		self.imageData = SDWIReturnAutoreleased([[NSMutableData alloc] initWithCapacity:totalSize]);
		NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:self.tempPath];
		[imageData appendData:[fh readDataToEndOfFile]];
		[fh closeFile];
	}
    
    //删除temp文件
    [[NSFileManager defaultManager] removeItemAtPath:self.tempPath error:nil];
	self.tempPath = nil;
    
    //===================================================
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];
	
    if ([delegate respondsToSelector:@selector(imageDownloaderDidFinish:)])
    {
        [delegate performSelector:@selector(imageDownloaderDidFinish:) withObject:self];
    }
	
    if ([delegate respondsToSelector:@selector(imageDownloader:didFinishWithImage:)])
    {
        UIImage *image = SDScaledImageForPath(url.absoluteString, imageData);
        [[SDWebImageDecoder sharedImageDecoder] decodeImage:image withDelegate:self userInfo:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#if kEnableDuandian
    //===================================================
    //add by xjy
	[self closeFileHandle];
	[self saveImageToTempWhenUnFinish];
	
    //===================================================
#endif
	
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];
	
    if ([delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)])
    {
        [delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:error];
    }
	
    self.connection = nil;
    self.imageData = nil;
}

#pragma mark SDWebImageDecoderDelegate

- (void)imageDecoder:(SDWebImageDecoder *)decoder didFinishDecodingImage:(UIImage *)image userInfo:(NSDictionary *)aUserInfo
{
    if ([[aUserInfo valueForKey:@"type"] isEqualToString:@"partial"])
    {
        [delegate imageDownloader:self didUpdatePartialImage:image];
    }
    else
    {
        [delegate performSelector:@selector(imageDownloader:didFinishWithImage:) withObject:self withObject:image];
    }
}

#pragma mark NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self closeFileHandle];
	[self saveImageToTempWhenUnFinish];
	SDWISafeRelease(destinationPath);
	SDWISafeRelease(tempPath);
    SDWISafeRelease(url);
    SDWISafeRelease(connection);
    SDWISafeRelease(imageData);
    SDWISafeRelease(userInfo);
    SDWISuperDealoc;
}


@end