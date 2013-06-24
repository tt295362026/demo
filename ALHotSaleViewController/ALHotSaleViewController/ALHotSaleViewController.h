//
//  ALHotSaleViewController.h
//  ALHotSaleViewController
//
//  Created by andy on 13-6-3.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALUIViewController.h"
#import "ALWaterFlowView.h"
#import "ALWaterFlowVC.h"

@interface ALHotSaleView : UIView

@property (nonatomic, assign) id delegate;

@end

@interface ALHotSaleViewController : ALUIViewController <ALWaterFlowViewDatasource, ALWaterFlowViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ALHotSaleView *_hotsaleView;
}

@property (nonatomic, retain) ALWaterFlowView *waterflowView;

@end


