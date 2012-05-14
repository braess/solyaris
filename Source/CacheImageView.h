//
//  CacheImageView.h
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

#import <UIKit/UIKit.h>


/**
 * A simple cache image view.
 */
@interface CacheImageView : UIView {
    
    // data
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
    
    // loader
    UIImageView *_imageView;
    UIActivityIndicatorView *_activityIndicator;
    UIImageView *_iconError;
    UIImage *_placeholderImage;
    
    // private
    @private
    NSMutableString *_link;
    bool loaded;
}


// New Business
- (void)placeholderImage:(UIImage *)img;
- (void)loadImage:(NSString*)link;
- (void)lazyloadImage:(NSString*)link;
- (void)load;
- (void)cancel;
- (BOOL)loaded;
- (void)reset;
- (UIImage*)cachedImage;
- (UIImageView*)imageView;
+ (void)clearCache;

@end
