//
//  HTMLView.m
//  IMDG
//
//  Created by CNPP on 2.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
        
        // user agent
        NSDictionary *userAgentReplacement = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50", @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:userAgentReplacement];
		
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
    _home = [home retain];
    
    // not loaded
    loaded = NO;
	
	// load request
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *resource = [mainBundle pathForResource:kHTMLViewPreload ofType:@"html"];
	NSURL *appURL = [NSURL fileURLWithPath:resource];
	NSURLRequest *appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
	[_webView loadRequest:appReq];

}

/**
 * Loads the default home.
 */
- (void)load {
    FLog();
    
    // check
    if (! loaded) {
        [self navigateHome];
        loaded = YES;
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
            [(UIScrollView*)subview setContentOffset:CGPointZero animated:animated];
        }
    }
}



#pragma mark -
#pragma mark WebView Delegate

/*
 * Called when the webview finishes loading.
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    // don't miss home
    if (loaded && [[_webView.request.URL scheme] isEqualToString:@"file"]) {
        [self navigateHome];
    }

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
        CGRect bframe = CGRectMake(0, 4, 32, 32);
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
