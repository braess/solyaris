//
//  HTMLView.h
//  IMDG
//
//  Created by CNPP on 2.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * HTMLDelegate Protocol.
 */
@protocol HTMLDelegate <NSObject>
@optional
- (void)navigateBack;
- (void)navigateForward;
@end



/**
 * HTMLView.
 */
@interface HTMLView : UIView <UIWebViewDelegate> {
    
	// delegate
	id<HTMLDelegate>delegate;
	
	// UI
	UIWebView *_webView;
    
    // private
    @private
    NSString *_home;
    bool loaded;
    
}

// Properties
@property (assign) id<HTMLDelegate> delegate;
@property (nonatomic, retain) UIWebView *webView;

// Object Methods
- (id)initWithFrame:(CGRect)frame scrolling:(BOOL)bounces;

// Methods
- (void)reset:(NSString*)home;
- (void)load;
- (void)loadURL:(NSString*)url;
- (void)navigateHome;
- (void)navigateBack;
- (void)navigateForward;
- (void)scrollTop:(bool)animated;
- (void)resize;

@end


/**
 * HTMLNavigatorView.
 */
@interface HTMLNavigatorView : UIView {
    
	// delegate
	id<HTMLDelegate>delegate;
	
    
}

// Properties
@property (assign) id<HTMLDelegate> delegate;


// Object Methods
- (id)initWithFrame:(CGRect)frame;


@end

