//
//  AboutViewController.h
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>



// Alerts
enum {
    AlertAboutAppStore
};

/**
 * AboutViewController.
 */
@interface AboutViewController : UITableViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Action Methods
- (void)actionEmail:(id)sender;
- (void)actionTwitter:(id)sender;
- (void)actionAppStore:(id)sender;
- (void)actionFeedback:(id)sender;

@end
