//
//  LinkButton.m
//  Solyaris
//
//  Created by Beat Raess on 4.11.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "LinkButton.h"


/*
 * Helper Stack.
 */
@interface LinkButton (Helpers)
- (void)buttonTouchUpInside:(UIButton*)b;
- (void)buttonDown:(UIButton*)b;
- (void)buttonUp:(UIButton*)b;
@end


/**
 * Link Button.
 */
@implementation LinkButton


#pragma mark -
#pragma mark Constants

// constants
#define kAlphaLinkBtn 0.15f
#define kAlphaLinkBtnActive 0.5f


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize link;



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
		
		// init
		self.opaque = YES;
		self.backgroundColor = [UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaLinkBtn];
        
        // targets and actions
        [self addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
        
		// return
		return self;
	}
	
	// nop
	return nil;
}


#pragma mark -
#pragma mark Helpers

/*
 * Don't touch this.
 */
- (void)buttonTouchUpInside:(UIButton*)b {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(linkButtonTouched:)]) {
		[delegate linkButtonTouched:self];
	}
}
- (void)buttonDown:(UIButton*)b {
	GLog();
    
    // state
    [self setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaLinkBtnActive]];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(linkButtonDown:)]) {
		[delegate linkButtonDown:self];
	}
}
- (void)buttonUp:(UIButton*)b {
	GLog();
    
    // state
    [self setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaLinkBtn]];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(linkButtonUp:)]) {
		[delegate linkButtonUp:self];
	}
}


@end
