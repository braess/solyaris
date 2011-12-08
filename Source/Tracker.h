//
//  Tracker.h
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

#import <Foundation/Foundation.h>

//  Variables
enum {
    TrackerVariables,
	TrackerVariableIOS
};

// Categories
#define TEventApp			@"App"
#define TEventSearch        @"Search"
#define TEventLoad          @"Load"		
#define TEventAbout         @"About"
#define TEventInfo          @"Info"
#define TEventPreferences   @"Preferences"


/**
 * Tracker.
 */
@interface Tracker : NSObject {
    
}

// Class Methods
+ (void)startTracker;
+ (void)stopTracker;
+ (void)dispatch;
+ (void)trackPageView:(NSString*)page;
+ (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label;

@end
