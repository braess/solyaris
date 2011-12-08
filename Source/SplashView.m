//
//  SplashView.m
//  Solyaris
//
//  Created by CNPP on 30.9.2011.
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

#import "SplashView.h"


/**
 * Splash Stack.
 */
@interface SplashView (AnimationHelpers)
- (void)animationDismissSplash;
- (void)animationDismissSplashDone;
@end

/**
 * SplashView.
 */
@implementation SplashView

#pragma mark -
#pragma mark Constants

// constants
#define kDelayTimeSplashDismiss             3.0f
#define kAnimateTimeSplashDismiss           1.5f


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
    
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// splash
		_splash = [[UIImageView alloc] initWithFrame:frame];
		_splash.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_splash.backgroundColor = [UIColor clearColor];
		_splash.contentMode = UIViewContentModeTopLeft;
        
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:_splash];
        
		// return
		return self;
	}
	
	// nop
	return nil;
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    
    // frame
    CGRect frame = CGRectMake(0, 0, 768, 1024);
    _splash.image = [UIImage imageNamed:@"Default-Portrait.png"];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        NSLog(@"landscape");
        frame = CGRectMake(0, 0, 1024, 768);
        _splash.image = [UIImage imageNamed:@"Default-Landscape.png"];
    }
    self.frame = frame;
    
}


#pragma mark -
#pragma mark Rotation

/*
 * Rotate is the new black.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Business Methods

/**
 * Dismisses the splash.
 */
- (void)dismissSplash {
	FLog();
    
    // layout
    [self layoutSubviews];
    
    // make it so
	[self performSelector:@selector(animationDismissSplash) withObject:nil afterDelay:kDelayTimeSplashDismiss];
}


/*
 * Animation splash dismiss.
 */
- (void)animationDismissSplash {
	FLog();
    
	// animate
	[UIView beginAnimations:@"splash_dismiss" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSplashDismiss];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	_splash.alpha = 0.0f;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationDismissSplashDone) withObject:nil afterDelay:kAnimateTimeSplashDismiss];
	
}
- (void) animationDismissSplashDone {
	GLog();
	
	// hide
	_splash.hidden = YES;
	self.hidden = YES;
	
	// bye
	[self removeFromSuperview];
}


#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[_splash release];
	
	// supimessage
	[super dealloc];
}

@end
