//
//  ALUIViewController.m
//  ALUIViewController
//
//  Created by andy on 13-4-27.
//  Copyright (c) 2013年 ChinaWidth. All rights reserved.
//

#import "ALUIViewController.h"
#import "ALUINavigationController.h"

/*
 ALUIViewController
 
 */

@interface ALUIViewController ()

@end

@implementation ALUIViewController

@synthesize customNavigationItem = _customNavigationItem;
@synthesize customNavigationController;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _customNavigationItem = [[ALNavigationItem alloc] init];
        [_customNavigationItem setCurrentViewController:self];
        
        [self.navigationItem addObserver:self forKeyPath:@"leftBarButtonItems" options:NSKeyValueObservingOptionNew context:NULL];
        [self.navigationItem addObserver:self forKeyPath:@"leftBarButtonItem" options:NSKeyValueObservingOptionNew context:NULL];
        [self.navigationItem addObserver:self forKeyPath:@"rightBarButtonItems" options:NSKeyValueObservingOptionNew context:NULL];
        [self.navigationItem addObserver:self forKeyPath:@"rightBarButtonItem" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.customNavigationController updateNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)UpdateNavigationBar
{
    NSLog(@"you got a value");
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

#pragma mark - Overload the UIViewController
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (_customNavigationItem) {
        [_customNavigationItem setTitle:title];
    }
    if (self.customNavigationController) {
        [((ALUINavigationController *)self.customNavigationController).customNavigationBar setupWithActionType:ALNavigationActionTypeUpdate WithAnimated:NO];
    }
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    ALUIViewController *tempVC = nil;
    ALUINavigationController *tempNav = nil;
    
    if ([modalViewController isKindOfClass:[ALUINavigationController class]]) {
        tempNav = (ALUINavigationController *)modalViewController;
        tempVC = (ALUIViewController *)tempNav.topViewController;
    }
    
    if (tempNav && tempVC) {
        [tempVC setCustomNavigationController:tempNav];
        [tempNav setIsModal:YES];
        [tempNav.customNavigationBar presentModalViewController:tempVC.customNavigationItem animated:animated];
    }
    [super presentModalViewController:modalViewController animated:animated];
}

@end
