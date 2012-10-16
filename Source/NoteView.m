//
//  NoteView.m
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

#import "NoteView.h"
#import <QuartzCore/QuartzCore.h>
#import "SolyarisConstants.h"

/**
 * Note Stack.
 */
@interface NoteView (AnimationHelpers)
- (void)animationShowNote;
- (void)animationShowNoteDone;
- (void)animationDismissNote;
- (void)animationDismissNoteDone;
- (void)prepareNotes;
@end


/**
 * Note View.
 */
@implementation NoteView


#pragma mark -
#pragma mark Constants

// constants
#define kNoteOpacity                    0.8f
#define kAnimateTimeNoteShow            0.21f
#define kAnimateTimeNoteDismiss         0.21f
#define kDelayTimeNoteDismiss           4.5f


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
    
	// size
	float nvs = 180;
	float inset = 5.0;
    
	// init UIView
    self = [super initWithFrame:frame];
    
	// init self
    if (self != nil) {
        
        // self
        self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		// transparent view
		CGRect nframe = CGRectMake((frame.size.width/2.0)-nvs/2.0, (frame.size.height/2.0)-nvs/2.0, nvs, nvs);
		UIView *note = [[UIView alloc] initWithFrame:nframe];
        note.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
		note.backgroundColor = [UIColor blackColor];
		note.alpha = kNoteOpacity;
		note.layer.cornerRadius = 8;
        
        note.layer.shadowColor = [[UIColor blackColor] CGColor];
        note.layer.shadowOpacity = 0.7;
        note.layer.shadowRadius = 5.0;
        note.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);    
        note.layer.shadowPath = [UIBezierPath bezierPathWithRect:note.bounds].CGPath;
        
        _note = [note retain];
        [note release];
        
        // title
        UILabel *noteTitle = [[UILabel alloc] initWithFrame:CGRectMake(inset, nvs/2.0-nvs/8, nvs-2*inset, nvs/8)];
        noteTitle.backgroundColor = [UIColor clearColor];
        noteTitle.textAlignment = UITextAlignmentCenter;
        noteTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        noteTitle.textColor = [UIColor whiteColor];
        noteTitle.opaque = YES;
        noteTitle.numberOfLines = 1;
        
        _noteTitle = [noteTitle retain];
        [noteTitle release];
        
		
		// message
		UITextView *noteMessage = [[UITextView alloc] initWithFrame:CGRectMake(inset, nvs/2.0, nvs-2*inset, nvs/2)];
		noteMessage.contentInset = UIEdgeInsetsMake(0,-7,-20,-20);
        noteMessage.textAlignment = UITextAlignmentCenter;
        noteMessage.backgroundColor = [UIColor clearColor];
        noteMessage.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        noteMessage.textColor = [UIColor whiteColor];
        noteMessage.opaque = YES;
        noteMessage.userInteractionEnabled = NO;
        noteMessage.editable = NO;
        
        _noteMessage = [noteMessage retain];
        [noteMessage release];
        
        
		
		// icon center
		CGPoint iconCenter = CGPointMake(nframe.size.width/2.0, nframe.size.height/2.0-nvs/4);
		CGRect iconFrame = CGRectMake(iconCenter.x-24, iconCenter.y-24, 48, 48);
		
		// loader
		UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activity.center = iconCenter;
		activity.hidden = YES;
        _activity = [activity retain];
        [activity release];
		
		// success
		UIImageView *iconSuccess = [[UIImageView alloc] initWithFrame:iconFrame];
		iconSuccess.image = [UIImage imageNamed:@"icon_note_success.png"];
		iconSuccess.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconSuccess.backgroundColor = [UIColor clearColor];
		iconSuccess.contentMode = UIViewContentModeCenter;
		iconSuccess.hidden = YES;
        _iconSuccess = [iconSuccess retain];
        [iconSuccess release];
		
		// info
		UIImageView *iconInfo = [[UIImageView alloc] initWithFrame:iconFrame];
		iconInfo.image = [UIImage imageNamed:@"icon_note_info.png"];
		iconInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconInfo.backgroundColor = [UIColor clearColor];
		iconInfo.contentMode = UIViewContentModeCenter;
		iconInfo.hidden = YES;
        _iconInfo = [iconInfo retain];
        [iconInfo release];
        
        // error
		UIImageView *iconGlitch = [[UIImageView alloc] initWithFrame:iconFrame];
		iconGlitch.image = [UIImage imageNamed:@"icon_note_glitch.png"];
		iconGlitch.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconGlitch.backgroundColor = [UIColor clearColor];
		iconGlitch.contentMode = UIViewContentModeCenter;
		iconGlitch.hidden = YES;
        _iconGlitch = [iconGlitch retain];
        [iconGlitch release];
		
		
		// error
		UIImageView *iconError = [[UIImageView alloc] initWithFrame:iconFrame];
		iconError.image = [UIImage imageNamed:@"icon_note_error.png"];
		iconError.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconError.backgroundColor = [UIColor clearColor];
		iconError.contentMode = UIViewContentModeCenter;
		iconError.hidden = YES;
        _iconError = [iconError retain];
        [iconError release];
        
        
        // notification
		UIImageView *iconNotification = [[UIImageView alloc] initWithFrame:iconFrame];
		iconNotification.image = [UIImage imageNamed:@"icon_note_notification.png"];
		iconNotification.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconNotification.backgroundColor = [UIColor clearColor];
		iconNotification.contentMode = UIViewContentModeCenter;
		iconNotification.hidden = YES;
        _iconNotification = [iconNotification retain];
        [iconNotification release];
		
		
		// add
		[_note addSubview:_activity];
		[_note addSubview:_iconSuccess];
        [_note addSubview:_iconGlitch];
		[_note addSubview:_iconError];
		[_note addSubview:_iconInfo];
        [_note addSubview:_iconNotification];
		[_note addSubview:_noteTitle];
        [_note addSubview:_noteMessage];
		_note.hidden = YES;
		
		// add
		[self addSubview:_note];
		
		// hide
		self.hidden = YES;
        
		// return
		return self;
	}
	
	// nop
	return nil;
}


