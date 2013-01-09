//
//  AppButtons.m
//  Solyaris
//
//  Created by Beat Raess on 4.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
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

#import "AppButtons.h"
#import <QuartzCore/QuartzCore.h>

/**
 * Button.
 */
@implementation Button


#pragma mark -
#pragma mark Init

/*
 * Init.
 */
- (id)init {
    return [self initStyle:ButtonStyleDefault];
}
- (id)initStyle:(int)style {
    
    // super
    if ((self = [super init])) {
        
        // style
        switch (style) {
                
            // lite
            case ButtonStyleLite: {
                
                // image
                UIImage *button30 = [UIImage imageNamed:@"app_button_30_lite.png"];
                [self setBackgroundImage:[button30 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal];
                
                // font
                self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                [self setTitleColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
                [self setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateHighlighted];
                self.titleLabel.shadowOffset = CGSizeMake(-1,-1);
                
                // break
                break;
            }
               
            // default
            default: {
                
                // image
                UIImage *button30 = [UIImage imageNamed:@"app_button_30.png"];
                [self setBackgroundImage:[button30 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal];
                
                // font
                self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                [self setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateNormal];
                self.titleLabel.shadowOffset = CGSizeMake(-1,-1);
                
                // break
                break;
            }
        }

    }
    return self;
}

/*
 * Layout.
 */
- (void)setNeedsLayout {
    [super setNeedsLayout];
    
    // frame
    CGRect sFrame = self.frame;
    sFrame.size.height = 30;
    self.frame = sFrame;
}


@end




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
        
        // mode
        mode_transparent = NO;
        
		// return
		return self;
	}
	
	// nop
	return nil;
}

#pragma mark -
#pragma mark Accessors

/*
 * Transparent.
 */
- (void)transparent:(BOOL)flag {
    mode_transparent = flag;
    self.backgroundColor = mode_transparent ? [UIColor clearColor] : [UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaLinkBtn];
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
    [self setBackgroundColor:(mode_transparent ? [UIColor clearColor] : [UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaLinkBtn])];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(linkButtonUp:)]) {
		[delegate linkButtonUp:self];
	}
}


@end
