//
//  VideoView.h
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

#import <UIKit/UIKit.h>


/**
 * Video View.
 */
@interface VideoView : UIView <UIWebViewDelegate> {
	
	// UI
	UIWebView *_webView;
    
    // private
    @private
    NSString *_url;
    bool loaded;
    
}

// Properties
@property (nonatomic, retain) UIWebView *webView;

// Object Methods
- (id)initWithFrame:(CGRect)frame scrolling:(BOOL)bounces;

// Methods
- (void)reset:(NSString*)url;
- (void)load;
- (void)unload;
- (void)loadVideo:(NSString*)url;
- (void)scrollTop:(bool)animated;
- (void)resize;

@end




//
//  DDURLParser.h
//  
//
//  Created by Dimitris Doukas on 09/02/2010.
//  Copyright 2010 doukasd.com. All rights reserved.
//


/*
 * URL Parser.
 */
@interface VideoURLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end
