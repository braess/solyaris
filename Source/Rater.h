//
//  Rater.h
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
 * Rater.h
 * Rater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2012 Arash Payan. All rights reserved.
 */

#import <Foundation/Foundation.h>

extern NSString *const kRaterFirstUseDate;
extern NSString *const kRaterUseCount;
extern NSString *const kRaterSignificantEventCount;
extern NSString *const kRaterCurrentVersion;
extern NSString *const kRaterRatedCurrentVersion;
extern NSString *const kRaterDeclinedToRate;
extern NSString *const kRaterReminderRequestDate;

/*
 Place your Apple generated software id here.
 */
#define RATER_APP_ID				481963410

/*
 Your app's name.
 */
#define RATER_APP_NAME				NSLocalizedString(@"Solyaris", nil)

/*
 This is the message your users will see once they've passed the day+launches
 threshold.
 */
#define RATER_LOCALIZED_MESSAGE     NSLocalizedString(@"If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", nil)
#define RATER_MESSAGE				[NSString stringWithFormat:RATER_LOCALIZED_MESSAGE, RATER_APP_NAME]

/*
 This is the title of the message alert that users will see.
 */
#define RATER_LOCALIZED_MESSAGE_TITLE   NSLocalizedString(@"Rate %@", nil)
#define RATER_MESSAGE_TITLE             [NSString stringWithFormat:RATER_LOCALIZED_MESSAGE_TITLE, RATER_APP_NAME]

/*
 The text of the button that rejects reviewing the app.
 */
#define RATER_CANCEL_BUTTON			NSLocalizedString(@"No, Thanks", nil)

/*
 Text of button that will send user to app review page.
 */
#define RATER_LOCALIZED_RATE_BUTTON NSLocalizedString(@"Rate %@", nil)
#define RATER_RATE_BUTTON			[NSString stringWithFormat:RATER_LOCALIZED_RATE_BUTTON, RATER_APP_NAME]

/*
 Text for button to remind the user to review later.
 */
#define RATER_RATE_LATER			NSLocalizedString(@"Remind me later", nil)

/*
 Users will need to have the same version of your app installed for this many
 days before they will be prompted to rate it.
 */
#define RATER_DAYS_UNTIL_PROMPT		15		

/*
 An example of a 'use' would be if the user launched the app. Bringing the app
 into the foreground (on devices that support it) would also be considered
 a 'use'. You tell Rater about these events using the two methods:
 [Rater appLaunched:]
 [Rater appEnteredForeground:]
 
 Users need to 'use' the same version of the app this many times before
 before they will be prompted to rate it.
 */
#define RATER_USES_UNTIL_PROMPT		20

/*
 A significant event can be anything you want to be in your app. In a
 telephone app, a significant event might be placing or receiving a call.
 In a game, it might be beating a level or a boss. This is just another
 layer of filtering that can be used to make sure that only the most
 loyal of your users are being prompted to rate you on the app store.
 If you leave this at a value of -1, then this won't be a criteria
 used for rating. To tell Rater that the user has performed
 a significant event, call the method:
 [Rater userDidSignificantEvent:];
 */
#define RATER_SIG_EVENTS_UNTIL_PROMPT	30	



/*
 Once the rating alert is presented to the user, they might select
 'Remind me later'. This value specifies how long (in days) Rater
 will wait before reminding them.
 */
#define RATER_TIME_BEFORE_REMINDING		1	


/*
 'YES' will show the Rater alert everytime. Useful for testing how your message
 looks and making sure the link to your app's review page works.
 */
#define RATER_DEBUG				NO



/**
 * Rater.
 */
@interface Rater : NSObject <UIAlertViewDelegate> {
    
	UIAlertView		*ratingAlert;
}

@property(nonatomic, retain) UIAlertView *ratingAlert;

/*
 DEPRECATED: While still functional, it's better to use
 appLaunched:(BOOL)canPromptForRating instead.
 
 Calls [Rater appLaunched:YES]. See appLaunched: for details of functionality.
 */
+ (void)appLaunched;

/*
 Tells Rater that the app has launched, and on devices that do NOT
 support multitasking, the 'uses' count will be incremented. You should
 call this method at the end of your application delegate's
 application:didFinishLaunchingWithOptions: method.
 
 If the app has been used enough to be rated (and enough significant events),
 you can suppress the rating alert
 by passing NO for canPromptForRating. The rating alert will simply be postponed
 until it is called again with YES for canPromptForRating. The rating alert
 can also be triggered by appEnteredForeground: and userDidSignificantEvent:
 (as long as you pass YES for canPromptForRating in those methods).
 */
+ (void)appLaunched:(BOOL)canPromptForRating;

/*
 Tells Rater that the app was brought to the foreground on multitasking
 devices. You should call this method from the application delegate's
 applicationWillEnterForeground: method.
 
 If the app has been used enough to be rated (and enough significant events),
 you can suppress the rating alert
 by passing NO for canPromptForRating. The rating alert will simply be postponed
 until it is called again with YES for canPromptForRating. The rating alert
 can also be triggered by appLaunched: and userDidSignificantEvent:
 (as long as you pass YES for canPromptForRating in those methods).
 */
+ (void)appEnteredForeground:(BOOL)canPromptForRating;

/*
 Tells Rater that the user performed a significant event. A significant
 event is whatever you want it to be. If you're app is used to make VoIP
 calls, then you might want to call this method whenever the user places
 a call. If it's a game, you might want to call this whenever the user
 beats a level boss.
 
 If the user has performed enough significant events and used the app enough,
 you can suppress the rating alert by passing NO for canPromptForRating. The
 rating alert will simply be postponed until it is called again with YES for
 canPromptForRating. The rating alert can also be triggered by appLaunched:
 and appEnteredForeground: (as long as you pass YES for canPromptForRating
 in those methods).
 */
+ (void)userDidSignificantEvent:(BOOL)canPromptForRating;

/*
 Tells Rater to open the App Store page where the user can specify a
 rating for the app. Also records the fact that this has happened, so the
 user won't be prompted again to rate the app.
 
 The only case where you should call this directly is if your app has an
 explicit "Rate this app" command somewhere.  In all other cases, don't worry
 about calling this -- instead, just call the other functions listed above,
 and let Rater handle the bookkeeping of deciding when to ask the user
 whether to rate the app.
 */
+ (void)rateApp;

@end