#pragma mark -
#pragma mark Touch

/*
 * Touch.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	FLog();
    [self dismissNoteAfterDelay:0];
}



#pragma mark -
#pragma mark Business Methods

/**
 * Notes an activity.
 */
- (void)noteActivity:(NSString*)title message:(NSString*)msg {
	FLog();
	
	// reset
	[self prepareNotes];
	
	// text
	_noteTitle.text = title;
    _noteMessage.text = msg;
	
	// activity
	_activity.hidden = NO;
	[_activity startAnimating];
}

/**
 * Notes a success.
 */
- (void)noteSuccess:(NSString*)title message:(NSString *)msg {
	FLog();
	
    // reset
	[self prepareNotes];
	
	// text
	_noteTitle.text = title;
    _noteMessage.text = msg;
	
	// success
	_iconSuccess.hidden = NO;
}

/**
 * Notes a glitch.
 */
- (void)noteGlitch:(NSString*)title message:(NSString *)msg  {
	FLog();
	
    // reset
	[self prepareNotes];
	
	// text
	_noteTitle.text = title;
    _noteMessage.text = msg;
	
	// glitch
	_iconGlitch.hidden = NO;
}

/**
 * Notes an error.
 */
- (void)noteError:(NSString*)title message:(NSString *)msg  {
	FLog();
	
    // reset
	[self prepareNotes];
	
	// text
	_noteTitle.text = title;
    _noteMessage.text = msg;
	
	// error
	_iconError.hidden = NO;
}

/**
 * Notes an info.
 */
- (void)noteInfo:(NSString*)title message:(NSString *)msg {
	FLog();
	
    // reset
	[self prepareNotes];
	
	// text
	_noteTitle.text = title;
    _noteMessage.text = msg;
	
	// info
	_iconInfo.hidden = NO;
}



/**
 * Notification.
 */
- (void)noteNotification:(NSString*)title message:(NSString *)msg {
	FLog();
    
    // reset
	[self prepareNotes];
	
	// text
	_noteTitle.text = title;
    _noteMessage.text = msg;
    
    // icons
    _iconNotification.hidden = NO;
    
}




#pragma mark -
#pragma mark Note


/**
 * Shows the note.
 */
- (void)showNote {
	[self performSelector:@selector(animationShowNote) withObject:nil afterDelay:0];
}
- (void)showNoteAfterDelay:(float)delay {
	[self performSelector:@selector(animationShowNote) withObject:nil afterDelay:delay];
}



/*
 * Animation note show.
 */
- (void)animationShowNote {
	GLog();
    
	// prepare view
	_note.alpha = 0.0f;
	_note.transform = CGAffineTransformMakeScale(0.1,0.1);
	_note.hidden = NO;
	self.hidden = NO;
    
	// animate
	[UIView beginAnimations:@"note_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNoteShow];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	_note.alpha = kNoteOpacity;
	_note.transform = CGAffineTransformMakeScale(1,1);
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationShowNoteDone) withObject:nil afterDelay:kAnimateTimeNoteShow];
}
- (void) animationShowNoteDone {
	GLog();
}

