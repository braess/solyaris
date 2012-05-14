//
//  PageControl.m
//  Solyaris
//
//  Created by Beat Raess on 14.5.2012.
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

#import "PageControl.h"

/**
 * PageControl.
 */
@implementation PageControl


#pragma mark -
#pragma mark Properties

// accessors
@synthesize numberOfPages, hidesForSinglePage, inactivePageColor, activePageColor;
@dynamic currentPage;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // super
    if (self == [super initWithFrame:frame]) {
        
        // self
        self.contentMode = UIViewContentModeRedraw;
        
        self.backgroundColor = [UIColor clearColor];
        self.inactivePageColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.9];
        self.activePageColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.9];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        // fields
        hidesForSinglePage = NO;
    }
    return self;
}

/*
 * Draw.
 */
- (void)drawRect:(CGRect)rect {
	
	// decide
	if (hidesForSinglePage == NO || [self numberOfPages] > 1){
        
		// defaults
		if (activePageColor == nil){
			activePageColor = [UIColor blackColor];
		}
		
		if (inactivePageColor == nil){
			inactivePageColor = [UIColor grayColor];
		}
		
		// vars
		CGContextRef context = UIGraphicsGetCurrentContext();
		float dotSize = self.frame.size.height / 6;		
		float dotsWidth = (dotSize * [self numberOfPages]) + (([self numberOfPages] - 1) * 10);
		float offset = (self.frame.size.width - dotsWidth) / 2;
		
		// draw dots
		for (NSInteger i = 0; i < [self numberOfPages]; i++){
			if (i == [self currentPage]){
				CGContextSetFillColorWithColor(context, [activePageColor CGColor]);
			} 
			else {
				CGContextSetFillColorWithColor(context, [inactivePageColor CGColor]);
			}
			
			CGContextFillEllipseInRect(context, CGRectMake(offset + (dotSize + 10) * i, (self.frame.size.height / 2) - (dotSize / 2), dotSize, dotSize));
		}
	}
}

#pragma mark -
#pragma mark Business Methods

/*
 * Current.
 */
- (NSInteger) currentPage{
	return currentPage;
}

- (void) setCurrentPage:(NSInteger)page {
	currentPage = page;
	[self setNeedsDisplay];
}


#pragma mark -
#pragma mark Memory Management

/*
 * Dealloc.
 */
- (void)dealloc {
    
    // sup
    [super dealloc];
}


@end
