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
@end


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
	buttonObj.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    buttonObj.layer.cornerRadius = 3;
    buttonObj.layer.masksToBounds = YES;
    buttonObj.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [buttonObj setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:0.8]];
    [buttonObj setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.75] forState:UIControlStateNormal];
	[buttonObj setTitle:@"Button" forState:UIControlStateNormal];
				
	// targets and actions
	[buttonObj addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
				
	// accessory
	self.buttonAccessory = buttonObj;
	self.accessoryView = buttonAccessory;
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
* Switch value changed.
*/
- (void)buttonTouchUpInside:(UIButton*)b {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellButtonTouched:)]) {
		[delegate cellButtonTouched:self];
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