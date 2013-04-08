//
//  HeaderView.m
//  Solyaris
//
//  Created by Beat Raess on 3.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
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

#import "HeaderView.h"
#import "Appearance.h"

/**
 * HeaderView.
 */
@implementation HeaderView


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize back = mode_back;
@synthesize edit = mode_edit;
@synthesize action = mode_action;
@synthesize labelTitle = _labelTitle;
@synthesize buttonBack = _buttonBack;
@synthesize buttonEdit = _buttonEdit;
@synthesize buttonAction = _buttonAction;



#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    GLog();
    
	// super
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kHeaderHeight)])) {
        
        // self
        self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                
        // back
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [btnBack setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
        
        self.buttonBack = btnBack;
        [self addSubview:btnBack];
        
        // edit
        UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
        [btnEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        self.buttonEdit = btnEdit;
        [self addSubview:btnEdit];
        
        Button *btnEditDone = [[Button alloc] initStyle:ButtonStyleDefault];
        [btnEditDone setTitle:NSLocalizedString(@"Done", @"Done") forState:UIControlStateNormal];
        [btnEditDone addTarget:self action:@selector(actionEditDone:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonEditDone = [btnEditDone retain];
        [self addSubview:btnEditDone];
        [btnEditDone release];
        
        Button *btnEditCancel = [[Button alloc] initStyle:ButtonStyleLite];
        [btnEditCancel setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
        [btnEditCancel addTarget:self action:@selector(actionEditCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonEditCancel = [btnEditCancel retain];
        [self addSubview:btnEditCancel];
        [btnEditCancel release];
        
        // action
        UIButton *btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAction addTarget:self action:@selector(actionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.buttonAction = btnAction;
        [self addSubview:btnAction];
        
        // title
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblTitle.shadowOffset = CGSizeMake(1,1);
        lblTitle.opaque = YES;
        lblTitle.numberOfLines = 1;

        self.labelTitle = lblTitle;
        [self addSubview:lblTitle];
        [lblTitle release];
        
        // default
        editing = NO;
        mode_back = YES;
        mode_edit = NO;
        mode_action = NO;
        
		// return
		return self;
	}
	
	// nop
	return nil;
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    GLog();
    
    // frames
    CGRect frameBack = mode_back ? CGRectMake(-6, 0, 44, 44) : CGRectZero;
    CGRect frameTitle = !editing ? CGRectMake(frameBack.size.width, 0, self.frame.size.width-frameBack.size.width, kHeaderHeight) : CGRectZero;
    CGRect frameEdit = mode_edit ? CGRectMake(self.frame.size.width-44, 0, 44, 44) : CGRectZero;
    CGRect frameAction = (mode_action && ! editing) ? CGRectMake(self.frame.size.width-88, 0, 44, 44) : CGRectZero;
    CGRect frameEditDone = mode_edit ? CGRectMake(self.frame.size.width-80, 7, 80, 30) : CGRectZero;
    CGRect frameEditCancel = mode_edit ? CGRectMake(0, 7, 80, 30) : CGRectZero;
    
    // button
    _buttonBack.hidden = ! mode_back || editing;
    _buttonBack.frame = frameBack;
    _buttonEdit.hidden = ! mode_edit || editing;
    _buttonEdit.frame = frameEdit;
    _buttonEditDone.hidden = ! editing;
    _buttonEditDone.frame = frameEditDone;
    _buttonEditCancel.hidden = ! editing;
    _buttonEditCancel.frame = frameEditCancel;
    _buttonAction.hidden = ! mode_action || editing;
    _buttonAction.frame = frameAction;
    
    // title
    _labelTitle.hidden = editing;
    _labelTitle.frame = frameTitle;
    
}



#pragma mark -
#pragma mark Actions

/*
 * Action back.
 */
- (void)actionBack:(id)sender {
    DLog();
    
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerBack)]) {
        [self.delegate headerBack];
    }
}

/*
 * Action edit.
 */
- (void)actionEdit:(id)sender {
    DLog();
    
    // editing
    editing = YES;
    [self setNeedsLayout];
    
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerEdit)]) {
        [self.delegate headerEdit];
    }
}
- (void)actionEditDone:(id)sender {
    DLog();
    
    // editing
    editing = NO;
    [self setNeedsLayout];
    
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerEditDone)]) {
        [self.delegate headerEditDone];
    }
}
- (void)actionEditCancel:(id)sender {
    DLog();
    
    // editing
    editing = NO;
    [self setNeedsLayout];
    
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerEditCancel)]) {
        [self.delegate headerEditCancel];
    }
}

/*
 * Action.
 */
- (void)actionAction:(id)sender {
    DLog();
    
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerAction)]) {
        [self.delegate headerAction];
    }
}



#pragma mark -
#pragma mark Business

/*
 * Header title.
 */
- (void)head:(NSString*)title {
    [_labelTitle setText:title];
}



#pragma mark -
#pragma mark Memory Management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
    [_buttonBack release];
    [_buttonEdit release];
    [_buttonEditDone release];
    [_buttonEditCancel release];
    [_buttonAction release];
    [_labelTitle release];
	
	// sup
	[super dealloc];
}

@end
