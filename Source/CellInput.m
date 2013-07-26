//
//  CellInput.m
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

#import "CellInput.h"

/**
* Abstract CellInput.
*/
@implementation CellInput


#pragma mark -
#pragma mark Properties

// accessors
@synthesize key;
@synthesize help;
@synthesize clear;


#pragma mark -
#pragma mark TableCell Methods

/*
 * Init cell.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        
        // self
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.editingAccessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // labels
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        self.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
        self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        self.detailTextLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        
        // help
        help = @"";
        
        // clear
        clear = YES;

    }
    return self;
}


/*
 * Selected.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

/*
 * Highlight.
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:NO];
    [self setNeedsDisplay];
}



#pragma mark -
#pragma mark Business

/**
* Updates the cell.
*/
- (void)update:(BOOL)reset {
	self.detailTextLabel.text = help;
}




#pragma mark -
#pragma mark TableCell Methods

/*
 * Draws the cell.
 */
- (void)drawRect:(CGRect)rect {
	
    // context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // clear
    if (clear) {
        
        // background
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.012].CGColor);
        CGContextFillRect(ctx, rect);
        
        // lines
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
        CGContextMoveToPoint(ctx, rect.origin.x, 0);
        CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, 0);
        CGContextStrokePath(ctx);
    }
    else {
        
        // background
        UIColor *bgc = self.highlighted ? [UIColor colorWithWhite:0.99 alpha:1] : [UIColor colorWithWhite:1 alpha:1];
        CGContextSetFillColorWithColor(ctx, bgc.CGColor);
        CGContextFillRect(ctx, rect);
        
        // lines
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.87 alpha:1].CGColor);
        CGContextMoveToPoint(ctx, rect.origin.x, rect.size.height);
        CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, rect.size.height);
        CGContextStrokePath(ctx);
    }
    
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[key release];
    [help release];
    [super dealloc];
}

@end
