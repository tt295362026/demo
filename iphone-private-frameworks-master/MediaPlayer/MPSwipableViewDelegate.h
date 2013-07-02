/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/Frameworks/MediaPlayer.framework/MediaPlayer
 */

#import "NSObject.h"
#import "MediaPlayer-Structs.h"


@protocol MPSwipableViewDelegate <NSObject>
@optional
-(id)swipableView:(id)view overrideHitTest:(CGPoint)test withEvent:(id)event;
-(void)swipableView:(id)view swipedInDirection:(int)direction;
-(void)swipableView:(id)view tappedWithCount:(unsigned)count atLocation:(CGPoint)location;
-(void)swipableView:(id)view tappedWithCount:(unsigned)count;
-(void)swipableView:(id)view pinchedToScale:(float)scale withVelocity:(float)velocity;
-(void)swipableViewHadActivity:(id)activity;
@end
