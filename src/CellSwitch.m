//
//  CellSwitch.m
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellSwitch.h"


/*
* Helper Stack.
*/
@interface CellSwitch (Helpers)
- (void)switchValueChanged:(UISwitch*)s;
@end


/**
 * Cell Switch.
 */
@implementation CellSwitch

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize switchAccessory;
@synthesize disabler;


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
    
    // background
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
	
	// switch
	UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
				
	// hammer time
	[switchObj addTarget:self action:@selector(switchValueChanged:) forControlEvents:(UIControlEventValueChanged)];
				
	// accessory
	self.switchAccessory = switchObj;
	self.accessoryView = switchAccessory;
	[switchObj release];

    // show yourself
    return self;
}





#pragma mark -
#pragma mark Helpers

/*
* Switch value changed.
*/
- (void)switchValueChanged:(UISwitch*)s {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellSwitchChanged:)]) {
		[delegate cellSwitchChanged:self];
	}
    
    // update
    [self update:NO];
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[switchAccessory release];
    [super dealloc];
}

@end
