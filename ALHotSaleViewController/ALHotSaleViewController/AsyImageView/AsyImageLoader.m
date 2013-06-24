//
//  AsyImageDownloader.m
//  AsyImageDownloader
//
//  Created by andy on 13-5-31.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "AsyImageLoader.h"

//globe c method
static inline char asyImageLoader_hexChar(unsigned char c) {
    return c < 10 ? '0' + c : 'a' + c - 10;
}

static inline void asyImageLoader_hexString(unsigned char *from, char *to, NSUInteger length) {
    for (NSUInteger i = 0; i < length; ++i) {
        unsigned char c = from[i];
        unsigned char cHigh = c >> 4;
        unsigned char cLow = c & 0xf;
        to[2 * i] = asyImageLoader_hexChar(cHigh);
        to[2 * i + 1] = asyImageLoader_hexChar(cLow);
    }
    to[2 * length] = '\0';
}

NSString * asyImageLoader_sha(const char *string) {
    static const NSUInteger LENGTH = 20;
    unsigned char result[LENGTH];
    if (string == nil) {
        return nil;
    }
    CC_SHA1(string, (CC_LONG)strlen(string), result);
    
    char hexResult[2 * LENGTH + 1];
    asyImageLoader_hexString(result, hexResult, LENGTH);
    
    return [NSString stringWithUTF8String:hexResult];
}

#pragma mark - AsyImageLoader
@interface AsyImageLoader ()

- (void)initializeImageFile;

- (void)startLoading;
- (void)stopLoading;

/*
 load image operation
 */
- (void)loadImageWithPath:(NSString *)path;


- (void)loadImageFromCacheWithPath:(NSString *)path;//From Cache

- (void)loadImageFromLocalWithPath:(NSString *)path;//From Local

- (void)loadImageFromWebWithPath:(NSString *)path;//From Web
/*
 sub operation from web
 */
- (void)SynloadImageFromWebWithPath:(NSString *)path;
- (void)AsynloadImageFromWebWithPath:(NSString *)path;


- (void)saveImageWithPath:(NSString *)path andWithData:(NSData *)data;

- (void)finishGettingData:(NSData *)data;
- (void)finishGettingWithImage:(UIImage *)image;
- (void)failGettingData;

@end


@implementation AsyImageLoader

@synthesize delegate;

@synthesize connection;

@synthesize receivedData;

@synthesize currentMIMEType;

@synthesize target;

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeImageFile];
        _loadPolicy = AsyImageLoaderPolicyDefault;
        _imageCache = [AsyImageCache getImageCache];
    }
    return self;
}

- (void)dealloc
{
    self.target = nil;
    [super dealloc];
}

- (void)initializeImageFile
{
    /* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _imageFile = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageFile"] retain];
//    NSLog(@"======================_imageFile:%@", _imageFile);
    
    /* check for existence of cache directory */
    if ([[NSFileManager defaultManager] fileExistsAtPath:_imageFile]) {
        return;
    }
    
    /* create a new cache directory */
    NSError * error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:_imageFile withIntermediateDirectories:NO attributes:nil error:&error]) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
}

- (void)startLoading
{
    if (self.target) {
        [self loadImageWithPath:self.target];
    }
}

- (void)stopLoading
{
    self.target = nil;
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
}

#pragma mark - image loading operation
- (void)loadImageWithPath:(NSString *)path
{
    NSString *fileEncodeName = asyImageLoader_sha([path UTF8String]);
    NSString *filePath = [[_imageFile stringByAppendingPathComponent:fileEncodeName] retain];
    
    if ([_imageCache imageFromCacheWithURL:path]) {
        [self loadImageFromCacheWithPath:path];
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        [self loadImageFromWebWithPath:path];
    }
    else {
        [self loadImageFromLocalWithPath:filePath];
    }
}

#pragma mark from Cache
- (void)loadImageFromCacheWithPath:(NSString *)path
{
    NSLog(@"======================From Cache");
    dispatch_async(dispatch_get_main_queue(), ^{    
        UIImage *image = nil; 
        if ((image = [_imageCache imageWithURL:path])) {
            [self finishGettingWithImage:image];
        }
        else {
            [self failGettingData];
        }
    });
}

