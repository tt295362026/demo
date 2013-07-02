/**
 * This header is generated by class-dump-z 0.2-0.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/PhotoLibrary.framework/PhotoLibrary
 */

#import "PhotoLibrary-Structs.h"
#import <UIKit/UIControl.h>

@class UIView, UIImage, UIImageView;

@interface PLCameraVideoSwitch : UIControl {
	UIImageView* _wellImageView;
	UIImageView* _handleImageView;
	UIImageView* _cameraImageView;
	UIImageView* _videoImageView;
	UIView* _wellMaskContainerView;
	UIImage* _wellImage;
	UIImage* _handleImage;
	UIImage* _handleDownImage;
	UIImage* _cameraImage;
	UIImage* _cameraLandscapeImage;
	UIImage* _videoImage;
	UIImage* _videoLandscapeImage;
	int _orientation;
	float _trackingHorizontalLocation;
	unsigned _on : 1;
	unsigned _didLayoutViews : 1;
	unsigned _didMove : 1;
	unsigned _lockEnabled : 1;
}
@property(assign, nonatomic, getter=isOn) BOOL on;
// inherited: -(id)initWithFrame:(CGRect)frame;
// inherited: -(void)dealloc;
// inherited: -(void)setEnabled:(BOOL)enabled;
-(void)setLockEnabled:(BOOL)enabled;
-(void)layoutSubviews;
-(void)setFrame:(CGRect)frame;
-(BOOL)pointInside:(CGPoint)inside withEvent:(id)event;
-(BOOL)pointInside:(CGPoint)inside forEvent:(GSEventRef)event;
// inherited: -(BOOL)beginTrackingWithTouch:(id)touch withEvent:(id)event;
// inherited: -(BOOL)continueTrackingWithTouch:(id)touch withEvent:(id)event;
// inherited: -(void)endTrackingWithTouch:(id)touch withEvent:(id)event;
// inherited: -(void)cancelTrackingWithEvent:(id)event;
-(void)setOn:(BOOL)on animated:(BOOL)animated;
-(void)_loadImages;
-(void)_setOn:(BOOL)on animationDuration:(float)duration;
-(CGAffineTransform)_rotationTransformForDeviceOrientation:(int)deviceOrientation;
-(void)_animateImageView:(id)view toTransform:(CGAffineTransform)transform withImage:(id)image animated:(BOOL)animated;
-(void)_deviceOrientationChanged:(id)changed;
-(int)orientation;
@end

