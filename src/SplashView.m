//
//  SplashView.m
//  IMDG
//
//  Created by CNPP on 30.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
#define kDelayTimeSplashDismiss             1.2f
#define kAnimateTimeSplashDismiss           0.9f


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
		if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
			_splash.image = [UIImage imageNamed:@"Default-Portrait.png"];
		} 
		else {
			_splash.image = [UIImage imageNamed:@"Default-Landscape.png"];
		}
        
		_splash.autoresizingMask = UIViewAutoresizingNone;
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


#pragma mark -
#pragma mark Business Methods

/**
 * Dismisses the splash.
 */
- (void)dismissSplash {
	FLog();
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
