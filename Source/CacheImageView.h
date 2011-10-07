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
    UIImage *_placeholderImage;
    UIActivityIndicatorView *_activityIndicator;
    
    // private
    @private
    NSString *_url;
    bool loaded;
}

// Business
- (void)placeholderImage:(UIImage*)img;
- (void)loadFromURL:(NSString*)link;
- (void)lazyloadFromURL:(NSString*)link;
- (void)load;

@end
