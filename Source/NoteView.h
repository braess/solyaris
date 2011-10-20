//
//  NoteView.h
//  Solyaris
//
//  Created by Beat Raess on 13.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Note View.
 */
@interface NoteView : UIView {
    
	// ui
	UIView *_note;
    UILabel *_noteTitle;
	UITextView *_noteMessage;
	UIActivityIndicatorView *_activity;
	UIImageView *_iconInfo;
	UIImageView *_iconSuccess;
	UIImageView *_iconError;
    UIImageView *_iconNotification;
    
}

// Business Methods
- (void)noteActivity:(NSString*)title message:(NSString*)msg;
- (void)noteInfo:(NSString*)title message:(NSString*)msg;
- (void)noteSuccess:(NSString*)title message:(NSString*)msg;
- (void)noteError:(NSString*)title message:(NSString*)msg;
- (void)noteNotification:(NSString*)title message:(NSString*)msg;
- (void)showNote;
- (void)showNoteAfterDelay:(float)delay;
- (void)dismissNote;
- (void)dismissNoteAfterDelay:(float)delay;



@end
