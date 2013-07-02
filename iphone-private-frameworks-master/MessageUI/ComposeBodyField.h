/**
 * This header is generated by class-dump-z 0.2-1.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/Frameworks/MessageUI.framework/MessageUI
 */

#import "MessageUI-Structs.h"
#import <UIKit/UIWebDocumentView.h>

@class NSMutableArray, DOMHTMLDocument, GenericAttachmentStore, DOMHTMLElement;
@protocol MailComposeViewDelegate;

@interface ComposeBodyField : UIWebDocumentView {
	DOMHTMLElement* _body;
	DOMHTMLDocument* _document;
	DOMHTMLElement* _blockquote;
	CGSize _originalSize;
	CGSize _layoutSize;
	unsigned _isDirty : 1;
	unsigned _forwardingNotification : 1;
	unsigned _replaceAttachments : 1;
	unsigned _isLoading : 1;
	NSMutableArray* _contentToAppend;
	NSRange _rangeToSelect;
	GenericAttachmentStore* _attachmentStore;
	id<MailComposeViewDelegate> _mailComposeViewDelegate;
}
-(void)setMailComposeViewDelegate:(id)delegate;
-(float)contentWidth;
// inherited: -(id)initWithFrame:(CGRect)frame;
// inherited: -(void)dealloc;
-(void)setDirty:(BOOL)dirty;
-(BOOL)isDirty;
// inherited: -(BOOL)becomeFirstResponder;
// inherited: -(void)ensureSelection;
-(NSRange)selectedRange;
-(void)setSelectedRange:(NSRange)range;
-(void)setLayoutInterval:(int)interval;
-(void)replaceImages;
// inherited: -(void)webView:(id)view didFinishLoadForFrame:(id)frame;
-(void)setAttachmentStore:(id)store;
-(void)setReplaceAttachmentsWithFilename:(BOOL)filename;
-(void)webViewDidChange:(id)webView;
-(void)_finishedLoadingURLRequest:(id)request success:(BOOL)success;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(id)webView:(id)view resource:(id)resource willSendRequest:(id)request redirectResponse:(id)response fromDataSource:(id)dataSource;
-(BOOL)webView:(id)view shouldDeleteDOMRange:(id)range;
-(BOOL)webView:(id)view shouldInsertText:(id)text replacingDOMRange:(id)range givenAction:(int)action;
-(void)setPinHeight:(float)height;
// inherited: -(void)setFrame:(CGRect)frame;
-(BOOL)endEditing:(BOOL)editing;
-(void)setLoading:(BOOL)loading;
-(void)setMarkupString:(id)string;
-(void)_nts_AddDOMNode:(id)node quote:(BOOL)quote baseURL:(id)url emptyFirst:(BOOL)first prepended:(BOOL)prepended;
-(void)addDOMNode:(id)node quote:(BOOL)quote baseURL:(id)url emptyFirst:(BOOL)first prepended:(BOOL)prepended;
-(void)addMarkupString:(id)string quote:(BOOL)quote baseURL:(id)url emptyFirst:(BOOL)first prepended:(BOOL)prepended;
-(void)prependMarkupString:(id)string quote:(BOOL)quote baseURL:(id)url emptyFirst:(BOOL)first;
-(void)appendMarkupString:(id)string quote:(BOOL)quote;
-(void)setMarkupString:(id)string baseURL:(id)url quote:(BOOL)quote;
-(void)appendQuotedMarkupString:(id)string baseURL:(id)url;
-(void)prependString:(id)string;
-(void)prependMarkupString:(id)string quote:(BOOL)quote;
-(BOOL)containsRichText;
-(id)plainTextAlternative;
-(id)plainTextContentWithAttachmentSource:(id)attachmentSource;
-(void)htmlString:(id*)string otherHtmlStringsAndAttachments:(id*)attachments withAttachmentSource:(id)attachmentSource;
-(id)htmlString;
-(CGRect)rectOfElementWithID:(id)anId;
-(id)_nodeForAttachmentData:(id)attachmentData text:(id)text type:(id)type;
-(id)documentFragmentForPasteboardItemAtIndex:(int)index;
@end

