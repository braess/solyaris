//
//  SolyarisAppDelegate.h
//  Solyaris
//
//  Created by Beat Raess on 7.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "cinder/app/AppNative.h"
#include "cinder/app/CinderAppDelegateIPhone.h"



/**
 * Solyaris AppDelegate.
 */
@interface SolyarisAppDelegate : CinderAppDelegateIPhone {
    cinder::app::AppCocoaTouch	*app;
}

// Business
- (void)update:(NSString*)appVersion;
- (void)install:(NSString*)appVersion;

// User Defaults
- (void)resetUserDefaults;
- (void)setUserDefault:(NSString*)key value:(NSObject*)value;
- (void)setUserDefaultBool:(NSString*)key value:(BOOL)b;
- (NSObject*)getUserDefault:(NSString*)key;
- (void)removeUserDefault:(NSString*)key;
- (BOOL)getUserDefaultBool:(NSString*)key;

@end
