/**
 * This header is generated by class-dump-z 0.2-1.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/SpringBoardUI.framework/SpringBoardUI
 */

#import <Foundation/NSObject.h>

@class UIView, NSString;

@interface SBAwayViewPluginController : NSObject {
@private
	UIView* _view;
}
@property(retain, nonatomic) UIView* view;
+(void)enableBundleNamed:(NSString*)name;
+(void)disableBundleNamed:(NSString*)name;
-(void)dealloc;

// Load the view. Called when the view isn't loaded but the "view" property is requrested.
// Similar to the -loadView method in UIViewController.
// Subclass should overload this method to display what is shown on the screen.
-(void)loadView;

// Called in -[SBAwayController _releaseAwayView]. Remove the view so that you can reinitialize.
// Do not overload.
-(void)purgeView;

// Perform some actions when the view will/has been appear/disappear(ed).
// Similar to those methods in UIViewController.
// Default is do nothing.
-(void)viewWillAppear:(BOOL)animated;
-(void)viewDidAppear:(BOOL)animated;
-(void)viewWillDisappear:(BOOL)animated;
-(void)viewDidDisappear:(BOOL)animated;

// Handle some actions for the menu button actions and swipe gestures.
// Returns YES if you have handled that.
// Default is return NO and do nothing.
-(BOOL)handleMenuButtonTap;
-(BOOL)handleMenuButtonDoubleTap;
-(BOOL)handleMenuButtonHeld;
-(BOOL)handleGesture:(int)gestureType fingerCount:(unsigned)count;

// Do not overload.
-(void)disable;

// Assign a priority to the controller, which will be shown on top.
// Default is 0.
-(int)pluginPriority;

// Called by -[SBAwayController awayPluginControllerShouldAnimateOthersResumption].
// Default is return YES.
-(BOOL)animateResumingToApplicationWithIdentifier:(NSString*)identifier;

// Default is return YES.
-(BOOL)showAwayItems;

@end
