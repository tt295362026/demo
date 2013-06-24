//
//  ALUINavigationController.m
//  ALUIViewController
//
//  Created by andy on 13-4-27.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALUINavigationController.h"

/*
 ALUINavigationController 
 
 */


@interface ALUINavigationController ()

- (void)OnBackBtnPressed;

- (void)layoutNow;

- (void)setCustomNavigationBarHidden:(BOOL)hidden WithAnimated:(BOOL)animated;

@end

@implementation ALUINavigationController

@synthesize isModal = _isModal;
@synthesize customNavigationBar = _customNavigationBar;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        // Custom initialization
        _isModal = NO;
        if ([rootViewController isKindOfClass:[ALUIViewController class]]) {
            if (_customNavigationBar == nil) {
                _customNavigationBar = [[ALNavigationBar alloc] init];
                [_customNavigationBar setDelegate:self];
                [self.view addSubview:_customNavigationBar];
                [_customNavigationBar setFrame:CGRectMake(0, 0, self.view.bounds.size.width,  self.navigationBar.bounds.size.height)];
                [_customNavigationBar setupWithActionType:ALNavigationActionTypeUpdate WithAnimated:NO];
            }
        }
        
        [self pushViewController:rootViewController animated:NO];
        [self.view addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [_customNavigationBar setFrame:CGRectMake(0, 0, self.view.bounds.size.width,  self.navigationBar.bounds.size.height)];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setBgImageName:(NSString *)bgImage
{
    [_customNavigationBar setBgImageName:bgImage];
}

- (void)setBackBtnImageName:(NSString *)backBtnImage
{
    [_customNavigationBar setBackBtnImageName:backBtnImage];
}

- (void)setBtnImageName:(NSString *)btnImage
{
    [_customNavigationBar setBtnImageName:btnImage];
}

- (void)updateNavigationBar
{
    [_customNavigationBar setupWithActionType:ALNavigationActionTypeUpdate WithAnimated:YES];
}

#pragma mark - ALUINavigationController ()
- (void)layoutNow
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)OnBackBtnPressed
{
    if ([self.viewControllers count] > 1) {
        [self popViewControllerAnimated:YES];
    }
    else if (_isModal) {
        _isModal = NO;
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)setCustomNavigationBarHidden:(BOOL)hidden WithAnimated:(BOOL)animated
{
    CGFloat tempOffset = hidden? - self.navigationBar.bounds.size.height:self.navigationBar.bounds.size.height;
    
    if (animated) {
        if (hidden) {
            [self.navigationBar setHidden:hidden];
            [UIView animateWithDuration:0.3f animations:^{
                [_customNavigationBar setCenter:CGPointMake(_customNavigationBar.center.x, _customNavigationBar.center.y + tempOffset)];
                [self.navigationBar setCenter:CGPointMake(self.navigationBar.center.x, self.navigationBar.center.y + tempOffset)];
            } completion:^(BOOL finished) {
                [_customNavigationBar setHidden:hidden];
            }];
        }
        else {
            [_customNavigationBar setHidden:hidden];
            [self.navigationBar setHidden:hidden];
            [UIView animateWithDuration:0.3f animations:^{
                [_customNavigationBar setCenter:CGPointMake(_customNavigationBar.center.x, _customNavigationBar.center.y + tempOffset)];
                [self.navigationBar setCenter:CGPointMake(self.navigationBar.center.x, self.navigationBar.center.y + tempOffset)];
            }];
        }
    }
    else {
        [self.navigationBar setHidden:hidden];
        [_customNavigationBar setHidden:hidden];
    }
    [self layoutNow];
}

#pragma mark - OverLoad UINavigationViewController
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    [self setCustomNavigationBarHidden:navigationBarHidden WithAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[ALUIViewController class]]) {
        ALUIViewController *tempVC = (ALUIViewController *)viewController;
        [tempVC setCustomNavigationController:self];
        [_customNavigationBar pushNavigationItem:tempVC.customNavigationItem animated:animated];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    id result = [super popViewControllerAnimated:animated];
    if ([self.viewControllers count] > 0) {
        ALUIViewController *tempVC = (ALUIViewController *)[self.viewControllers lastObject];
        NSLog(@"you will get : %@", tempVC.title);
        [_customNavigationBar popNavigationItemAnimated:YES];
    }
    return result;
}

#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item
{
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{

}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    
}

@end
