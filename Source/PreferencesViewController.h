//
//  PreferencesViewController.h
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
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
#import "CellButton.h"
#import "CellSwitch.h"
#import "CellSlider.h"
#import "CellSegment.h"


// Constants
#define kPreferencesHeaderHeight    45.0f
#define kPreferencesHeaderGap       15.0f
#define kPreferencesFooterHeight    60.0f



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
