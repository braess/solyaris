//
//  PreferencesViewController.h
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"
#import "CellSwitch.h"
#import "CellText.h"
#import "CellSlider.h"


//  Sections
enum {
    SectionPreferencesGeneral,
    SectionPreferencesGraph,
	SectionPreferencesReset,
    SectionPreferencesCache
};

//  General Fields
enum {
	PreferenceGeneralEmail,
	PreferenceGeneralSound
};

//  Graph Fields
enum {
    PreferenceGraphPerimeter
};


//  Reset Fields
enum {
	PreferenceResetDefaults
};

//  Cache Fields
enum {
    PreferenceCacheClear
};


// Actions
enum {
    ActionPreferenceResetDefaults,
    ActionPreferenceClearCache
};

/**
 * Preferences Controller.
 */
@interface PreferencesViewController : UITableViewController <UIActionSheetDelegate, CellButtonDelegate, CellSwitchDelegate, CellTextDelegate, CellSliderDelegate> {
    
}

@end