/**
 * Dismisses the note.
 */
- (void)dismissNote {
    FLog();
	[self performSelector:@selector(animationDismissNote) withObject:nil afterDelay:kDelayTimeNoteDismiss];
}
- (void)dismissNoteAfterDelay:(float)delay {
    FLog();
	[self performSelector:@selector(animationDismissNote) withObject:nil afterDelay:delay];
}


/*
 * Animation note dismiss.
 */
- (void)animationDismissNote {
	GLog();
	
	// prepare view
	_note.alpha = kNoteOpacity;
    
	// animate
	[UIView beginAnimations:@"note_dismiss" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNoteDismiss];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	_note.alpha = 0.0f;
	_note.transform = CGAffineTransformMakeScale(1.2,1.2);
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationDismissNoteDone) withObject:nil afterDelay:kAnimateTimeNoteDismiss];
	
}
- (void) animationDismissNoteDone {
	GLog();
    
	// hide
	_note.hidden = YES;
	_note.transform = CGAffineTransformMakeScale(1,1);
	self.hidden = YES;
	
	// reset
	[self prepareNotes];
}


/*
 * Resets the various notes.
 */
- (void)prepareNotes {
    
	// message
	_noteTitle.text = @"";
    _noteMessage.text = @"";
    
    // recenter
    _note.center = self.center;

    
	// activity
	[_activity stopAnimating];
	_activity.hidden = YES;
	
	// success
	_iconSuccess.hidden = YES;
    
    // error
	_iconGlitch.hidden = YES;
	
	// error
	_iconError.hidden = YES;
	
	// info
	_iconInfo.hidden = YES;
    
    // notification
	_iconNotification.hidden = YES;
    
    // swap
    _note.hidden = NO;
    [self bringSubviewToFront:_note];
    
}

/**
 * Offset.
 */
- (void)offset {
    
    // recenter
    float off = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? 0 : 20;
    _note.center = CGPointMake(self.center.x,self.frame.size.height/4.0+off);
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[_noteTitle release];
    [_noteMessage release];
	[_activity release];
	[_iconSuccess release];
	[_iconError release];
	[_iconInfo release];
    [_iconNotification release];
	[_note release];
	
	// supimessage
	[super dealloc];
}

@end



/**
 * Note.
 */
@implementation Note


#pragma mark -
#pragma mark Note

/**
 * Stores/retrieves a note.
 */
+ (void)storeNote:(Note*)note key:(NSString*)key {
    FLog();
    
    // notes
    NSMutableDictionary *notes = [self retrieveNotes];
    
    // add note
    [notes setObject:[NSKeyedArchiver archivedDataWithRootObject:note] forKey:key];
    
    // update
    [self updateNotes:notes];
    
}
+ (Note*)retrieveNote:(NSString *)key {
    GLog();
    
    // notes
    NSMutableDictionary *notes = [self retrieveNotes];
    
    // retrieve & remove
    if ([notes objectForKey:key]) {
        
        // note
        Note *note = (Note*) [NSKeyedUnarchiver unarchiveObjectWithData:[notes objectForKey:key]];
        
        // remove
        [notes removeObjectForKey:key];
        
        // update
        [self updateNotes:notes];
        
        // return 
        return note;
    }
    
    // nop
    return NULL;
}

/**
 * Retrieve / update notes.
 */
+ (NSMutableDictionary*)retrieveNotes {
    
    // defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// notes
	NSDictionary *notes = [defaults dictionaryForKey:udNotes];
	
	// init defaults
	if (notes == nil) {
        
        // init
        notes = [NSMutableDictionary dictionary];
		[defaults setObject:notes forKey:udNotes];
        [defaults synchronize];
	}
	
	// return mutable copy
	return [[notes mutableCopy] autorelease];;
}
+ (void)updateNotes:(NSMutableDictionary *)notes {
    
    // defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// set
	[defaults setObject:notes forKey:udNotes];
	[defaults synchronize]; 
}



#pragma mark -
#pragma mark Properties

// synthesize
@synthesize title;
@synthesize message;
@synthesize type;


#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)initNoteWithTitle:(NSString *)ttl message:(NSString *)msg type:(int)tp {
    GLog();
    
    // self
    if ((self = [super init])) {
        
        // fields
        self.title = ttl;
        self.message = msg;
        self.type = [NSNumber numberWithInt:tp];
    }
    return self;
}


#pragma mark -
#pragma mark Coder


/*
 * Encode.
 */
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.type = [decoder decodeObjectForKey:@"type"];
    }
    return self;
}


#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// self
    [title release];
	[message release];
    [type release];
	
	// sup
	[super dealloc];
}

@end
