//
//  CacheImageView.m
//  IMDG
//
//  Created by CNPP on 31.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CacheImageView.h"


/**
 * A simple cache image view.
 */
@implementation CacheImageView



#pragma mark -
#pragma mark Business


/**
 * Sets the placeholder image.
 */
- (void)placeholderImage:(UIImage *)img {
    GLog();
    
    // set
    _placeholderImage = [img retain];
    self.image = _placeholderImage;
    [self setNeedsLayout];
}

/**
 * Loads an image.
 */
- (void)loadFromURL:(NSString*)link {
    GLog();
    
    // loader
    self.image = _placeholderImage;
    [self setNeedsLayout];
	
    // connection & data
    if (connection!=nil) { 
        [connection release]; 
    } 
	if (data!=nil) { 
        [data release]; 
    }
    
    // url
    NSURL *url = [NSURL URLWithString: link];
	
    // request
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
}


/**
 * Lazyloads an image.
 */
- (void)lazyloadFromURL:(NSString *)link {
    GLog();
    
    // url
    _url = [link copy];
}

/**
 * Lazyloads the image.
 */
- (void)lazyload {
    // check
    if (! loaded) {
        [self loadFromURL:_url];
    }
}



#pragma mark -
#pragma mark Delegate

/*
 * Connection.
 */
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    
    // append data
	if (data==nil) { 
        data = [[NSMutableData alloc] initWithCapacity:2048]; 
    } 
	[data appendData:incrementalData];
}

/*
 * Loaded.
 */
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    GLog();
    
	// release connection
	[connection release];
	connection=nil;
	
	//make an image view for the image
    self.image = [UIImage imageWithData:data];
	[self setNeedsLayout];
    
    // release data
	[data release]; 
	data=nil;
    
    // loaded
    loaded = YES;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    
    // connection
    [connection cancel]; 
	[connection release];
	[data release];
    
    // placeholder
    [_placeholderImage release];
    
    // view
    [super dealloc];
}



@end
