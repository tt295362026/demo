//
//  ALWaterFlowVC.h
//  ALWaterFlow
//
//  Created by andy on 13-5-29.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALWaterFlowView.h"

@interface ALWaterFlowVC : UIViewController <ALWaterFlowViewDatasource, ALWaterFlowViewDelegate>
{
    NSArray *imagePathArray;
}
@property (nonatomic, retain) ALWaterFlowView *waterFlowView;

@end
