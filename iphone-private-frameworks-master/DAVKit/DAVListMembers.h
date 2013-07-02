/**
 * This header is generated by class-dump-z 0.2-1.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/DAVKit.framework/DAVKit
 */

#import "DAVKit-Structs.h"
#import "DAVRequest.h"


@interface DAVListMembers : DAVRequest {
	BOOL showHidden;
}
+(id)listMembersRequestWithURL:(id)url showHidden:(BOOL)hidden;
+(id)listMembersRequestWithSession:(id)session path:(id)path showHidden:(BOOL)hidden;
-(id)initListMembersWithURL:(id)url showHidden:(BOOL)hidden;
-(id)initListMembersWithSession:(id)session path:(id)path showHidden:(BOOL)hidden;
-(id)members;
// inherited: -(void)finalizeOperation;
@end

