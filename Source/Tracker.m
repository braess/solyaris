//
//  Tracker.m
//  P5P
//
//  Created by CNPP on 17.3.2011.
//  Copyright Beat Raess 2011. All rights reserved.
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

#import "Tracker.h"
#import "APIKeys.h"
#import "GANTracker.h"



/**
 * Tracker.
 */
@implementation Tracker


#pragma mark -
#pragma mark Constants

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 30;


#pragma mark -
#pragma mark Class Methods

/**
 * Starts/stops the tracker.
 */
+ (void)startTracker {

    // device
	NSString *device = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone";
	
	// version
	NSString *version = [[UIDevice currentDevice] systemVersion];
	
    // track
    #ifndef DEBUG
    
	// shared tracker
	[[GANTracker sharedTracker] startTrackerWithAccountID:kGoogleAnalytics
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    
    
	// device variable
	NSError *error;
	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:TrackerVariableDevice name:@"device" value:device scope:kGANSessionScope withError:&error]) {
		NSLog(@"Solyaris error in setting device variable");
	}
	
	// ios variable
	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:TrackerVariableIOS name:@"ios" value:version scope:kGANSessionScope withError:&error]) {
		NSLog(@"Solyaris error in setting ios variable");
	}
    
    // debug
    #else
    NSLog(@"Tracker: Start %@ %@",device,version);
    #endif
}
+ (void)stopTracker {
	DLog();
	
    // stop 
    #ifndef DEBUG
	[[GANTracker sharedTracker] stopTracker];
    #else
    NSLog(@"Tracker: Stop");
    #endif
}


/**
 * Dispatch events.
 */
+ (void)dispatch {
	FLog();
	
    // dispatch
    #ifndef DEBUG
	[[GANTracker sharedTracker] dispatch];
    #else
    NSLog(@"Tracker: Dispatch");
    #endif

}


/**
 * Tracks a page view.
 */
+ (void)trackPageView:(NSString*)page {
	
    // track page view
    #ifndef DEBUG
	[[GANTracker sharedTracker] trackPageview:page withError:nil];
    #else
    NSLog(@"Tracker: Page %@",page);
    #endif
}

/**
 * Tracks an event.
 */
+ (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label {
	
    // track event
    #ifndef DEBUG
	[[GANTracker sharedTracker] trackEvent:category action:action label:label value:-1 withError:nil];
    #else
    NSLog(@"Tracker: Event %@ %@ %@",category,action,label);
    #endif
}

@end
