//
//  DataEdge.m
//  Solyaris
//
//  Created by CNPP on 30.9.2011.
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
