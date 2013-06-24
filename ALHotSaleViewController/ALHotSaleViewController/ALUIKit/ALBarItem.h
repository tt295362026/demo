//
//  ALBarItem.h
//  ALUIViewController
//
//  Created by andy on 13-4-28.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBarItem : NSObject
{
    NSString        *_title;
    
    UIImage         *_image;
    UIEdgeInsets    _imageEdgeInsets;
    
    UIImage         *_backgroundImage;
}

@property (nonatomic, copy) NSString *title;

@property(nonatomic,retain) UIImage     *image;
@property(nonatomic)        UIEdgeInsets imageInsets;

@end
