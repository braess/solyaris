//
//  VideoView.m
//  Solyaris
//
//  Created by Beat Raess on 22.12.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
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

#import "VideoView.h"
#import "SolyarisConstants.h"

/**
 * VideoView.
 */
@implementation VideoView


#pragma mark -
#pragma mark Constants

// constants
#define kVideoYouTube       @"http://www.youtube.com/watch?v="
#define kVideoYouTubeEmbed  @"http://www.youtube.com/embed/"



#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize webView = _webView;



#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame scrolling:YES];
}
- (id)initWithFrame:(CGRect)frame scrolling:(BOOL)bounces {
	GLog();
	
	// init UIView
    self = [super initWithFrame:frame];
	
	// init HTMLView
    if (self != nil) {
        
        // view
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
		
		// init web view
		_webView = [ [ UIWebView alloc ] initWithFrame:self.bounds];
		_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _webView.scalesPageToFit = YES;
		_webView.backgroundColor = self.backgroundColor;
		_webView.delegate = self;
		
		// bounces
		if (! bounces) {
			UIScrollView* sv = nil;
			for(UIView* v in _webView.subviews){
				if([v isKindOfClass:[UIScrollView class] ]){
					sv = (UIScrollView*) v;
					sv.scrollEnabled = NO;
					sv.bounces = NO;
				}
			}
		}
		
		// add it
		[self addSubview:_webView];
        
        // loaded
        NSMutableArray *videos = [[NSMutableArray alloc] init];
        _videos = [videos retain];
        [videos release];
        
        // state
        loaded = NO;
        
    }
    return self; 
}


#pragma mark -
#pragma mark VideoView Interface



/**
 * Reset trailer.
 */
- (void)reset {
    GLog();
    
    // unload
    [self unload];
    
    // reset
    [_videos removeAllObjects];
    
}
- (void)resetTrailer:(Movie *)movie {
	FLog();
    
    // reset
    [self reset];
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:TRUE];
	NSArray *assets = [[movie.assets allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    
    // backdrops
    for (Asset *a in assets) {
        
        // backdrop
        if ([a.type isEqualToString:assetTrailer]) {
            
            // video
            Video *v = [[Video alloc] initWithTitle:a.name url:a.value];
            [_videos addObject:v];
            [v release];
        }
    }

}

/*
 * Returns the video objects.
 */
- (NSArray*)videos {
    return _videos;
}


/**
 * Loads the default video.
 */
- (void)load:(int)ndx {
    FLog();
    
    // check
    if (! loaded && ndx < [_videos count]) {
        
        // video
        Video *v = [_videos objectAtIndex:ndx];
        [self loadYouTube:v.url];
    }
    
    // state
    loaded = YES;
}

/**
 * Unloads a video.
 */
- (void)unload {
    FLog();
    
    // state
    loaded = NO;
    
    // black out
    [_webView loadHTMLString:@"<html><head><style type='text/css'>html, body {background-color:white;}</style></head><body></body></html>" baseURL:nil];
}

/**
 * Loads a video.
 */
- (void)loadYouTube:(NSString *)vid {
    FLog();
    
    // embed
    NSString *embed = [NSString stringWithFormat:@"<iframe src='%@%@' frameborder='0' allowfullscreen></iframe>",kVideoYouTubeEmbed,vid];
    
    // html
    NSString *html = [NSString stringWithFormat:@"<html><head><style type='text/css'>html, body {display:table; width:100%%; height:100%%; margin:0; padding:0; font-family:Helvetica; -webkit-text-size-adjust: none; background-color:black;} iframe {width:100%%; height:100%%;} p {font-size:24px; line-height:30px; text-align:center; color:#FFFFFF; padding:90px 0 0 0; margin:0;} a, a:visited {color:#0077CC; text-decoration:underline;}</style></head><body>%@</body></html>",embed];

    
    // load
    [_webView loadHTMLString:html baseURL:nil];
    
}


/**
 * Scroll to top.
 */
- (void)scrollTop:(bool)animated {
    DLog();
    
    // scroll view
    for (UIView *subview in _webView.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)subview setContentOffset:CGPointZero animated:NO];
        }
    }
}


/*
 * Resize.
 */
- (void)resize {
    // nothing to do today
}




#pragma mark -
#pragma mark WebView Delegate

/*
 * Called when the webview finishes loading.
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
}



/*
 * Start Loading Request
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}



/*
 * Fail Loading With Error.
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}




#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
    
    // data
    [_videos release];
	
	// release
    _webView.delegate = nil;
	[_webView release];
	
	// super
	[super dealloc];
}

@end




/*
 * Video.
 */
@implementation Video

#pragma mark -
#pragma mark Properties

// synthesize
@synthesize title,url;


#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)initWithTitle:(NSString *)t url:(NSString *)u {
    GLog();
    
    // super
    if ((self = [super init])) {
        self.title = t;
        self.url = u;
    }
    return self;
}


#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void) dealloc{
    [title release];
    [url release];
    [super dealloc];
}

@end
