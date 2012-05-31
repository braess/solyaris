//
//  CacheImageView.m
//  Solyaris
//
//  Created by CNPP on 31.8.2011.
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
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        
        // image view
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
        iv.backgroundColor = [UIColor clearColor];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        iv.clipsToBounds = YES;
        
        // add
        _imageView = [iv retain];
        [self addSubview:_imageView];
        [iv release];
        
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
        NSMutableString *lnk = [[NSMutableString alloc] init];
        _link = [lnk retain];
        [lnk release];
        
        
        // reset
        [self reset];
 
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
#pragma mark Class

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
#pragma mark New Business


/**
 * Reset.
 */
- (void)reset {
    GLog();
    
   // cancel
   [self cancel];
    
}


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
    [_link setString:link];
    
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
    [_link setString:link];
    
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
 * Cancels loading.
 */
- (void)cancel {
    
    // cancel connection
    if (_connection != nil) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    
    // release data
    if (_receivedData != nil) {
        [_receivedData release];
        _receivedData = nil;
    }
    
    // hide activity
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
    
    
    // placeholder
    _imageView.image = _placeholderImage;
    _imageView.hidden = NO;
    
    // error
    _iconError.hidden = YES;
    
    // vars
    [_link setString:@""];
    
    // loaded
    loaded = NO;
    loading = NO;
    
    // redraw
    [self setNeedsLayout];
}


/**
 * Indicates if loaded.
 */
- (BOOL)loaded {
    return loaded;
}


/**
 * Returns the loaded image.
 */
- (UIImage*)cachedImage {
    return _imageView.image;
}


/**
 * Returns the image view.
 */
- (UIImageView*)imageView {
    return _imageView;
}


#pragma mark -
#pragma mark URL Connection


/*
 * Loads an image from the linkurl.
 */
- (void)urlImageLoad {
    FLog();
        
    // url
    NSURL *url = [NSURL URLWithString: _link];
    
    // loading
    loading = YES;
    
    // request
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
}

/*
 * Connection.
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // nop
    if (! loading || ! [[response MIMEType] hasPrefix:@"image"]) {
        [self cancel];
        return;
    }
    
	// every time we get an response it might be a forward, so we discard what data we have
    if (_receivedData != nil) {
        [_receivedData release];
        _receivedData = nil;
    }
    
    // prepare data
	_receivedData = [[NSMutableData alloc] init];
    [_receivedData setLength:0];

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // check data
    if (loading && _receivedData) {
        [_receivedData appendData:data]; // CRASH
    }
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
    if (_receivedData) {
        _imageView.image = [UIImage imageWithData:_receivedData];
    }
    
    // cache it
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:[CacheImageView cacheDirectory] withIntermediateDirectories:YES attributes:nil error:&error];
    if (! error && [_receivedData length] > 0) {
        [_receivedData writeToFile:[self cacheFilePath] atomically:YES];
    }
    
    // release connection
	if (_connection != nil) {
        [_connection release];
        _connection = nil;
    }
    
    // release data
    if (_receivedData != nil) {
        [_receivedData release];
        _receivedData = nil;
    }
    
    // loaded
    loading = NO;
    loaded = YES;
    
    // show
    [self animationImageLoaded];
}

/*
 * Somethings fishy.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // cancel
    [self cancel];
    
    // error
    if (_placeholderImage == NULL) {
        _iconError.hidden = NO;
    }
  
}



#pragma mark -
#pragma mark Cache


/*
 * Loads a cached image.
 */
- (void)cacheImageLoad {
    GLog();
    
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
    
    
    // ui
    [_imageView release];
    [_activityIndicator release];
    if (_placeholderImage != NULL) {
        [_placeholderImage release];
    }
    
    // vars
    [_link release];
    
    // view
    [super dealloc];
}



@end
