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
#import "GAI/GAI.h"


/**
 * Tracker.
 */
@implementation Tracker

#pragma mark -
#pragma mark Class Methods

/**
 * Starts the tracker.
 */
+ (void)startTracker {
    
    #ifdef DEBUG
    NSLog(@"Tracker: Start");
    #else
    @try {
        // init
        [GAI sharedInstance].debug = NO;
        [GAI sharedInstance].dispatchInterval = 120;
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        
        // tracker
        [GAI sharedInstance].defaultTracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-1005717-33"];
    }
    @catch (id exception) {
	}
    #endif
}

/**
 * Tracks a view.
 */
+ (void)trackView:(NSString*)view {
    
    #ifdef DEBUG
    NSLog(@"Tracker: View %@",view);
    #else
    @try {
        [[GAI sharedInstance].defaultTracker trackView:view];
    }
    @catch (id exception) {
	}
    #endif
}

/**
 * Tracks an event.
 */
+ (void)trackEvent:(NSString*)category action:(NSString*)action {
    [Tracker trackEvent:category action:action label:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}
+ (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label {
    
    #ifdef DEBUG
    NSLog(@"Tracker: Event %@ %@ %@",category,action,label);
    #else
    @try {
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:category withAction:action withLabel:label withValue:nil];
    }
    @catch (id exception) {
	}
    #endif
}

/**
 * Track errors.
 */
+ (void)trackError:(NSString *)cls method:(NSString *)method message:(NSString *)message {
	[Tracker trackError:[NSString stringWithFormat:@"%@ - %@: %@",cls,method,message] error:nil];
}
+ (void)trackError:(NSString *)cls method:(NSString *)method message:(NSString *)message error:(NSError *)error {
	[Tracker trackError:[NSString stringWithFormat:@"%@ - %@: %@",cls,method,message] error:error];
}
+ (void)trackError:(NSString *)msg error:(NSError *)error {
    
#ifdef DEBUG
    NSLog(@"Tracker: Error %@\n%@",msg,error);
#else
    @try {
        [[GAI sharedInstance].defaultTracker trackException:NO withNSError:error];
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:TEventError withAction:msg withLabel:[NSString stringWithFormat:@"%@",error != nil ? error : @""] withValue:nil];
    }
    @catch (id exception) {
	}
#endif
    
}

@end
