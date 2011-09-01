//
//  SettingsViewController.h
//  IMDG
//
//  Created by CNPP on 5.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "PreferencesViewController.h"


/*
 * SettingsDelegate.
 */
@protocol SettingsDelegate <NSObject>
- (void)settingsDismiss;
- (void)settingsApply;
@end


/**
 * SettingsViewController.
 */
@interface SettingsViewController : UIViewController <PreferencesDelegate> {
    
    // delegate
	id<SettingsDelegate> delegate;
    
    // controllers
    UIView *_contentView;
    AboutViewController *_aboutViewController;
    PreferencesViewController *_preferencesViewController;
    
    // private
    @private
    CGRect vframe;
    
}

// Properties
@property (assign) id<SettingsDelegate> delegate;
@property (nonatomic, retain) UIView *contentView;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

@end
