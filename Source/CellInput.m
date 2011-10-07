//
//  CellInput.m
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
	self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
    self.textLabel.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
    self.detailTextLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    
    // help
    help = @"";
    
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
	self.detailTextLabel.text = help;
}




#pragma mark -
#pragma mark TableCell Methods

/*
 * Draws the cell.
 */
- (void)drawRect:(CGRect)rect {
    //[super drawRect:rect];
	
    // get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    //CGContextSetShouldAntialias(ctx, NO);
    
    // background
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.03].CGColor);
	CGContextFillRect(ctx, rect);
    
    // lines
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(ctx, rect.origin.x, 0);
	CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, 0);
	CGContextStrokePath(ctx);
    
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
