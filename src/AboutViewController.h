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
#import "CellButton.h"

//  Sections
enum {
    SectionAboutApp,
    SectionAboutRecommend,
	SectionAboutFeedback
};


//  Preferences
enum {
	AboutPreferences
};

//  Recommend Fields
enum {
	AboutRecommend
};

//  Feedback Fields
enum {
	AboutFeedback
};

// actions
enum {
    ActionAboutRecommend,
	ActionAboutFeedback
};

// alerts
enum {
    AlertAboutRecommendAppStore
};


/**
 * Info Controller.
 */
@interface AboutViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, CellButtonDelegate> {
    
}

@end
