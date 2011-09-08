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


/*
 * PreferencesDelegate.
 */
@protocol PreferencesDelegate <NSObject>
- (void)setPreference:(NSString*)key value:(NSObject*)value;
- (NSObject*)getPreference:(NSString*)key;
- (void)preferencesResetDefaults;
- (void)preferencesClearCache;
@end


//  Fields
enum {
    PreferenceGraphTooltipDisabled,
    PreferenceGraphNodeCrewEnabled,
    PreferenceGraphNodeChildren,
    PreferenceGraphEdgeLength,
	PreferenceReset
};


// Actions
enum {
    ActionPreferenceReset
};

/**
 * Preferences Controller.
 */
@interface PreferencesViewController : UITableViewController <UIActionSheetDelegate, CellButtonDelegate, CellSwitchDelegate, CellSliderDelegate> {
    
    // delegate
	id<PreferencesDelegate> delegate;
    
}

// Properties
@property (assign) id<PreferencesDelegate> delegate;

@end


/**
 * PreferencesBackgroundView.
 */
@interface PreferencesBackgroundView : UIView {
}
@end
