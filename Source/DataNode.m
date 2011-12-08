//
//  DataNode.m
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
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

#import "DataNode.h"


/**
 * DataNode.
 */
@implementation DataNode

#pragma mark -
#pragma mark Properties

// accessors
@synthesize nid;
@synthesize type;
@synthesize label;
@synthesize meta;
@synthesize edge;
@synthesize loaded;
@synthesize visible;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initData:(NSNumber *)n type:(NSString *)t label:(NSString *)l meta:(NSString *)m edge:(DataEdge*)e visible:(_Bool)iv loaded:(_Bool)il {
    GLog();
    if ((self = [super init])) {
        self.nid = n;
        self.type = t;
		self.label = l;
		self.meta = m;
        self.edge = [e retain];
        self.visible = iv;
        self.loaded = il;
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
    [nid release];
    [type release];
	[label release];
	[meta release];
    [edge release];
	
	// super
    [super dealloc];
}

@end
