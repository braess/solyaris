//
//  CacheImageView.h
//  Solyaris
//
//  Created by CNPP on 31.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
    NSString *_link;
    bool loaded;
}


// New Business
- (void)placeholderImage:(UIImage *)img;
- (void)loadImage:(NSString*)link;
- (void)lazyloadImage:(NSString*)link;
- (void)load;
- (void)cancel;
+ (void)clearCache;

@end
