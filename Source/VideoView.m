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


/**
 * VideoView.
 */
@implementation VideoView


#pragma mark -
#pragma mark Constants

// constants
#define kVideoMatchYouTube	@"youtube.com"
#define kVideoEmbedYouTube  @"http://www.youtube.com/embed/"



#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize webView = _webView;



#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id) initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame scrolling:YES];
}
- (id) initWithFrame:(CGRect)frame scrolling:(BOOL)bounces {
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
        loaded = NO;
        
    }
    return self; 
}


#pragma mark -
#pragma mark VideoView Interface



/**
 * Reset.
 */
- (void)reset:(NSString*)vid {
	FLog();
    
    // video url
    _url = [vid retain];
    
    // unload
    [self unload];
}

/**
 * Loads the default video.
 */
- (void)load {
    FLog();
    
    // check
    if (! loaded) {
        [self loadVideo:_url];
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
    [_webView loadHTMLString:@"<html><head><style type='text/css'>html, body {background-color:black;}</style></head><body></body></html>" baseURL:nil];
}

/**
 * Loads a video.
 */
- (void)loadVideo:(NSString *)url {
    FLog();
    
    // default
    NSString *embed = [NSString stringWithFormat:@"<p>Video Format currently not supported by Solyaris.</p><p>Try to watch it online: <br/><a href='%@'>%@</a></p>",url,url];
    
    
    // YouTube
    if ([url rangeOfString:kVideoMatchYouTube].location != NSNotFound) {
        
        // video id
        NSString *vid = NULL;
        
        // old style
        if ([url rangeOfString:@"v="].location != NSNotFound) {
            
            // parser
            VideoURLParser *parser = [[[VideoURLParser alloc] initWithURLString:url] autorelease];
            vid = [parser valueForVariable:@"v"];
        }
        
        // embed
        if (vid != NULL) {
            embed = [NSString stringWithFormat:@"<iframe src='%@%@' frameborder='0' allowfullscreen></iframe>",kVideoEmbedYouTube,vid];
        }
        
    }
    
    
    // html
    NSString *html = [NSString stringWithFormat:@"<html><head><style type='text/css'>html, body {display:table; width:100%%; height:100%%; margin:0; padding:0; font-family:Helvetica; -webkit-text-size-adjust: none; background-color:black;} iframe {width:100%%; height:100%%;} p {font-size:24px; line-height:30px; text-align:center; color:#FFFFFF; padding:90px 0 0 0; margin:0;} a, a:visited {color:#0077CC; text-decoration:underline;}</style></head><body>%@</body></html>",embed];

    
    // load
    //NSLog(@"%@",html);
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
    FLog();
}




#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[_webView release];
	
	// super
	[super dealloc];
}




@end



//
//  DDURLParser.m
//  
//
//  Created by Dimitris Doukas on 09/02/2010.
//  Copyright 2010 doukasd.com. All rights reserved.
//


/*
 * URL Parser.
 */
@implementation VideoURLParser
@synthesize variables;

- (id) initWithURLString:(NSString *)url{
    self = [super init];
    if (self != nil) {
        NSString *string = url;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempString;
        NSMutableArray *vars = [NSMutableArray new];
		//ignore the beginning of the string and skip to the vars
        [scanner scanUpToString:@"?" intoString:nil];
        while ([scanner scanUpToString:@"&" intoString:&tempString]) {
            [vars addObject:[tempString copy]];
        }
        self.variables = vars;
        [vars release];
    }
    return self;
}

- (NSString *)valueForVariable:(NSString *)varName {
    for (NSString *var in self.variables) {
        if ([var length] > [varName length]+1 && [[var substringWithRange:NSMakeRange(0, [varName length]+1)] isEqualToString:[varName stringByAppendingString:@"="]]) {
            NSString *varValue = [var substringFromIndex:[varName length]+1];
            return varValue;
        }
    }
    return nil;
}

- (void) dealloc{
    self.variables = nil;
    [super dealloc];
}

@end
