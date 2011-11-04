//
//  SolyarisAppDelegate.m
//  Solyaris
//
//  Created by Beat Raess on 7.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "SolyarisAppDelegate.h"
#import "SolyarisConstants.h"
#import "TMDb.h"
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
    
    // customize appearance
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
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
	[Tracker trackPageView:@"/"];
    
}


/*
 * App will resign active.
 */
- (void) applicationWillResignActive:(UIApplication *)application {
    DLog();
    
    // track
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
    
    // message
    [userDefaults setObject:appVersion forKey:msgAppInstall];
    
    // synchronize
    [userDefaults synchronize];

}

/*
 * Updates the app.
 */
- (void)update:(NSString*)appVersion {
	NSLog(@"Solyaris updated to version %@.",appVersion);
	
	// track
	[Tracker trackEvent:TEventApp action:@"Update" label:appVersion];
    
    // reset tmdb cache
    TMDb *tmdb = [[TMDb alloc] init];
    [tmdb clearCache];
    [tmdb release];
    
    // reset image cache
    [CacheImageView clearCache];
	
	// defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	// set version
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
    
    // message
    [userDefaults setObject:appVersion forKey:msgAppUpdate];
    
    // sync
	[userDefaults synchronize];

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

