//
//  SettingsViewController.m
//  Solyaris
//
//  Created by CNPP on 5.8.2011.
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

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SolyarisAppDelegate.h"
#import "SolyarisConstants.h"
#import "Device.h"
#import "Tracker.h"

/**
 * Animation Stack.
 */
@interface SettingsViewController (AnimationHelpers)
- (void)animationAbout;
- (void)animationAboutDone;
- (void)animationPreferences;
- (void)animationPreferencesDone;
@end

/**
 * Gesture Stack.
 */
@interface SettingsViewController (GestureStack)
- (void)gestureTap:(UITapGestureRecognizer *)recognizer;
@end


/**
 * SettingsViewController.
 */
@implementation SettingsViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeAbout           0.24
#define kAnimateTimePreferences     0.24


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize contentView = _contentView;


#pragma mark -
#pragma mark Object

/*
 * Init.
 */
-(id)init {
	return [self initWithFrame:CGRectMake(0, 0, 708, 480)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
		
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
    
    // screen
    CGRect screen = [Device screen];
    
    // sizes
    float border = (screen.size.width-vframe.size.width)/2.0;
    
    // frames
    CGRect cframe = iPad ? CGRectMake(border, screen.size.height-vframe.size.height, vframe.size.width, vframe.size.height) : CGRectMake(0, 0, vframe.size.width*2, vframe.size.height);
    CGRect aframe = iPad ? CGRectMake(0, border, 320, vframe.size.height-border) : CGRectMake(vframe.size.width+10, 15, vframe.size.width-20, vframe.size.height-10);
    CGRect pframe = iPad ? CGRectMake(cframe.size.width-320, border, 320, vframe.size.height-border) : CGRectMake(10, 15, vframe.size.width-20, vframe.size.height-10);
    
    CGRect bframe =  CGRectMake(vframe.size.width-44, 5, 44, 44);
    
    // view
    UIView *sview = [[UIView alloc] initWithFrame:screen];
    sview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // self
    self.view = sview;
    [sview release];
    
	// content
    UIView *ctView = [[UIView alloc] initWithFrame:cframe];
    ctView.autoresizesSubviews = NO;
    ctView.contentMode = UIViewContentModeRedraw; 
    ctView.autoresizingMask = iPad ? (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin) : UIViewAutoresizingNone;
    ctView.backgroundColor = iPad ? [UIColor clearColor] : [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_settings.png"]];
	ctView.opaque = YES;
    
    // drop that shadow
    float dx = iPad ? (1024-768) : 0;
	CAGradientLayer *dropShadow = [[CAGradientLayer alloc] init];
	dropShadow.frame = CGRectMake(-border-dx, 0, cframe.size.width+2*border+2*dx, 18);
	dropShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.09].CGColor,(id)[UIColor colorWithWhite:0.1 alpha:0.01].CGColor,(id)[UIColor colorWithWhite:0.1 alpha:0].CGColor,nil];
	[ctView.layer insertSublayer:dropShadow atIndex:0];
    [dropShadow release];
    
    // about
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithFrame:aframe];
    aboutViewController.delegate = self;
    _aboutViewController = [aboutViewController retain];
    [aboutViewController release];
    
    [self addChildViewController:_aboutViewController];
    [ctView addSubview:_aboutViewController.view];
    
    // Preferences
    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] initWithFrame:pframe];
    preferencesViewController.delegate = self;
    _preferencesViewController = [preferencesViewController retain];
    [preferencesViewController release];
    
    [self addChildViewController:_preferencesViewController];
    [ctView addSubview:_preferencesViewController.view];
    
    // close
    UIButton *btnShut = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnShut.frame = bframe;
    [btnShut setImage:[UIImage imageNamed:@"btn_shut.png"] forState:UIControlStateNormal];
    [btnShut addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    _buttonClose = [btnShut retain];
    [ctView  addSubview:_buttonClose];
    
    _buttonClose.hidden = iPad;
    
    
    // add & release content
    self.contentView = ctView;
    [self.view addSubview:_contentView];
    [self.view bringSubviewToFront:_contentView];
    [ctView release];
    
    // gestures
    if (iPad) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setDelegate:self];
        [self.view addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    
}


/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();

    // track
    [Tracker trackView:@"Settings"];
}


/*
 * Rotation.
 */
