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


// Categories
#define TEventApp			@"App"
#define TEventUsage			@"Usage"
#define TEventSearch        @"Search"
#define TEventLoad          @"Load"		
#define TEventAbout         @"About"
#define TEventInfo          @"Information"
#define TEventPreferences   @"Preferences"
#define TEventSlides        @"Slides"
#define TEventAPI           @"API"
#define TEventNode          @"Node"
#define TEventFavorites     @"Favorites"
#define TEventError         @"Error"


/**
 * Tracker.
 */
@interface Tracker : NSObject {
    
}

// Class Methods
+ (void)startTracker;
+ (void)trackView:(NSString*)view;
+ (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label;
+ (void)trackError:(NSString*)cls method:(NSString*)method message:(NSString*)message;
+ (void)trackError:(NSString*)cls method:(NSString*)method message:(NSString*)message error:(NSError*)error;
+ (void)trackError:(NSString*)msg error:(NSError*)error;

@end
