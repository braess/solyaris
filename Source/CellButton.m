//
//  CellButton.m
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
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



/**
 * CellButton.
 */
@implementation CellButton

#pragma mark -
#pragma mark Constants




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
    
    // image
    UIImage *button30 = [[UIImage imageNamed:@"app_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button30_high = [[UIImage imageNamed:@"app_button-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [buttonObj setBackgroundImage:[button30 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal];
    [buttonObj setBackgroundImage:[button30_high resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateHighlighted];
    
    // font
    buttonObj.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    buttonObj.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    buttonObj.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.9];
    buttonObj.titleLabel.shadowOffset = CGSizeMake(0,-1);
    [buttonObj setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    
	[buttonObj setTitle:@"Button" forState:UIControlStateNormal];
    
				
	// targets and actions
	[buttonObj addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [buttonObj addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [buttonObj addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [buttonObj addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
				
	// accessory
	self.buttonAccessory = buttonObj;
	self.accessoryView = buttonAccessory;

    // return
    return self;
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
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellButtonDown:)]) {
		[delegate cellButtonDown:self];
	}
}
- (void)buttonUp:(UIButton*)b {
	GLog();
	
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
    [super dealloc];
}

@end
