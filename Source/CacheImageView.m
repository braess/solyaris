//
//  CacheImageView.m
//  Solyaris
//
//  Created by CNPP on 31.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CacheImageView.h"



/**
 * Cache Stack.
 */
@interface CacheImageView (CacheStack)
+ (NSString*)cacheDirectory;
- (NSString*)cacheFilePath;
- (BOOL)cacheImageExists;
- (void)cacheImageLoad;
@end

/**
 * Load Stack.
 */
@interface CacheImageView (URLStack)
- (void)urlImageLoad;
@end


/**
 * Animation Stack.
 */
@interface CacheImageView (AnimationStack)
- (void)animationImageLoaded;
@end


/**
 * A simple cache image view.
 */
@implementation CacheImageView


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeImageLoaded	0.45f
#define kCacheImageFolder       @"cimages"



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
        
        // placeholder
        _placeholderImage = NULL;
        
        // error
		UIImageView *iconError = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconError.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin );
		iconError.image = [UIImage imageNamed:@"icon_image_error.png"];
		iconError.backgroundColor = [UIColor clearColor];
		iconError.contentMode = UIViewContentModeCenter;
		iconError.hidden = YES;
        _iconError = [iconError retain];
        [self addSubview:_iconError];
        [iconError release];
        
        // link
        _link = @"a-cached-image.png";
 
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
    
    // error
    _iconError.frame = CGRectMake(self.frame.size.width/2.0 - 24, self.frame.size.height/2.0 - 24, 48, 48);
    
    // sup
    [super layoutSubviews];
}



#pragma mark -
#pragma mark New Business


/**
 * Sets the placeholder image.
 */
- (void)placeholderImage:(UIImage *)img {
    GLog();
    
    // reference
    _placeholderImage = [img retain];
    
    // set
    _imageView.image = _placeholderImage;
    [self setNeedsLayout];
    
}

/**
 * Loads an image.
 */
- (void)loadImage:(NSString *)link {
    GLog();
    
    // reference
    _link = [link copy];
    
    // placeholder
    _imageView.image = _placeholderImage;
    [self setNeedsLayout];
    
    // load
    loaded = NO;
    [self load];
    
}

/**
 * Lazyloads an image.
 */
- (void)lazyloadImage:(NSString *)link {
    GLog();
    
    // reference
    _link = [link copy];
    
    // placeholder
    _imageView.image = _placeholderImage;
    [self setNeedsLayout];
    
    // activity
    [_activityIndicator startAnimating];
    _activityIndicator.hidden = NO;
    
    // load
    loaded = NO;

}


/**
 * Loads the image.
 */
- (void)load {
    GLog();
    
    // hide error
    _iconError.hidden = YES;
    
    // check
    if (! loaded && _link != NULL && ! [_link isEqualToString:@""]) {
        
        // cached
        if ([self cacheImageExists]) {
            [self cacheImageLoad];
        }
        // from url
        else {
            [self urlImageLoad];
        }
    }
}


/**
 * Clears the cache.
 */
+ (void)clearCache {
    FLog();
    
    // remove dir
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[CacheImageView cacheDirectory] error:nil];
    if (error) {
         NSLog(@"CacheImage Error: %@", [error userInfo]);
    }

    
}


#pragma mark -
#pragma mark URL Connection


/*
 * Loads an image from the linkurl.
 */
- (void)urlImageLoad {
    FLog();
    
    // connection & data
    if (_connection!=nil) { 
        [_connection release]; 
    } 
    if (_receivedData!=nil) { 
        [_receivedData release]; 
    }
    
    // url
    NSURL *url = [NSURL URLWithString: _link];
    
    // request
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
}

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
    
    // prepare data
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
    [_activityIndicator stopAnimating];
	
	// make an image view for the image
    _imageView.image = [UIImage imageWithData:_receivedData];
    
    // cache it
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:[CacheImageView cacheDirectory] withIntermediateDirectories:YES attributes:nil error:&error];
    if (! error) {
        [_receivedData writeToFile:[self cacheFilePath] atomically:YES];
    }
    
    // release connection
	[_connection release];
	_connection=nil;
    
    // release data
	[_receivedData release]; 
	_receivedData=nil;
    
    
    // loaded
    loaded = YES;
    
    // show
    [self animationImageLoaded];
}

/*
 * Somethings fishy.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // release connection
	[_connection release];
	_connection=nil;
    
    // release data
	[_receivedData release]; 
	_receivedData=nil;
    
    // hide activity
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
    
    
    // placeholder
    _imageView.image = _placeholderImage;
    
    // error
    if (_placeholderImage == NULL) {
        _iconError.hidden = NO;
    }
    
    // loaded
    loaded = NO;
    
    // redraw
    [self setNeedsLayout];
  
}



#pragma mark -
#pragma mark Cache


/*
 * Loads a cached image.
 */
- (void)cacheImageLoad {
    FLog();
    
    // hide activity
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
	
	// make an image view for the image
    _imageView.image = [UIImage imageWithContentsOfFile: [self cacheFilePath]];
    
    // loaded
    loaded = YES;
    
    // show
    [self animationImageLoaded];
    
}


/*
 * Path to the cache image.
 */
- (NSString*)cacheFilePath {
    
    // file
    NSString *file = [_link stringByReplacingOccurrencesOfString:@"/" withString:@"$"];
    
    // path
    return [[CacheImageView cacheDirectory] stringByAppendingPathComponent:file];
    
}

/*
 * Returns the path to the directory.
 */
+ (NSString *)cacheDirectory {
	return [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],kCacheImageFolder];
}

/*
 * Checks if cached.
 */
- (BOOL)cacheImageExists {
    return [[NSFileManager defaultManager] fileExistsAtPath: [self cacheFilePath]];
}



#pragma mark -
#pragma mark Animation Stack

/*
 * Animation loaded.
 */
- (void)animationImageLoaded {
    GLog();
    
    // animate
    _imageView.alpha = 0;
	[UIView beginAnimations:@"cacheimage_loaded" context:nil];
	[UIView setAnimationDuration:kAnimateTimeImageLoaded];
    _imageView.alpha = 1.0f;
	[UIView commitAnimations];
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
    [_activityIndicator release];
    if (_link != NULL) {
        [_link release];
    }
    if (_placeholderImage != NULL) {
        [_placeholderImage release];
    }
    
    // view
    [super dealloc];
}



@end
