//
//  Tracker.m
//  P5P
//
//  Created by CNPP on 17.3.2011.
//  Copyright Beat Raess 2011. All rights reserved.
//
//  This file is part of P5P.
//  
//  P5P is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  P5P is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with P5P.  If not, see www.gnu.org/licenses/.

#import "Tracker.h"
#import "APIKeys.h"
#import "GANTracker.h"


// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 20;


/**
 * Tracker.
 */
@implementation Tracker


#pragma mark -
#pragma mark Class Methods

/**
 * Starts/stops the tracker.
 */
+ (void)startTracker {

    #ifndef DEBUG
	// shared tracker
	[[GANTracker sharedTracker] startTrackerWithAccountID:kGoogleAnalytics
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
	
	// ios variable
    NSString *version = [device systemVersion];
	[[GANTracker sharedTracker] setCustomVariableAtIndex:TrackerVariableIOS+1 name:@"ios" value:version scope:kGANSessionScope withError:&error]
    #else
    NSLog(@"Tracker: start");
    #endif
}
+ (void)stopTracker {
	DLog();
	
    // stop 
    #ifndef DEBUG
	[[GANTracker sharedTracker] stopTracker];
    #else
    NSLog(@"Tracker: stop");
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
    NSLog(@"Tracker: dispatch");
    #endif

}


/**
 * Tracks a page view.
 */
+ (void)trackPageView:(NSString*)page {
	
    // track page view
    #ifndef DEBUG
	[[GANTracker sharedTracker] trackPageview:page withError:&error]
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
	[[GANTracker sharedTracker] trackEvent:category action:action label:label value:-1 withError:&error]
    #else
    NSLog(@"Tracker: Event %@ %@ %@",category,action,label);
    #endif
}

@end
