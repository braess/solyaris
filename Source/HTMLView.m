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
#pragma mark Object

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	
	// init UIView
    if ((self = [super initWithFrame:frame])) {
        
        // view
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.backgroundColor = [UIColor whiteColor];
		
		// init web view
		UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
		webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        webView.scalesPageToFit = YES;
		webView.backgroundColor = [UIColor whiteColor];
		webView.delegate = self;
		
		// retain
        _webView = [webView retain];
		[self addSubview:_webView];
        [webView release];
        
        // loader
        UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loader.hidden = YES;
        _loader = [loader retain];
        [self addSubview:_loader];
        [loader release];
        
        NSMutableString *base = [[NSMutableString alloc] init];
        _base = [base retain];
        [base release];
        
        NSMutableString *external = [[NSMutableString alloc] init];
        _external = [external retain];
        [external release];
    }
    return self; 
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // frames
    CGRect fSelf = self.frame;
    CGRect fWeb = CGRectMake(0, 0, fSelf.size.width, fSelf.size.height);
    CGPoint cLoader = CGPointMake(fSelf.size.width/2.0, 60);
    
    // ui
    _webView.frame = fWeb;
    _loader.center = cLoader;
}



#pragma mark -
#pragma mark Business

/**
 * Reset.
 */
- (void)reset {
	FLog();
    
    // unload
    [_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    
    // not loaded
    _webView.hidden = YES;

}


/**
 * Loads the url.
 */
- (void)load:(NSString *)url base:(NSString *)base {
    FLog();
    
    // base
    [_base setString:base];
    
    // load
    _loaded = NO;
    _loader.hidden = NO;
    [_loader startAnimating];
    
    // request
    [_webView stopLoading];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0]];
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
 * Loading finished.
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    GLog();
    
    // loaded
    if (! _loaded) {
        _loaded = YES;
        
        // stop loader
        [_loader stopAnimating];
        _loader.hidden = YES;
        
        // show
        _webView.hidden = NO;
    }
    
}


/*
 * Loading failed.
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    GLog();
    
    // loaded
    if (! _loaded) {
        _loaded = YES;
        
        // stop loader
        [_loader stopAnimating];
        _loader.hidden = YES;
    }
    
    // fatal
    if (error && (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotFindHost)) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Loading Failed",@"Loading Failed")
                              message:NSLocalizedString(@"Could not load page. Please try later.",@"Could not load page. Please try later.")
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:NSLocalizedString(@"OK",@"OK"),nil];
        [alert setTag:HTMLAlertFailed];
        [alert show];
        [alert release];
    }
    
}


/*
 * Loading request.
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	GLog();
    
    // restrict to base
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        // url
        NSString *url = [[request URL] absoluteString];
        
        // restrict
        if ([url rangeOfString:_base].location == NSNotFound) {
            
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



#pragma mark -
#pragma mark UIAlertViewDelegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // external
		case HTMLAlertExternal: {
            
			// open external
			if (buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_external]];
			}
			
            // break
			break;
		}
            
        // default
		default: {
			break;
		}
	}
	
}



#pragma mark -
#pragma mark Memory

/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
    
    // fields
    [_base release];
    [_external release];
	
	// release
    _webView.delegate = nil;
	[_webView release];
    [_loader release];
	
	// superduper
	[super dealloc];
}

@end