//
//  Device.m
//  Solyaris
//
//  Created by Beat Raess on 21/09/14.
//
//

#import "Device.h"
#import "SolyarisConstants.h"

/**
 * Device.
 */
@implementation Device


#pragma mark -
#pragma mark Device

/**
 * Device retina.
 */
+ (BOOL)retina {
    return [Device resolution] > 1.0;
}

/**
 * Device resolution.
 */
+ (float)resolution {
    
    // scale
    static CGFloat scale = 0.0;
    if (scale == 0.0) {
        
        // check
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            scale = [UIScreen mainScreen].scale;
        } else {
            scale = 1.0;
        }
        
    }
    return scale;
}

/**
 * Detect 4inch iPhone.
 */
+ (BOOL)iphone_4inch {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat sMax = MAX(screen.size.width, screen.size.height);
        if (sMax == 568) {
            return YES;
        }
    }
    return NO;
}

/**
 * Determine current screen size.
 */
+ (CGRect)screen {
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (iOS7) {
        return [Device landscape] ? CGRectMake(0, 0, screen.size.height, screen.size.width) : CGRectMake(0, 0, screen.size.width, screen.size.height);
    }
    else {
        return CGRectMake(0, 0, screen.size.width, screen.size.height);
    }
    
}

/**
 * Device screen portrait.
 */
+ (CGRect)screen_portrait {
    
    // screen
    CGRect screen = [Device screen];
    return CGRectMake(0, 0, MIN(screen.size.width, screen.size.height), MAX(screen.size.width, screen.size.height));
    
}


#pragma mark -
#pragma mark Orientation

/**
 * Device landscape.
 */
+ (BOOL)landscape {
    return UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

/**
 * Device portrait.
 */
+ (BOOL)portrait {
    return UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

@end
