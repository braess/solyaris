//
//  CellSegment.m
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellSegment.h"
#import <QuartzCore/QuartzCore.h>


/*
 * Helper Stack.
 */
@interface CellSegment (Helpers)
- (void)segmentValueChanged:(UISegmentedControl*)s;
- (void)changeSegmentFont:(UIView*)aView size:(int)size;
@end



/**
 * CellSegment.
 */
@implementation CellSegment



#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize segmentAccessory = _segmentAccessory;


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
	
	
	// segment
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 10, 100, 30)];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    
    
	// targets and actions
	[segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
	// accessory
	_segmentAccessory = segmentedControl;
	self.accessoryView = _segmentAccessory;
	[segmentedControl release];
    
    // return
    return self;
}


#pragma mark -
#pragma mark Business

/**
 * Updates the cell.
 */
- (void)update:(BOOL)reset {
	GLog();
    
    // all super
    [super update:reset];
    
    // font
    [self changeSegmentFont:_segmentAccessory size:10];
}

/**
 * Removes all segments.
 */
- (void)removeSegments {
    
    // insert
    [_segmentAccessory removeAllSegments];
}


/**
 * Adds a segment.
 */
- (void)addSegment:(NSString*)s {
    
    // insert
    [_segmentAccessory insertSegmentWithTitle:s atIndex:_segmentAccessory.numberOfSegments animated:NO];
}

/**
 * Selects a segment.
 */
- (void)selectSegment:(NSInteger)i {
    
    // select
    [_segmentAccessory setSelectedSegmentIndex:i];
}


#pragma mark -
#pragma mark Helpers

/*
 * Change.
 */
- (void)segmentValueChanged:(UISegmentedControl*)s {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellSegmentChanged:)]) {
		[delegate cellSegmentChanged:self];
	}
}

/*
 * Changes the font size.
 */
- (void)changeSegmentFont:(UIView*)aView size:(int)size {
	NSString* typeName = NSStringFromClass([aView class]);
	if ([typeName compare:@"UISegmentLabel" options:NSLiteralSearch] == NSOrderedSame) {
		UILabel* label = (UILabel*)aView;
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:size]];
	}
	NSArray* subs = [aView subviews];
	NSEnumerator* iter = [subs objectEnumerator];
	UIView* subView;
	while ((subView = [iter nextObject])) {
		[self changeSegmentFont:subView size:12];
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
