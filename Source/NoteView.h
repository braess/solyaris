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
	UITextView *_msgNote;
	UIActivityIndicatorView *_activity;
	UIImageView *_iconInfo;
	UIImageView *_iconSuccess;
	UIImageView *_iconError;
    UIImageView *_iconNotification;
    
}

// Business Methods
- (void)noteActivity:(NSString*)msg;
- (void)noteInfo:(NSString*)msg;
- (void)noteSuccess:(NSString*)msg;
- (void)noteError:(NSString*)msg;
- (void)noteNotification:(NSString*)msg;
- (void)showNote;
- (void)showNoteAfterDelay:(float)delay;
- (void)dismissNote;
- (void)dismissNoteAfterDelay:(float)delay;



@end
