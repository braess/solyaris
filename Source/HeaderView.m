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


/**
 * HeaderView.
 */
@implementation HeaderView


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize back = mode_back;
@synthesize labelTitle = _labelTitle;
@synthesize buttonBack = _buttonBack;


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
        mode_back = YES;
        
        
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
    CGRect frameTitle = CGRectMake(frameBack.size.width-(mode_back ? 5 : 0), 0, self.frame.size.width-frameBack.size.width, kHeaderHeight);
    
    // button
    _buttonBack.hidden = ! mode_back;
    _buttonBack.frame = frameBack;
    
    // title
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
    if (delegate && [delegate respondsToSelector:@selector(headerBack)]) {
        [delegate headerBack];
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
    [_labelTitle release];
	
	// sup
	[super dealloc];
}

@end