#pragma mark from Local
- (void)loadImageFromLocalWithPath:(NSString *)path
{
    NSLog(@"======================From Local");
    dispatch_queue_t downloadQueue = dispatch_queue_create("paper image downloader", NULL);
    
    dispatch_async(downloadQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfFile:path];
            [self finishGettingData:imageData];
    });
    
    //一定要release!
    dispatch_release(downloadQueue);
}

#pragma mark from Web
- (void)loadImageFromWebWithPath:(NSString *)path
{
    switch (_loadPolicy) {
        case AsyImageLoaderPolicyAsyn:{
            [self AsynloadImageFromWebWithPath:path];
        }break;
        case AsyImageLoaderPolicySyn:{
            [self SynloadImageFromWebWithPath:path];
        }
        default:{
            [self SynloadImageFromWebWithPath:path];
        }break;
    }
}

- (void)SynloadImageFromWebWithPath:(NSString *)path
{
    NSLog(@"======================From SynChron Web");
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    dispatch_queue_t downloadQueue = dispatch_queue_create("paper image downloader", NULL);
    
    dispatch_async(downloadQueue, ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        assert(request != nil);
        
        NSError *error = nil;
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

        if (imageData) {
            [self saveImageWithPath:self.target andWithData:imageData];
        }
        [self finishGettingData:imageData];
    });
}

- (void)AsynloadImageFromWebWithPath:(NSString *)path
{
    NSLog(@"======================From AsynChron Web");
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //request
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    assert(request != nil);
    
    //creat connection
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    assert(self.connection != nil);
    
    [self.connection start];
}

- (void)saveImageWithPath:(NSString *)path andWithData:(NSData *)data
{
    if (path == nil) {
        return ;
    }
    NSString * fileEncodeName = asyImageLoader_sha([path UTF8String]);
//    NSLog(@"save fileEncodeName:%@",fileEncodeName);
    NSString * filePath = [[_imageFile stringByAppendingPathComponent:fileEncodeName] retain];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        /* file doesn't exist, so create it */
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    }
    else {
        if (data && [data length] > 0) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
        }
    }
}

- (void)finishGettingData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = nil;
        if (data) {
            if ((image = [UIImage imageWithData:data])) {
                [self finishGettingWithImage:image];
                return ;
            }
        }
        [self failGettingData];
    });
}

- (void)finishGettingWithImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![_imageCache imageFromCacheWithURL:self.target]) {
            [_imageCache cacheImage:image WithUrl:self.target];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AsyImageLoader:finishedLoadingImage:)]) {
            [self.delegate AsyImageLoader:self finishedLoadingImage:image];
        }
    });
}

- (void)failGettingData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (delegate && [delegate respondsToSelector:@selector(AsyImageLoaderFailLoadingImage:)]) {
            [delegate AsyImageLoaderFailLoadingImage:self];
        }
    });
}

#pragma mark - public Interface
- (void)loadImageWithDelegate:(id)aDelegate WithPath:(NSString *)path
{
    if (self.target) {
        self.target = nil;
    }
    self.target = [path copy];
    
    [self setDelegate:aDelegate];
    [self startLoading];
}

- (void)loadImageWithDelegate:(id)aDelegate WithArray:(NSArray *)pathArray
{
    [self startLoading];
}

#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    assert(theConnection == self.connection);

    self.currentMIMEType = [response MIMEType];
    if (self.receivedData == nil) {
        self.receivedData = [[NSMutableData alloc] initWithLength:0];
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    assert(theConnection == self.connection);
    if (self.receivedData == nil) {
        self.receivedData = [[NSMutableData alloc] initWithLength:0];
    }
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
#ifdef XML_LOG_RECEIVE
    NSString *_str = [[NSString alloc] initWithBytes:[self.receivedData bytes] length:[self.receivedData length] encoding:NSUTF8StringEncoding];
    [_str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CLog(@"返回的Xml:%@", _str);
    [_str release];
#endif
    
    assert(theConnection == self.connection);

	if (self.receivedData && [self.receivedData length] > 0) {
        [self saveImageWithPath:self.target andWithData:self.receivedData];
    }

    [self finishGettingData:self.receivedData];

    if (self.receivedData) {
        self.receivedData = nil;
    }
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    assert(theConnection == self.connection);
	[self stopLoading];
    if(self.delegate && [self.delegate respondsToSelector:@selector(AsyImageLoaderFailLoadingImage:)]) {
        [self.delegate AsyImageLoaderFailLoadingImage:self];
    }
}

@end
