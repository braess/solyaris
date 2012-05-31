//
//  SolyarisViewController.h
//  Solyaris
//
//  Created by CNPP on 16.6.2011.
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
#import "TMDb.h"
#import "NoteView.h"
#import "SearchBarViewController.h"
#import "SearchViewController.h"
#import "InformationViewController.h"
#import "RelatedViewController.h"
#import "SettingsViewController.h"
#import "SplashView.h"
#import "cinder/app/CinderViewCocoaTouch.h"

// Declarations
CPP_CLASS(Solyaris);

// alerts
enum {
	SolyarisAlertAPIFatal
};


/**
 * Solyaris ViewController.
 */
@interface SolyarisViewController : UIViewController <UIPopoverControllerDelegate, UIAlertViewDelegate, APIDelegate, SearchBarDelegate, SearchDelegate, InformationDelegate, RelatedDelegate, SettingsDelegate, SplashDelegate> {
    
    // app
    Solyaris *solyaris;
    TMDb *tmdb;
    
    // controllers
    NoteView *_noteView;
    SearchBarViewController *_searchBarViewController;
    SearchViewController *_searchViewController;
    InformationViewController *_informationViewController;
    RelatedViewController *_relatedViewController;
    SettingsViewController *_settingsViewController;
    UIButton *_buttonSettings;
    
    // cinder
    CinderViewCocoaTouch *_cinderView;
    
    
    // private
    @private
    
    // modes
    bool mode_settings;
    bool mode_splash;
    bool mode_search;
    bool mode_animating;
    
    // data nodes
    NSMutableDictionary *_dta_nodes;
    
}

// Properties
@property (assign) Solyaris *solyaris;

// Application
- (void)activate;
- (void)quit;
- (void)help;
- (void)install:(NSString*)version;
- (void)update:(NSString*)version;

// Action Settings
- (void)actionSettings:(id)sender;

// Business Methods
- (void)nodeInfo:(NSString*)nid;
- (void)nodeRelated:(NSString*)nid;
- (void)nodeClose:(NSString*)nid;
- (void)nodeLoad:(NSString*)nid;
- (void)nodeInformation:(NSString*)nid;

@end
