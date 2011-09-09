//
//  DataNode.m
//  IMDG
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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

- (id)initData:(NSNumber *)n type:(NSString *)t label:(NSString *)l meta:(NSString *)m edge:(NSString*)e visible:(_Bool)iv loaded:(_Bool)il {
    GLog();
    if ((self = [super init])) {
        self.nid = n;
        self.type = t;
		self.label = l;
		self.meta = m;
        self.edge = e;
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
	
	// super
    [super dealloc];
}

@end
