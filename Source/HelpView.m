//
//  HelpView.m
//  Solyaris
//
//  Created by Beat Raess on 20.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "HelpView.h"


/**
 * Help Stack.
 */
@interface HelpView (AnimationHelpers)
- (void)animationShowHelp;
- (void)animationShowNoteDone;
- (void)animationDismissHelp;
- (void)animationDismissHelpDone;
@end


/**
 * Help View.
 */
@implementation HelpView


#pragma mark -
#pragma mark Constants

// constants
#define kHelpOpacity                    0.93f
#define kAnimateTimeHelpShow            2.4f
#define kAnimateTimeHelpDismiss         0.6f



#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
    
    
	// init UIView
    self = [super initWithFrame:frame];
    
	// init self
    if (self != nil) {
        
        // self
        self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
		
				
		// portrait
		UIImageView *imageHelp = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageHelp.autoresizingMask = UIViewAutoresizingNone;
		imageHelp.backgroundColor = [UIColor clearColor];
		imageHelp.contentMode = UIViewContentModeCenter;
		imageHelp.hidden = YES;
        
        _imageHelp = [imageHelp retain];
        [self addSubview:_imageHelp];
        [imageHelp release];
        
        // flags
        animation_show = NO;
        animation_dismiss = NO;

        
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
    GLog();
    
    // frame
    CGRect frame = CGRectMake(0, 0, 768, 1024);
    _imageHelp.image = [UIImage imageNamed:@"help_portrait.png"];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        frame = CGRectMake(0, 0, 1024, 768);
        _imageHelp.image = [UIImage imageNamed:@"help_landscape.png"];
    }
    self.frame = frame;
    _imageHelp.frame = frame;
    
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
#pragma mark Touch

/*
 * Touch.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	FLog();
    [self dismissHelp];
}



#pragma mark -
#pragma mark Business Methods


/**
 * Shows / dismisses the help.
 */
- (void)showHelp {
    DLog();
    [self layoutSubviews];
	[self animationShowHelp];
}
- (void)dismissHelp {
    DLog();
    [self animationDismissHelp];
}




#pragma mark -
#pragma mark Animations



/*
 * Animation help show.
 */
- (void)animationShowHelp {
	GLog();
    
    // flag
    if (! animation_show) {
        animation_show = YES;
        
        // prepare view
        _imageHelp.alpha = 0.0f;
        _imageHelp.hidden = NO;
        
        // animate
        [UIView beginAnimations:@"help_show" context:nil];
        [UIView setAnimationDuration:kAnimateTimeHelpShow];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _imageHelp.alpha = kHelpOpacity;
        [UIView commitAnimations];
        
        // clean it up
        [self performSelector:@selector(animationShowHelpDone) withObject:nil afterDelay:kAnimateTimeHelpShow];
    }
    
	
}
- (void) animationShowHelpDone {
	GLog();
    
    // flag
    animation_show = NO;
}


/*
 * Animation dismiss help.
 */
- (void)animationDismissHelp {
	GLog();
    
    // flag
    if (! animation_dismiss) {
        animation_dismiss = YES;
        
        // prepare view
        _imageHelp.alpha = kHelpOpacity;
        
        // animate
        [UIView beginAnimations:@"help_dismiss" context:nil];
        [UIView setAnimationDuration:kAnimateTimeHelpDismiss];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _imageHelp.alpha = 0.0f;
        [UIView commitAnimations];
        
        // clean it up
        [self performSelector:@selector(animationDismissHelpDone) withObject:nil afterDelay:kAnimateTimeHelpDismiss];
    }
	
}
- (void)animationDismissHelpDone {
	GLog();
    
    // flag
    animation_dismiss = NO;
    
	// hide
	_imageHelp.hidden = YES;
	self.hidden = YES;
	
	// remove
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
	[_imageHelp release];
	
	// & done
	[super dealloc];
}

@end
