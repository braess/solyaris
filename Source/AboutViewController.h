//
//  AboutViewController.h
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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