//
//  SolyarisAppDelegate.m
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

#import "SolyarisAppDelegate.h"
#import "AppControllers.h"
#import "SolyarisConstants.h"
#import "TMDb.h"
#import "NoteView.h"
#import "CacheImageView.h"
#import "Tracker.h"

/**
 * Solyaris AppDelegate.
 */
@implementation SolyarisAppDelegate



#pragma mark -
#pragma mark Application lifecycle


/*
 * Application launched.
 */
- (void) applicationDidFinishLaunching:(UIApplication *)application {
    
    // launch
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"Solyaris version %@ launched.",appVersion);
    
    // track
	[Tracker startTracker];
    [Tracker trackEvent:TEventUsage action:@"Launch" label:appVersion];
    
    // customize appearance
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [AppControllers appAppearance];
    
    // version
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *information_app_version = [userDefaults objectForKey:udInformationAppVersion];
	
	// install
	if (information_app_version == nil) {
		[self install:appVersion];
	}
	// update
	else if (! [appVersion isEqualToString:information_app_version]) {
		[self update:appVersion];
	}
    
    // cinder
    [super applicationDidFinishLaunching:application];
}

/*
 * App will enter foreground after resigning.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    DLog();
    
    // cinder
    [super applicationWillEnterForeground:application];
    
}

/*
 * App did become active and is now running.
 */
- (void) applicationDidBecomeActive:(UIApplication *)application {
    DLog();
    
    // track
	[Tracker trackEvent:TEventUsage action:@"Active" label:@""];
    
    // cinder
    [super applicationDidBecomeActive:application];
    
}


/*
 * App will resign active.
 */
- (void) applicationWillResignActive:(UIApplication *)application {
    DLog();
    
    // track
	[Tracker trackEvent:TEventUsage action:@"Resign" label:@""];
    
    // dispatch
    [Tracker dispatch];
    
    // cinder
    [super applicationWillResignActive:application];
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    DLog();
    
    // cinder
    [super applicationDidEnterBackground:application];
}


/*
 * App will terminate.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    DLog();
    
    // track
	[Tracker trackEvent:TEventUsage action:@"Terminate" label:@""];
    
    // dispatch
    [Tracker dispatch];
    
    // cinder
    [super applicationWillTerminate:application];

}


#pragma mark -
#pragma mark Busy Business Methods

/*
 * Installes the app.
 */
- (void)install:(NSString*)appVersion {
	NSLog(@"Solyaris version %@ installed.",appVersion);
	
	// track
	[Tracker trackEvent:TEventApp action:@"Install" label:appVersion];
	
	// defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// reset user defaults
	[userDefaults setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    
	// set version
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
    
    // init search term
    [userDefaults setObject:@"Kill Bill" forKey:udSearchTerm];
    
    // trigger
    [userDefaults setObject:appVersion forKey:triggerAppInstall];
    
    // synchronize
    [userDefaults synchronize];
    
    // check deprecated
    [self deprecated];

}

/*
 * Updates the app.
 */
- (void)update:(NSString*)appVersion {
	NSLog(@"Solyaris updated to version %@.",appVersion);
	
	// track
	[Tracker trackEvent:TEventApp action:@"Update" label:appVersion];
    
    // reset tmdb cache
    [TMDb clearCache];
    
    // reset image cache
    [CacheImageView clearCache];
	
	// defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	// set version
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
    
    // trigger
    [userDefaults setObject:appVersion forKey:triggerAppUpdate];
    
    // sync
	[userDefaults synchronize];
    
    // check deprecated
    if (! [self deprecated]) {
        
        // note
        Note *note = [[Note alloc] initNoteWithTitle:NSLocalizedString(@"Updated", @"Updated") message:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Solyaris", @"Solyaris"),appVersion ] type:noteTypeSuccess];
        
        // store
        [Note storeNote:note key:noteAppUpdate];
        [note release];
    }

}

/*
 * Deprecated.
 */
- (BOOL)deprecated {
    
    // ios4
    if (iOS4) {
        NSLog(@"Solyaris deprecated iOS4.");
        
        // track
        [Tracker trackEvent:TEventApp action:@"Deprecated" label:@"ios4"];
        
        // note
        Note *note = [[Note alloc] initNoteWithTitle:NULL message:NSLocalizedString(@"Thanks for using Solyaris. Please note that iOS4 is no longer fully supported.", @"Thanks for using Solyaris. Please note that iOS4 is no longer fully supported.") type:noteTypeInfo];
        
        // store
        [Note storeNote:note key:noteAppDeprecated];
        [note release];
        
        // yup
        return YES;
        
    }
    
    // nop
    return NO;
    
}



#pragma mark -
#pragma mark User Defaults

/**
 * Resets the user defaults.
 */
- (void)resetUserDefaults {
	FLog();
	
	// app version
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	// clear defaults & set version
	[userDefaults setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
	[userDefaults synchronize];

}

/**
 * Sets a user default.
 */
- (void)setUserDefault:(NSString*)key value:(NSObject*)value {
	GLog();
    
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// set
    if (value != NULL) {
        [userDefaults setObject:value forKey:key];
    }
    else {
        [userDefaults removeObjectForKey:key];
    }
    
    // sync
	[userDefaults synchronize];
    
}
- (void)setUserDefaultBool:(NSString*)key value:(BOOL)b {
	GLog();
    
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// set
	[userDefaults setBool:b forKey:key];
	[userDefaults synchronize];
    
}

/**
 * Gets a user default.
 */
- (NSObject*)getUserDefault:(NSString*)key {
	GLog();
    
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return
	return [userDefaults objectForKey:key];
}
- (BOOL)getUserDefaultBool:(NSString*)key {
	GLog();
    
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return
	return [userDefaults boolForKey:key]; 
}

/**
 * Removes a user default.
 */
- (void)removeUserDefault:(NSString *)key {
    FLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// set
	[userDefaults removeObjectForKey:key];
	[userDefaults synchronize];
}





#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void) dealloc {	
	[super dealloc];
}

@end

