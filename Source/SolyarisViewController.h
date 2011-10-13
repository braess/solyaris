//
//  SolyarisViewController.h
//  Solyaris
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
CPP_CLASS(Solyaris);

// alerts
enum {
    SolyarisAlertAPIError,
	SolyarisAlertAPIFatal
};


/**
 * Solyaris ViewController.
 */
@interface SolyarisViewController : UIViewController <UIPopoverControllerDelegate, UIAlertViewDelegate, APIDelegate, SearchDelegate, SearchResultDelegate, InformationDelegate, SettingsDelegate> {
    
    // app
    Solyaris *solyaris;
    TMDb *tmdb;
    
    // controllers
    SearchViewController *_searchViewController;
    SearchResultViewController *_searchResultViewController;
    InformationViewController *_informationViewController;
    SettingsViewController *_settingsViewController;
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
@property (assign) Solyaris *solyaris;

// Action Settings
- (void)actionSettings:(id)sender;


// Business Methods
- (void)nodeInformation:(NSString*)nid;
- (void)nodeLoad:(NSString*)nid;
- (void)quit;
- (void)activate;



@end
