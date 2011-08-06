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
@end


/**
 * SettingsViewController.
 */
@interface SettingsViewController : UIViewController {
    
    // delegate
	id<SettingsDelegate> delegate;
    
    // controllers
    AboutViewController *_aboutViewController;
    PreferencesViewController *_preferencesViewController;
    
}

// Properties
@property (assign) id<SettingsDelegate> delegate;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

@end
