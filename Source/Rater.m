//
//  Rater.m
//  Solyaris
//
//  Created by Beat Raess on 4.6.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
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

/*
 * Rater.m
 * Rater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2012 Arash Payan. All rights reserved.
 */

#import "Rater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "Tracker.h"

NSString *const kRaterFirstUseDate				= @"kRaterFirstUseDate";
NSString *const kRaterUseCount					= @"kRaterUseCount";
NSString *const kRaterSignificantEventCount		= @"kRaterSignificantEventCount";
NSString *const kRaterCurrentVersion			= @"kRaterCurrentVersion";
NSString *const kRaterRatedCurrentVersion		= @"kRaterRatedCurrentVersion";
NSString *const kRaterDeclinedToRate			= @"kRaterDeclinedToRate";
NSString *const kRaterReminderRequestDate		= @"kRaterReminderRequestDate";

NSString *urlReviewIPad = @"itms-apps://itunes.apple.com/app/idAPP_ID";
NSString *urlReviewIPhone = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";




/**
 * Rater.
 */
@interface Rater ()
- (BOOL)connectedToNetwork;
+ (Rater*)sharedInstance;
- (void)showRatingAlert;
- (BOOL)ratingConditionsHaveBeenMet;
- (void)incrementUseCount;
- (void)hideRatingAlert;
@end


/**
 * Rater.
 */
@implementation Rater 

@synthesize ratingAlert;

- (BOOL)connectedToNetwork {
    
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[[NSURLConnection alloc] initWithRequest:testRequest delegate:self] autorelease];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

+ (Rater*)sharedInstance {
	static Rater *rater = nil;
	if (rater == nil)
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            rater = [[Rater alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:
             UIApplicationWillResignActiveNotification object:nil];
        });
	}
	
	return rater;
}

- (void)showRatingAlert {
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:RATER_MESSAGE_TITLE
														 message:RATER_MESSAGE
														delegate:self
											   cancelButtonTitle:RATER_CANCEL_BUTTON
											   otherButtonTitles:RATER_RATE_BUTTON, RATER_RATE_LATER, nil] autorelease];
	self.ratingAlert = alertView;
	[alertView show];
}

- (BOOL)ratingConditionsHaveBeenMet {
	if (RATER_DEBUG)
		return YES;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSDate *dateOfFirstLaunch = [NSDate dateWithTimeIntervalSince1970:[userDefaults doubleForKey:kRaterFirstUseDate]];
	NSTimeInterval timeSinceFirstLaunch = [[NSDate date] timeIntervalSinceDate:dateOfFirstLaunch];
	NSTimeInterval timeUntilRate = 60 * 60 * 24 * RATER_DAYS_UNTIL_PROMPT;
	if (timeSinceFirstLaunch < timeUntilRate)
		return NO;
	
	// check if the app has been used enough
	int useCount = [userDefaults integerForKey:kRaterUseCount];
	if (useCount <= RATER_USES_UNTIL_PROMPT)
		return NO;
	
	// check if the user has done enough significant events
	int sigEventCount = [userDefaults integerForKey:kRaterSignificantEventCount];
	if (sigEventCount <= RATER_SIG_EVENTS_UNTIL_PROMPT)
		return NO;
	
	// has the user previously declined to rate this version of the app?
	if ([userDefaults boolForKey:kRaterDeclinedToRate])
		return NO;
	
	// has the user already rated the app?
	if ([userDefaults boolForKey:kRaterRatedCurrentVersion])
		return NO;
	
	// if the user wanted to be reminded later, has enough time passed?
	NSDate *reminderRequestDate = [NSDate dateWithTimeIntervalSince1970:[userDefaults doubleForKey:kRaterReminderRequestDate]];
	NSTimeInterval timeSinceReminderRequest = [[NSDate date] timeIntervalSinceDate:reminderRequestDate];
	NSTimeInterval timeUntilReminder = 60 * 60 * 24 * RATER_TIME_BEFORE_REMINDING;
	if (timeSinceReminderRequest < timeUntilReminder)
		return NO;
	
	return YES;
}

