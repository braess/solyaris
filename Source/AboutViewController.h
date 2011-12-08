//
//  AboutViewController.h
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "ActionBar.h"
#import "LinkButton.h"


// Constants
#define kAboutHeaderHeight      45.0f
#define kAboutFooterHeight      60.0


// Alerts
enum {
    AlertAboutAppStore
};


/**
 * AboutViewController.
 */
@interface AboutViewController : UITableViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, LinkButtonDelegate> {
    
    // private
    @private
    CGRect vframe;
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;


// Action Methods
- (void)actionEmail:(id)sender;
- (void)actionTwitter:(id)sender;
- (void)actionAppStore:(id)sender;
- (void)actionFeedback:(id)sender;

@end

/**
 * AboutBackgroundView.
 */
@interface AboutBackgroundView : UIView {
}
@end