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
#pragma mark Constants

// constants
#define kAnimateTimeImageLoaded	0.18f



#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // init
    if (self == [super initWithFrame:frame]) {
        
        // self
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        
        // image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        imageView.clipsToBounds = YES;
        
        // add
        _imageView = [imageView retain];
        [self addSubview:_imageView];
        [imageView release];
        
        // loader
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.hidden = YES;
        
        // add
        _activityIndicator = [activityIndicator retain];
        [self addSubview:_activityIndicator];
        [activityIndicator release];
 
    }
    return self;
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    
    // image view
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    // activity
    _activityIndicator.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    
    // sup
    [super layoutSubviews];
}


#pragma mark -
#pragma mark Business


/**
 * Sets the placeholder image.
 */
- (void)placeholderImage:(UIImage *)img {
    GLog();
    
    // set
    _placeholderImage = [img retain];
    _imageView.image = _placeholderImage;
    [self setNeedsLayout];
}

/**
 * Loads an image.
 */
- (void)loadFromURL:(NSString*)link {
    GLog();
    
    // url
    _url = [link copy];
    
    // loader
    _imageView.image = _placeholderImage;
    [self setNeedsLayout];
	
    // connection & data
    if (_connection!=nil) { 
        [_connection release]; 
    } 
	if (_receivedData!=nil) { 
        [_receivedData release]; 
    }
    
    // url
    NSURL *url = [NSURL URLWithString: link];
	
    // request
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
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
 * Loads the image.
 */
- (void)load {
    
    // check
    if (! loaded) {
        
        // activity
        _activityIndicator.hidden = NO;
        
        // load
        [self loadFromURL:_url];
    }
}



#pragma mark -
#pragma mark Delegate

/*
 * Connection.
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// every time we get an response it might be a forward, so we discard what data we have
	[_receivedData release], _receivedData = nil;
    
	// does not fire for local file URLs
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		NSHTTPURLResponse *httpResponse = (id)response;
        
		if (![[httpResponse MIMEType] hasPrefix:@"image"]) {
			//[self cancelLoading];
		}
	}
    
	_receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_receivedData appendData:data];
}

/*
 * Loaded.
 */
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    GLog();
    
    // hide activity
    _activityIndicator.hidden = YES;
	
	// make an image view for the image
    _imageView.image = [UIImage imageWithData:_receivedData];
    
    // animate
    _imageView.alpha = 0;
	[UIView beginAnimations:@"cacheimage_loaded" context:nil];
	[UIView setAnimationDuration:kAnimateTimeImageLoaded];
    _imageView.alpha = 1.3f;
	[UIView commitAnimations];
    
    // release connection
	[_connection release];
	_connection=nil;
    
    // release data
	[_receivedData release]; 
	_receivedData=nil;
    
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
    [_connection cancel]; 
	[_connection release];
	[_receivedData release];
    
    // ui
    [_imageView release];
    [_placeholderImage release];
    [_activityIndicator release];
    
    // view
    [super dealloc];
}



@end