- (void)incrementUseCount {
    
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kRaterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kRaterCurrentVersion];
	}
	
	if (RATER_DEBUG)
		NSLog(@"RATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kRaterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kRaterFirstUseDate];
		}
		
		// increment the use count
		int useCount = [userDefaults integerForKey:kRaterUseCount];
		useCount++;
		[userDefaults setInteger:useCount forKey:kRaterUseCount];
		if (RATER_DEBUG)
			NSLog(@"RATER Use count: %d", useCount);
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kRaterCurrentVersion];
		[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kRaterFirstUseDate];
		[userDefaults setInteger:1 forKey:kRaterUseCount];
		[userDefaults setInteger:0 forKey:kRaterSignificantEventCount];
		[userDefaults setBool:NO forKey:kRaterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kRaterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kRaterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}

- (void)incrementSignificantEventCount {
    
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kRaterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kRaterCurrentVersion];
	}
	
	if (RATER_DEBUG)
		NSLog(@"RATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kRaterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kRaterFirstUseDate];
		}
		
		// increment the significant event count
		int sigEventCount = [userDefaults integerForKey:kRaterSignificantEventCount];
		sigEventCount++;
		[userDefaults setInteger:sigEventCount forKey:kRaterSignificantEventCount];
		if (RATER_DEBUG)
			NSLog(@"RATER Significant event count: %d", sigEventCount);
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kRaterCurrentVersion];
		[userDefaults setDouble:0 forKey:kRaterFirstUseDate];
		[userDefaults setInteger:0 forKey:kRaterUseCount];
		[userDefaults setInteger:1 forKey:kRaterSignificantEventCount];
		[userDefaults setBool:NO forKey:kRaterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kRaterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kRaterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}

- (void)incrementAndRate:(BOOL)canPromptForRating {
	[self incrementUseCount];
	
	if (canPromptForRating &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self showRatingAlert];
                       });
	}
}

- (void)incrementSignificantEventAndRate:(BOOL)canPromptForRating {
	[self incrementSignificantEventCount];
	
	if (canPromptForRating &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self showRatingAlert];
                       });
	}
}

+ (void)appLaunched {
    
    // launched
    #ifdef DEBUG
    NSLog(@"Rater: appLaunched");
    #endif
	[Rater appLaunched:YES];
}

+ (void)appLaunched:(BOOL)canPromptForRating {
    
    // launched
    #ifdef DEBUG
    NSLog(@"Rater: appLaunched");
    #endif
    
    // dispatch
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[Rater sharedInstance] incrementAndRate:canPromptForRating];
                   });
}

- (void)hideRatingAlert {
	if (self.ratingAlert.visible) {
		if (RATER_DEBUG)
			NSLog(@"RATER Hiding Alert");
		[self.ratingAlert dismissWithClickedButtonIndex:-1 animated:NO];
	}	
}

+ (void)appWillResignActive {
	if (RATER_DEBUG)
		NSLog(@"RATER appWillResignActive");
	[[Rater sharedInstance] hideRatingAlert];
}

+ (void)appEnteredForeground:(BOOL)canPromptForRating {
    
    // foreground
    #ifdef DEBUG
    NSLog(@"Rater: appEnteredForeground");
    #endif
    
    // dispatch
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[Rater sharedInstance] incrementAndRate:canPromptForRating];
                   });
}

+ (void)userDidSignificantEvent:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[Rater sharedInstance] incrementSignificantEventAndRate:canPromptForRating];
                   });
}

+ (void)rateApp {
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"RATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *templateReviewURL = [NSString stringWithFormat:@"%@",(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? urlReviewIPad : urlReviewIPhone];
	NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", RATER_APP_ID]];
	[userDefaults setBool:YES forKey:kRaterRatedCurrentVersion];
	[userDefaults synchronize];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    // defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
    // action
	switch (buttonIndex) {
		case 0:
		{
            // track
            [Tracker trackEvent:TEventRater action:@"Cancel" label:version];
            
			// they don't want to rate it
			[userDefaults setBool:YES forKey:kRaterDeclinedToRate];
			[userDefaults synchronize];
			break;
		}
		case 1:
		{
            // track
            [Tracker trackEvent:TEventRater action:@"Rate" label:version];
            
			// they want to rate it
			[Rater rateApp];
			break;
		}
		case 2:
        {
            // track
            [Tracker trackEvent:TEventRater action:@"Later" label:version];
            
			// remind them later
			[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kRaterReminderRequestDate];
			[userDefaults synchronize];
			break;
        }
		default:
			break;
	}
}

@end
