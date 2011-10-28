//
//  PreferencesViewController.h
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"
#import "CellSwitch.h"
#import "CellSlider.h"
#import "CellSegment.h"


/*
 * PreferencesDelegate.
 */
@protocol PreferencesDelegate <NSObject>
- (void)setPreference:(NSString*)key value:(NSObject*)value;
- (NSObject*)getPreference:(NSString*)key;
- (void)preferencesResetDefaults;
- (void)preferencesClearCache;
- (void)preferencesHelp;
@end


//  Fields
enum {
    PreferenceGraphLayout,
    PreferenceGraphSoundDisabled,
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
@interface PreferencesViewController : UITableViewController <UIActionSheetDelegate, CellButtonDelegate, CellSwitchDelegate, CellSliderDelegate, CellSegmentDelegate> {
    
    // delegate
	id<PreferencesDelegate> delegate;
    
    // private
    @private
    CGRect vframe;
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Properties
@property (assign) id<PreferencesDelegate> delegate;

// Action Methods
- (void)actionHelp:(id)sender;

@end


/**
 * PreferencesBackgroundView.
 */
@interface PreferencesBackgroundView : UIView {
}
@end
