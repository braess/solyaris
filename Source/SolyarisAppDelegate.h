//
//  SolyarisAppDelegate.h
//  Solyaris
//
//  Created by Beat Raess on 7.10.2011.
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
