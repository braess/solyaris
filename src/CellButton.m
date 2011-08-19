//
//  CellButton.m
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellButton.h"
#import <QuartzCore/QuartzCore.h>


/*
* Helper Stack.
*/
@interface CellButton (Helpers)
- (void)buttonTouchUpInside:(UIButton*)b;
- (void)buttonDown:(UIButton*)b;
- (void)buttonUp:(UIButton*)b;
@end


#define kAlphaBtn 0.8f
#define kAlphaBtnActive 0.96f

/**
 * CellButton.
 */
@implementation CellButton

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize buttonAccessory;


#pragma mark -
#pragma mark TableCell Methods

/*
 * Init cell.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
	GLog();
	
	// init cell
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self == nil) { 
        return nil;
    }
	
	// self
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.autoresizesSubviews = YES;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = YES;
	
	
	// button
	UIButton *buttonObj = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonObj.frame = CGRectMake(0, 10, 100, 30); 
    buttonObj.opaque = YES;
	buttonObj.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    buttonObj.layer.cornerRadius = 3;
    buttonObj.layer.masksToBounds = YES;
    buttonObj.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [buttonObj setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaBtn]];
    [buttonObj setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.75] forState:UIControlStateNormal];
	[buttonObj setTitle:@"Button" forState:UIControlStateNormal];
				
	// targets and actions
	[buttonObj addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [buttonObj addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [buttonObj addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [buttonObj addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
				
	// accessory
	self.buttonAccessory = buttonObj;
    self.buttonAccessory.alpha = kAlphaBtn;
	self.accessoryView = buttonAccessory;
    self.accessoryView.alpha = kAlphaBtn;
	[buttonObj release];

    // return
    return self;
}

/*
 * Disable highlighting of currently selected cell.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}


#pragma mark -
#pragma mark Business

/**
* Updates the cell.
*/
- (void)update:(BOOL)reset {
	GLog();
}


#pragma mark -
#pragma mark Helpers

/*
* Don't touch this.
*/
- (void)buttonTouchUpInside:(UIButton*)b {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellButtonTouched:)]) {
		[delegate cellButtonTouched:self];
	}
}
- (void)buttonDown:(UIButton*)b {
	GLog();
    
    // state
    [buttonAccessory setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaBtnActive]];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellButtonDown:)]) {
		[delegate cellButtonDown:self];
	}
}
- (void)buttonUp:(UIButton*)b {
	GLog();
    
    // state
    [buttonAccessory setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaBtn]];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellButtonUp:)]) {
		[delegate cellButtonUp:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	//[buttonAccessory release];
    [super dealloc];
}

@end
