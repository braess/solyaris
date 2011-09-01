//
//  IMDGViewController.h
//  IMDG
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDb.h"
#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "InformationViewController.h"
#import "SettingsViewController.h"
#import "cinder/app/CinderViewCocoaTouch.h"

// Declarations
CPP_CLASS(IMDGApp);

/**
 * IMDG ViewController.
 */
@interface IMDGViewController : UIViewController <UIPopoverControllerDelegate, APIDelegate, SearchDelegate, SearchResultDelegate, InformationDelegate, SettingsDelegate> {
    
    // app
    IMDGApp *imdgApp;
    TMDb *tmdb;
    
    // controllers
    SearchViewController *_searchViewController;
    SearchResultViewController *_searchResultViewController;
    InformationViewController *_informationViewController;
    InformationViewController *_settingsViewController;
    UIButton *_buttonSettings;
    
    // cinder
    CinderViewCocoaTouch *_cinderView;
    
    // popover
	UIPopoverController *_searchResultsPopoverController;
    
    // private
    @private
    
    // modes
    bool mode_settings;
    
    
}

// Properties
@property (assign) IMDGApp *imdgApp;

// Action Settings
- (void)actionSettings:(id)sender;


// Business Methods
- (void)nodeInformation:(NSString*)nid;
- (void)nodeLoad:(NSString*)nid;

// Helpers
- (NSObject*)getUserDefault:(NSString*)key;
- (BOOL)getUserDefaultBool:(NSString*)key;


@end
