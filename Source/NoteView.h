//
//  NoteView.h
//  Solyaris
//
//  Created by Beat Raess on 13.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//
//  This file is part of Solyaris.
//  
//  Solyaris is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  Solyaris is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with Solyaris.  If not, see www.gnu.org/licenses/.

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
    UIImageView *_iconGlitch;
	UIImageView *_iconError;
    UIImageView *_iconNotification;
    
}

// Business Methods
- (void)noteActivity:(NSString*)title message:(NSString*)msg;
- (void)noteInfo:(NSString*)title message:(NSString*)msg;
- (void)noteSuccess:(NSString*)title message:(NSString*)msg;
- (void)noteGlitch:(NSString*)title message:(NSString*)msg;
- (void)noteError:(NSString*)title message:(NSString*)msg;
- (void)noteNotification:(NSString*)title message:(NSString*)msg;
- (void)showNote;
- (void)showNoteAfterDelay:(float)delay;
- (void)dismissNote;
- (void)dismissNoteAfterDelay:(float)delay;



@end
