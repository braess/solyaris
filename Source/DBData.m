//
//  DBData.m
//  Solyaris
//
//  Created by Beat Raess on 7.5.2012.
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

#import "DBData.h"

/**
 * DBData.
 */
@implementation DBData

#pragma mark -
#pragma mark Properties

// accessors
@synthesize dta;
@synthesize ref;
@synthesize src;
@synthesize type;
@synthesize label;
@synthesize thumb;
@synthesize sort;
@synthesize more;

#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)init {
    GLog();
    // super
    if ((self = [super init])) {
        
        // self
        self.dta = -1;
        self.ref = [NSNumber numberWithInt:-1];
        self.src = [NSNumber numberWithInt:-1];
        self.type = @"";
		self.label = @"";
        self.thumb = @"";
        
        // init
        self.sort = [NSNumber numberWithInt:0];
        self.more = NO;
        
	}
	return self;
}
- (id)initData:(int)dta_ ref:(NSNumber *)dta_ref type:(NSString *)dta_type label:(NSString *)dta_label thumb:(NSString *)dta_thumb {
    GLog();
    
    // super
    if ((self = [super init])) {
        
        // self
        self.dta = dta_;
        self.ref = dta_ref;
        self.type = dta_type;
		self.label = dta_label;
        self.thumb = dta_thumb;
        
        // init
        self.sort = [NSNumber numberWithInt:0];
        self.more = NO;

	}
	return self;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
    [ref release];
    [src release];
    [type release];
	[label release];
    [thumb release];
	[sort release];
    
	// super
    [super dealloc];
}

@end
