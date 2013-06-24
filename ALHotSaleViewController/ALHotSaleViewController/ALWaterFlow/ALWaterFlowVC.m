//
//  ALWaterFlowVC.m
//  ALWaterFlow
//
//  Created by andy on 13-5-29.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALWaterFlowVC.h"
#import <QuartzCore/QuartzCore.h>
@interface ALWaterFlowVC ()

- (NSString *)imagePathWithIndexPath:(ALIndexPath *)indexpath;

@end

@implementation ALWaterFlowVC

@synthesize waterFlowView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.waterFlowView = [[ALWaterFlowView alloc] init];


        [self.waterFlowView setWaterFlowDatasource:self];
        [self.waterFlowView setWaterFlowDelegate:self];
        [self setView:self.waterFlowView];
        
        imagePathArray = [NSArray arrayWithObjects:@"http://ts1.mm.bing.net/th?id=H.4623121021797832&pid=1.7&w=225&h=141&c=7&rs=1", @"http://ts2.mm.bing.net/th?id=H.4686179707257513&pid=1.7&w=160&h=154&c=7&rs=1", @"http://ts2.mm.bing.net/th?id=H.4785917433415137&pid=1.7&w=160&h=154&c=7&rs=1", @"http://ts1.mm.bing.net/th?id=H.4603213852444004&pid=1.7&w=206&h=146&c=7&rs=1", @"http://ts1.mm.bing.net/th?id=H.4991100889924496&pid=1.7&w=155&h=154&c=7&rs=1", @"http://ts3.mm.bing.net/th?id=H.5033891618096962&pid=1.7&w=220&h=119&c=7&rs=1", @"http://ts4.mm.bing.net/th?id=H.5065833334441907&pid=1.7&w=133&h=144&c=7&rs=1", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)imagePathWithIndexPath:(ALIndexPath *)indexpath
{
    switch (indexpath.column) {
        case 0:{
            switch (indexpath.row%3) {
                case 0:return @"http://ts1.mm.bing.net/th?id=H.4991100889924496&pid=1.7&w=155&h=154&c=7&rs=1";
                case 1:return @"http://ts2.mm.bing.net/th?id=H.4686179707257513&pid=1.7&w=160&h=154&c=7&rs=1";
                default:return @"http://ts3.mm.bing.net/th?id=H.5033891618096962&pid=1.7&w=220&h=119&c=7&rs=1";
            }
        }break;
        case 1:{
            switch (indexpath.row%3) {
                case 0:return @"http://ts2.mm.bing.net/th?id=H.4785917433415137&pid=1.7&w=160&h=154&c=7&rs=1";
                case 1:return @"http://ts1.mm.bing.net/th?id=H.4603213852444004&pid=1.7&w=206&h=146&c=7&rs=1";
                case 2:return @"http://ts3.mm.bing.net/th?id=H.5033891618096962&pid=1.7&w=220&h=119&c=7&rs=1";
                default:return @"http://ts4.mm.bing.net/th?id=H.5065833334441907&pid=1.7&w=133&h=144&c=7&rs=1";
            }
        }break;
        case 2:{
            switch (indexpath.row%3) {
                case 0:return @"http://ts1.mm.bing.net/th?id=H.4623121021797832&pid=1.7&w=225&h=141&c=7&rs=1";
                case 1:return @"http://ts2.mm.bing.net/th?id=H.4785917433415137&pid=1.7&w=160&h=154&c=7&rs=1";
                case 2:return @"http://ts1.mm.bing.net/th?id=H.4603213852444004&pid=1.7&w=206&h=146&c=7&rs=1";
                default:return  @"http://ts1.mm.bing.net/th?id=H.4991100889924496&pid=1.7&w=155&h=154&c=7&rs=1";
            }
        }break;
        default:{
            switch (indexpath.row%3) {
                case 0:return @"http://ts1.mm.bing.net/th?id=H.4991100889924496&pid=1.7&w=155&h=154&c=7&rs=1";
                case 1:return @"http://ts2.mm.bing.net/th?id=H.4785917433415137&pid=1.7&w=160&h=154&c=7&rs=1";
                case 2:return @"http://ts2.mm.bing.net/th?id=H.4785917433415137&pid=1.7&w=160&h=154&c=7&rs=1";
                default:return @"http://ts4.mm.bing.net/th?id=H.5065833334441907&pid=1.7&w=133&h=144&c=7&rs=1";
            }
        }break;
    }
}

#pragma mark - ALWaterFlowViewDatasource <NSObject>
- (NSInteger)numberOfColumnsInFlowView:(ALWaterFlowView *)flowView
{
    return 3;
}

- (NSInteger)flowView:(ALWaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    switch (column) {
        case 0:return 20;
        case 1:return 20;
        case 2:return 20;
        default:return 11;
    }
}

- (ALWaterFlowCell *)flowView:(ALWaterFlowView *)flowView cellForRowAtIndexPath:(ALIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	ALWaterFlowCell *cell = [flowView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil) {
		cell  = [[[ALWaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
	}
    
    NSString *a = [[NSString alloc]initWithFormat:@" %d,%d",indexPath.row,indexPath.column];
    NSString *tempStr = [self imagePathWithIndexPath:indexPath];
    [cell.imageView loadImageWithPath:[tempStr copy] andPlaceHolderName:@"Icon.png"];
    cell.textView.text = a;
	return cell;
}

#pragma mark -ALWaterFlowViewDelegate <NSObject>
- (CGFloat)flowView:(ALWaterFlowView *)flowView heightForRowAtIndexPath:(ALIndexPath *)indexPath
{
    return 90.0f;
}

- (void)flowView:(ALWaterFlowView *)flowView didSelectRowAtIndexPath:(ALIndexPath *)indexPath
{
    NSLog(@"you pressed at %d,%d,%d,", indexPath.row * flowView.numberOfColumns, indexPath.column, indexPath.row * flowView.numberOfColumns + indexPath.column);
}

@end
