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
#import "Movie.h"
#import "Asset.h"

/**
 * Video View.
 */
@interface VideoView : UIView <UIWebViewDelegate> {
	
	// UI
	UIWebView *_webView;
    
    // private
    @private
    NSMutableArray *_videos;
    
    // state
    bool loaded;
    
}

// Properties
@property (nonatomic, retain) UIWebView *webView;

// Object Methods
- (id)initWithFrame:(CGRect)frame scrolling:(BOOL)bounces;

// Methods
- (void)reset;
- (void)resetTrailer:(Movie*)movie;
- (NSArray*)videos;
- (void)load:(int)ndx;
- (void)unload;
- (void)loadYouTube:(NSString*)vid;
- (void)scrollTop:(bool)animated;
- (void)resize;

@end




/**
 * Video.
 */
@interface Video : NSObject {
    
}

// Object
- (id)initWithTitle:(NSString*)t url:(NSString*)u;

// Properties
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* url;

@end
