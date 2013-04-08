//
//  HTMLView.m
//  Solyaris
//
//  Created by CNPP on 2.9.2011.
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

#import "HTMLView.h"



/**
 * HTMLView.
 */
@implementation HTMLView

#pragma mark -
#pragma mark Constants

// constants
#define kHTMLViewPreload	@"preload"
#define kHTMLViewHome       @"http://www.apple.com"


#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize delegate;
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
        
        // fields
        NSMutableString *home = [[NSMutableString alloc] init];
        _home = [home retain];
        [home release];
        
        NSMutableString *base = [[NSMutableString alloc] init];
        _base = [base retain];
        [base release];
        
        NSMutableString *external = [[NSMutableString alloc] init];
        _external = [external retain];
        [external release];
        
        // reset
        [self reset:kHTMLViewHome];
        
    }
    return self; 
}


#pragma mark -
#pragma mark HTMLView Interface

/**
 * Reset.
 */
- (void)reset:(NSString*)home {
	FLog();
    
    // home sweet home
    [_home setString:home];
    
    // not loaded
    _loaded = NO;
	
	// load request
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *resource = [mainBundle pathForResource:kHTMLViewPreload ofType:@"html"];
	NSURL *appURL = [NSURL fileURLWithPath:resource];
	NSURLRequest *appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
	[_webView loadRequest:appReq];

}

/**
 * Base.
 */
- (void)base:(NSString *)base {
    FLog();
    
    // base
    [_base setString:base];
    
    // mode
    _based = YES;
}

/**
 * Loads the default home.
 */
- (void)load {
    FLog();
    
    // check
    if (! _loaded) {
        [self navigateHome];
        _loaded = YES;
    }
}

/**
 * Location url.
 */
- (void)loadURL:(NSString*)url {
	FLog();
    
    // location
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.location.href='%@'",url]];

}


/**
 * Navigation.
 */
- (void)navigateHome {
    FLog();
    
    // home sweet home
    [self loadURL:_home];
}
- (void)navigateBack {
    FLog();
    
    // there and back again 
    [_webView goBack];
    
}
- (void)navigateForward {
    FLog();
    
    // forward ever, backwards never
    [_webView goForward];
}


/**
 * Scroll to top.
 */
- (void)scrollTop:(bool)animated {
    FLog();
    
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
    
    // don't miss home
    if (_loaded && [[_webView.request.URL scheme] isEqualToString:@"file"]) {
        [self navigateHome];
    }

}



/*
 * Start Loading Request
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
    // restrict to base
    if (_based && navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        // url
        NSString *url = [[request URL] absoluteString];
        
        // retstrict
        if (! [[request.URL scheme] isEqualToString:@"file"] && [url rangeOfString:_base].location == NSNotFound) {
            
            // external link
            [_external setString:url];
            
            // dispatch
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                // alert
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"Open in Safari?",@"Open in Safari?")
                                      message:[NSString stringWithFormat:NSLocalizedString(@"External link:\n%@",@"External link:\n%@"), _external]
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                      otherButtonTitles:NSLocalizedString(@"Open",@"Open"),nil];
                [alert setTag:HTMLAlertExternal];
                [alert show];
                [alert release];
            });
            
            // nop
            return NO;
        }
    }
    
    // yes, please
    return YES;
}



/*
 * Fail Loading With Error.
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    FLog();
}



#pragma mark -
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // external
		case HTMLAlertExternal: {
            
			// cancel
			if (buttonIndex == 0) {
			}
			// open external
			else {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_external]];
			}
			break;
		}
            
            // default
		default: {
			break;
		}
	}
	
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
    
    // fields
    [_home release];
    [_base release];
    [_external release];
	
	// release
	[_webView release];
	
	// superduper
	[super dealloc];
}




@end




/**
 * Action Stack.
 */
@interface HTMLNavigatorView (ActionStack)
- (void)actionNavigateBack:(id)sender;
- (void)actionNavigateForward:(id)sender;
@end


/**
 * HTMLNavigatorView.
 */
@implementation HTMLNavigatorView



#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize delegate;



#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id) initWithFrame:(CGRect)frame {
    
    // self
	if ((self = [super initWithFrame:frame])) {
        
        // self
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        // framed
        CGRect bframe = CGRectMake(0, 0, 44, 44);
        float inset = 8;
        
        // button back
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom]; 
        btnBack.frame = CGRectMake(0*(bframe.size.width+inset), bframe.origin.y, bframe.size.width, bframe.size.height);
        btnBack.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        [btnBack setImage:[UIImage imageNamed:@"btn_navigator-back.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(actionNavigateBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBack];
        
        // button forward
        UIButton *btnForward = [UIButton buttonWithType:UIButtonTypeCustom]; 
        btnForward.frame = CGRectMake(1*(bframe.size.width+inset), bframe.origin.y, bframe.size.width, bframe.size.height);
        btnForward.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        [btnForward setImage:[UIImage imageNamed:@"btn_navigator-forward.png"] forState:UIControlStateNormal];
        [btnForward addTarget:self action:@selector(actionNavigateForward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnForward];
    }
    return self;
}


#pragma mark -
#pragma mark Actions

/*
 * Navigate.
 */
- (void)actionNavigateBack:(id)sender {
    FLog();
    
    // delegate
    if (self.delegate && [delegate respondsToSelector:@selector(navigateBack)]) {
        [delegate navigateBack];
    }
}
- (void)actionNavigateForward:(id)sender {
    FLog();
    
    // delegate
    if (self.delegate && [delegate respondsToSelector:@selector(navigateForward)]) {
        [delegate navigateForward];
    }
}


@end
