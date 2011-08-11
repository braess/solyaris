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
#import "CellSlider.h"


//  Fields
enum {
    PreferenceGeneralSound,
    PreferenceGraphPerimeter,
	PreferenceDefaultsReset,
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
@interface PreferencesViewController : UITableViewController <UIActionSheetDelegate, CellButtonDelegate, CellSwitchDelegate, CellSliderDelegate> {
    
}

@end


/**
 * PreferencesBackgroundView.
 */
@interface PreferencesBackgroundView : UIView {
}
@end
