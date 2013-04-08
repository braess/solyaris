//
//  Appearance.m
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
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

#import "Appearance.h"


/**
 * Appearance.
 */
@implementation Appearance

/**
 * Appearance.
 */
+ (void)appearance {
    FLog();
    
    // hide statusbar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    // images
    UIImage *button30 = [[UIImage imageNamed:@"app_button_30"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button24 = [[UIImage imageNamed:@"app_button_24"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *buttonback30 = [[UIImage imageNamed:@"app_button_back_30"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIImage *buttonback24 = [[UIImage imageNamed:@"app_button_back_24"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    
    // buttons
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:button24 forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonback30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonback24 forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];

}

@end



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


/**
 * ActionBar.
 */
@implementation ActionBar

#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // self
    if ((self = [super initWithFrame:frame])) {
        
        // remove background
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.translucent = YES;
        self.barStyle = UIBarStyleDefault;
        
        // resize
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    }
    return self;
    
}



#pragma mark -
#pragma mark View


/*
 * Draw.
 */
- (void)drawRect:(CGRect)rect {
    // do nothing in here
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    
    // view
    [super dealloc];
}


@end


/**
 * ActionBarButton.
 */
@implementation ActionBarButton



#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action {
    return [self initWithImage:image selected:image title:title target:target action:action];
}
- (id)initWithImage:(UIImage *)image selected:(UIImage *)selected title:(NSString *)title target:(id)target action:(SEL)action {
    GLog();
    
    // self
    if ((self = [super initWithFrame:CGRectMake(0, 0, 60, 44)])) {
        
        // configure label
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
        self.titleLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitleColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]
                   forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]
                   forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]
                   forState:UIControlStateReserved];
        
        
        // configure image
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.autoresizingMask = UIViewAutoresizingNone;
        
        // states
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        if (image != selected) {
            [self setBackgroundImage:NULL forState:UIControlStateNormal];
            [self setImage:selected forState:UIControlStateHighlighted];
            [self setImage:selected forState:UIControlStateSelected];
            [self setImage:selected forState:(UIControlStateSelected|UIControlStateHighlighted)];
            [self setImage:selected forState:(UIControlStateDisabled|UIControlStateHighlighted)];
        }
        
        // target & action
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}





#pragma mark -
#pragma mark View

/*
 * Laout.
 */
- (void)layoutSubviews {
	[super layoutSubviews];
    
    // label & button
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLabel.frame = CGRectMake(0, (int)(self.frame.size.height/2.0)+6, self.frame.size.width, 12);
    
}


@end



/**
 * ActionBarButtonItem.
 */
@implementation ActionBarButtonItem


#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action {
    return [self initWithImage:image selected:image title:title target:target action:action];
}
- (id)initWithImage:(UIImage *)image selected:(UIImage*)selected title:(NSString *)title target:(id)target action:(SEL)action {
    GLog();
    
    // button
    ActionBarButton *barButton = [[ActionBarButton alloc] initWithImage:image selected:selected title:title target:target action:action];
    
    // self
    if ((self = [super initWithCustomView:barButton])) {
        
        // assign
        _barButton = [barButton retain];
    }
    
    // release & return
    [barButton release];
    return self;
}


#pragma mark -
#pragma mark View

/**
 * Selected.
 */
- (void)setSelected:(BOOL)s {
    [_barButton setSelected:s];
}

/**
 * Darker version.
 */
- (void)dark:(BOOL)flag {
    
    // button
    if (flag) {
        [_barButton setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_barButton setTitleColor:[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [_barButton setTitleColor:[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    }
}


/**
 * Sets the title.
 */
- (void)setTitle:(NSString *)title {
    [_barButton setTitle:title forState:UIControlStateNormal];
}

/**
 * Sets the frame.
 */
- (void)setFrame:(CGRect)frame {
    [_barButton setFrame:frame];
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    
    // button
    [_barButton release];
    
    // view
    [super dealloc];
}

@end




/**
 * NavigationController.
 */
@implementation NavigationController


#pragma mark -
#pragma mark Controller Methods

/*
 * Init.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    GLog();
    
    // init super
    if ((self = [super initWithRootViewController:rootViewController])) { 
        
        // navigation bar
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        self.navigationBar.tintColor = [UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0];
     
        // toolbar
        self.toolbar.barStyle = UIBarStyleBlack;
        
    }
    return self;
}


/*
 * Rotate.
 */
- (BOOL)shouldAutorotate {
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

/*
 * Dealloc.
 */
- (void)dealloc {
    FLog();
    [super dealloc];
}


@end


/**
 * MailComposeController.
 */
@implementation MailComposeController


#pragma mark -
#pragma mark Controller Methods

/*
 * Init.
 */
- (id)init {
    GLog();
    
    // init super
    if ((self = [super init])) { 
        
        // navigation bar
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        self.navigationBar.tintColor = [UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0];
        
        
    }
    return self;
}


/*
 * Rotate.
 */
- (BOOL)shouldAutorotate {
   return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end




