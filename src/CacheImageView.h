//
//  CacheImageView.h
//  IMDG
//
//  Created by CNPP on 31.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A simple cache image view.
 */
@interface CacheImageView : UIImageView {
    
    // data
    NSURLConnection* connection;
    NSMutableData* data;
    
    // loader
    UIImage *_placeholderImage;
}

// Business
- (void)placeholderImage:(UIImage*)img;
- (void)loadImageFromURL:(NSString*)link;

@end