- (BOOL)shouldAutorotate {
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}

/*
 * Touches.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}


#pragma mark -
#pragma mark Gestures

/*
 * Gesture tap.
 */
- (void)gestureTap:(UITapGestureRecognizer *)recognizer {
    FLog();
    
    // dismiss
    if (delegate && [delegate respondsToSelector:@selector(settingsDismiss)]) {
        [delegate settingsDismiss];
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // tapped
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (location.y < self.view.frame.size.height - vframe.size.height) {
        return YES;
    }
    return NO;
}



#pragma mark -
#pragma mark Preferences Delegate

/*
 * Get/Set/Reset preference.
 */
- (void)setPreference:(NSString*)key value:(NSObject*)value {
    GLog();
    
    // user defaults
	[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] setUserDefault:key value:value];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(settingsApply)]) {
        [delegate settingsApply];
    }
    
}
- (NSObject*)getPreference:(NSString*)key {
    GLog();
    
    // user defaults
	return [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:key];
                
}
- (void)preferencesResetDefaults {
    GLog();
    
	// user defaults
	[(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] resetUserDefaults];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(settingsApply)]) {
        [delegate settingsApply];
    }
}
- (void)preferencesClearCache {
    GLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(settingsClearCache)]) {
        [delegate settingsClearCache];
    }
}
- (void)preferencesHelp {
    GLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(settingsHelp)]) {
        [delegate settingsHelp];
    }
}
- (void)preferencesAbout {
    FLog();
    
    // about
    [self animationAbout];
}

/* 
 * Mode modal.
 */
- (void)preferencesModal:(BOOL)modal {
    FLog();
    
    // hide close
    _buttonClose.hidden = modal;
}



#pragma mark -
#pragma mark Actions

/*
 * Action close.
 */
- (void)actionClose:(id)sender {
    DLog();
    
    // dismiss
    if (delegate && [delegate respondsToSelector:@selector(settingsDismiss)]) {
        [delegate settingsDismiss];
    }
}



#pragma mark -
#pragma mark About Delegate

/*
 * Close.
 */
- (void)aboutBack {
    FLog();
    
    // about
    [self animationPreferences];
}



#pragma mark -
#pragma mark Helpers


/*
 * Animation about.
 */
- (void)animationAbout {
	GLog();
	
	// prepare controllers
	[_aboutViewController viewWillAppear:YES];
    [_preferencesViewController viewWillDisappear:YES];
    
    // frame
    CGRect settingsFrame = self.contentView.frame;
    settingsFrame.origin.x = 0;
    self.contentView.frame = settingsFrame;
    settingsFrame.origin.x = - vframe.size.width;
    
    // animate 
	[UIView beginAnimations:@"animation_about" context:nil];
	[UIView setAnimationDuration:kAnimateTimeAbout];
    self.contentView.frame = settingsFrame;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationAboutDone) withObject:nil afterDelay:kAnimateTimeAbout];
}
- (void)animationAboutDone {
	GLog();
    
    // appeared
    [_aboutViewController viewDidAppear:YES];
    [_preferencesViewController viewDidDisappear:YES];
    
}


/*
 * Animation preferences.
 */
- (void)animationPreferences {
	GLog();
	
	// prepare controllers
	[_preferencesViewController viewWillAppear:YES];
    [_aboutViewController viewWillDisappear:YES];
    
    // frame
    CGRect settingsFrame = self.contentView.frame;
    settingsFrame.origin.x = - vframe.size.width;
    self.contentView.frame = settingsFrame;
    settingsFrame.origin.x = 0;
    
    // animate 
	[UIView beginAnimations:@"animation_preferences" context:nil];
	[UIView setAnimationDuration:kAnimateTimePreferences];
    self.contentView.frame = settingsFrame;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationPreferencesDone) withObject:nil afterDelay:kAnimateTimePreferences];
}
- (void)animationPreferencesDone {
	GLog();
    
    // appeared
    [_preferencesViewController viewDidAppear:YES];
    [_aboutViewController viewDidDisappear:YES];
    
}


#pragma mark -
#pragma mark Memory management

/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	FLog();
    
    // self
	[_contentView release];
    [_aboutViewController release];
    [_preferencesViewController release];
    [_buttonClose release];
    
	// super
    [super dealloc];
}


@end
