/**
 * This header is generated by class-dump-z 0.2-1.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: (null)
 */

#import <Foundation/NSObject.h>

@class NSString, NSDictionary;

@interface SBVODAlarm : NSObject {
	NSString* _title;
	NSString* _path;
	NSDictionary* _rentalInfo;
	unsigned _loadingRentalInfo : 1;
	unsigned _sanityCheckingExpiration : 1;
	unsigned _watched : 1;
}
+(void)cancelPendingLoads;
+(void)_rentalInfoThread;
-(id)initWithDictionary:(id)dictionary;
// inherited: -(void)dealloc;
-(int)compare:(id)compare;
-(id)expirationDate;
-(BOOL)hasLoaded;
-(BOOL)isExpired;
-(BOOL)rentalHasBeenWatched;
-(BOOL)hasFireDateSinceDate:(id)date;
-(id)nextFireDate;
-(id)path;
-(void)sanityCheckExpiration;
-(id)title;
-(id)_dateWithStartDate:(id)startDate duration:(id)duration;
-(id)_rentalInfo;
-(void)_setRentalInfo:(id)info;
@end

