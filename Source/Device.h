//
//  Device.h
//  Solyaris
//
//  Created by Beat Raess on 21/09/14.
//
//

#import <Foundation/Foundation.h>

/**
 * Device.
 */
@interface Device : NSObject

/**
 * Device retina.
 * @return True if retina.
 */
+ (BOOL)retina;

/**
 * Device resolution.
 * @return Resolution.
 */
+ (CGFloat)resolution;

/**
 * Device iPhone 4inch.
 * @return True if 4inch.
 */
+ (BOOL)iphone_4inch;

/**
 * Device screen.
 * @return Dimension in current orientation.
 */
+ (CGRect)screen;

/**
 * Device landscape.
 * @return True if landscape.
 */
+ (BOOL)landscape;

/**
 * Device portrait.
 * @return True if portrait.
 */
+ (BOOL)portrait;

@end
