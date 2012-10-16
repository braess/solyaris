//
//  HTMLView.h
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

#import <UIKit/UIKit.h>


/**
 * HTMLDelegate Protocol.
 */
@protocol HTMLDelegate <NSObject>
@optional
- (void)navigateBack;
- (void)navigateForward;
@end

// Alerts
enum {
    HTMLAlertExternal
};

/**
 * HTMLView.
 */
@interface HTMLView : UIView <UIWebViewDelegate, UIAlertViewDelegate> {
    
	// delegate
	id<HTMLDelegate>delegate;
	
	// UI
	UIWebView *_webView;
    
    // private
    @private
    NSMutableString *_home;
    NSMutableString *_base;
    NSMutableString *_external;
    bool _loaded;
    bool _based;
    
}

// Properties
@property (assign) id<HTMLDelegate> delegate;
@property (nonatomic, retain) UIWebView *webView;

// Object Methods
- (id)initWithFrame:(CGRect)frame scrolling:(BOOL)bounces;

// Methods
- (void)reset:(NSString*)home;
- (void)base:(NSString*)base;
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

