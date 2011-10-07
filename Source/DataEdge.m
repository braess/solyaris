//
//  DataEdge.m
//  Solyaris
//
//  Created by CNPP on 30.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "DataEdge.h"

/**
 * DataEdge.
 */
@implementation DataEdge

#pragma mark -
#pragma mark Properties

// accessors
@synthesize eid;
@synthesize type;
@synthesize label;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initData:(NSString*)e type:(NSString*)t label:(NSString*)l {
    GLog();
    if ((self = [super init])) {
        self.eid = e;
        self.type = t;
		self.label = l;
		return self;
	}
	return nil;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
    [eid release];
    [type release];
	[label release];
	
	// super
    [super dealloc];
}


@end
