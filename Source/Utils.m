//
//  Utils.m
//  Solyaris
//
//  Created by Beat Raess on 28.3.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import "Utils.h"


/**
 * Utils.
 */
@implementation Utils


/**
 * Detect retina display.
 */
+ (BOOL)isRetina {
    
    // scale
    static CGFloat scale = 0.0;
    if (scale == 0.0) {
        
        // check
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
            scale = 2.0;
            return YES;
        } else {
            scale = 1.0;
            return NO;
        }   
        
    }
    return scale > 1.0;
}

@end
