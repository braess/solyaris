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



#pragma mark -
#pragma mark Appearance
#pragma mark -

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
    
    // navigation bar
    UIImage *navbar44 = [[UIImage imageNamed:@"app_navbar_44.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *navbar32 = [[UIImage imageNamed:@"app_navbar_32.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *navbar_shadow = [[UIImage imageNamed:@"app_navbar_shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:navbar44 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:navbar32 forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setShadowImage:navbar_shadow];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica" size:20], UITextAttributeFont,
                                                          nil]];
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:1 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-1 forBarMetrics:UIBarMetricsLandscapePhone];
    
    // toolbar
    UIImage *toolbar44 = [[UIImage imageNamed:@"app_toolbar_44.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 0, 5)];
    UIImage *toolbar32 = [[UIImage imageNamed:@"app_toolbar_32.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 0, 5)];
    [[UIToolbar appearance] setBackgroundImage:toolbar44 forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:toolbar32 forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    
    // buttons
    UIImage *button30 = [[UIImage imageNamed:@"app_button_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button30_high = [[UIImage imageNamed:@"app_button_30-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button24 = [[UIImage imageNamed:@"app_button_24.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button24_high = [[UIImage imageNamed:@"app_button_24-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button30_lite = [[UIImage imageNamed:@"app_button_30_lite.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button30_lite_high = [[UIImage imageNamed:@"app_button_30_lite-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button24_lite = [[UIImage imageNamed:@"app_button_24_lite.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button24_lite_high = [[UIImage imageNamed:@"app_button_24_lite-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *buttonback30 = [[UIImage imageNamed:@"app_button_back_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIImage *buttonback30_high = [[UIImage imageNamed:@"app_button_back_30-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIImage *buttonback24 = [[UIImage imageNamed:@"app_button_back_24.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIImage *buttonback24_high = [[UIImage imageNamed:@"app_button_back_24-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:button30_high forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:button24 forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearance] setBackgroundImage:button24_high forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonback30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonback30_high forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonback24 forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonback24_high forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica-Bold" size:12], UITextAttributeFont,
                                                          nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica-Bold" size:12], UITextAttributeFont,
                                                          nil] forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9], UITextAttributeTextColor,
                                                          nil] forState:UIControlStateDisabled];
    
    // search
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:button30_lite forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:button30_lite_high forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:button24_lite forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:button24_lite_high forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundVerticalPositionAdjustment:1 forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackButtonBackgroundVerticalPositionAdjustment:1 forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                 [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                 [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                                                                 [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                                                                 [UIFont fontWithName:@"Helvetica-Bold" size:12], UITextAttributeFont,
                                                                                                 nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                                                                  [UIFont fontWithName:@"Helvetica-Bold" size:12], UITextAttributeFont,
                                                                                                  nil] forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:0.9], UITextAttributeTextColor,
                                                                                                  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                                                                  [UIFont fontWithName:@"Helvetica-Bold" size:12], UITextAttributeFont,
                                                                                                  nil] forState:UIControlStateDisabled];
    
    // popup
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

}

@end



#pragma mark -
#pragma mark Button
#pragma mark -


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
                
                // background
                UIImage *button30 = [[UIImage imageNamed:@"app_button_30_lite.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                UIImage *button30_high = [[UIImage imageNamed:@"app_button_30_lite-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                
                [self setBackgroundImage:button30  forState:UIControlStateNormal];
                [self setBackgroundImage:button30_high  forState:UIControlStateHighlighted];
                
                // font
                self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                [self setTitleColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
                self.titleLabel.shadowOffset = CGSizeMake(0,1);
                
                // break
                break;
            }
                
            // default
            default: {
                
                // image
                UIImage *button30 = [[UIImage imageNamed:@"app_button_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                UIImage *button30_high = [[UIImage imageNamed:@"app_button_30-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                [self setBackgroundImage:button30 forState:UIControlStateNormal];
                [self setBackgroundImage:button30_high forState:UIControlStateHighlighted];
                
                // font
                self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                [self setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
                self.titleLabel.shadowOffset = CGSizeMake(0,-1);
                
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




#pragma mark -
#pragma mark LinkButton
#pragma mark -


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
#pragma mark Object

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




#pragma mark -
#pragma mark ActionBar
#pragma mark -


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



#pragma mark -
#pragma mark ActionBarButton
#pragma mark -


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
        self.titleLabel.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitleColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
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
    self.titleLabel.frame = CGRectMake(0, (int)(self.frame.size.height/2.0)+8, self.frame.size.width, 12);
    
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



#pragma mark -
#pragma mark PopoverBackgroundView
#pragma mark -

#define POPOVER_CONTENT_INSET   8
#define POPOVER_ARROW_WIDTH     35.0
#define POPOVER_ARROW_HEIGHT    19.0



/**
 * PopoverBackgroundView.
 */
@implementation PopoverBackgroundView

/*
 * Init.
 */
-(id)initWithFrame:(CGRect)frame{
    
    // super
    if (self = [super initWithFrame:frame]) {
        
        // popover
        UIImageView *popover = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"app_popover.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(49, 46, 49, 45)]];
        _popover = [popover retain];
        [self addSubview:_popover];
        [popover release];
        
        // arrow
        UIImageView *arrow = [[UIImageView alloc] init];
        _arrow = [arrow retain];
        [self addSubview:_arrow];
        [arrow release];
    }
    return self;
}


/*
 * Popover.
 */
- (CGFloat)arrowOffset {
    return _arrowOffset;
}
- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}
- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}
- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}
+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(POPOVER_CONTENT_INSET, POPOVER_CONTENT_INSET, POPOVER_CONTENT_INSET, POPOVER_CONTENT_INSET);
}
+(CGFloat)arrowHeight{
    return POPOVER_ARROW_HEIGHT;
}
+(CGFloat)arrowBase{
    return POPOVER_ARROW_WIDTH;
}


/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // vars
    CGFloat corner = 9;
    
    // frames
    CGRect fPopover = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGRect fArrow = CGRectMake(0, 0, POPOVER_ARROW_WIDTH, POPOVER_ARROW_HEIGHT);
    
    // direction
    switch (self.arrowDirection) {
            
            // up
        case UIPopoverArrowDirectionUp: {
            
            // popover
            fPopover.origin.y = POPOVER_ARROW_HEIGHT - 2;
            fPopover.size.height = self.bounds.size.height - POPOVER_ARROW_HEIGHT;
            
            // arrow
            fArrow.origin.x = roundf((self.bounds.size.width - POPOVER_ARROW_WIDTH) / 2 + self.arrowOffset);
            if (fArrow.origin.x + POPOVER_ARROW_WIDTH > self.bounds.size.width - corner) {
                fArrow.origin.x -= corner;
            }
            if (fArrow.origin.x < corner) {
                fArrow.origin.x += corner;
            }
            
            // assign arrow
            _arrow.image = [UIImage imageNamed:@"app_popover_top.png"];
            
            // done
            break;
        }
            
            // down
        case UIPopoverArrowDirectionDown:{
            
            // popover
            fPopover.size.height = self.bounds.size.height - POPOVER_ARROW_HEIGHT + 2;
            
            // arrow
            fArrow.origin.x = roundf((self.bounds.size.width - POPOVER_ARROW_WIDTH) / 2 + self.arrowOffset);
            if (fArrow.origin.x + POPOVER_ARROW_WIDTH > self.bounds.size.width - corner) {
                fArrow.origin.x -= corner;
            }
            if (fArrow.origin.x < corner) {
                fArrow.origin.x += corner;
            }
            fArrow.origin.y = fPopover.size.height - 2;
            
            // assign arrow
            _arrow.image = [UIImage imageNamed:@"app_popover_bottom.png"];
            
            // break
            break;
        }
            
            // left
        case UIPopoverArrowDirectionLeft: {
            
            // popover
            fPopover.origin.x = POPOVER_ARROW_HEIGHT - 2;
            fPopover.size.width = self.bounds.size.width - POPOVER_ARROW_HEIGHT;
            
            // arrow
            fArrow.origin.y = roundf((self.bounds.size.height - POPOVER_ARROW_WIDTH) / 2 + self.arrowOffset);
            if (fArrow.origin.y + POPOVER_ARROW_WIDTH > self.bounds.size.height - corner){
                fArrow.origin.y -= corner;
            }
            if (fArrow.origin.y < corner) {
                fArrow.origin.y += corner;
            }
            fArrow.size.width = POPOVER_ARROW_HEIGHT;
            fArrow.size.height = POPOVER_ARROW_WIDTH;
            
            // assign arrow
            _arrow.image = [UIImage imageNamed:@"app_popover_left.png"];
            
            // break
            break;
        }
            
            // right
        case UIPopoverArrowDirectionRight: {
            
            // popover
            fPopover.size.width = self.bounds.size.width - POPOVER_ARROW_HEIGHT + 2;
            
            // arrow
            fArrow.origin.x = fPopover.size.width - 2;
            fArrow.origin.y = roundf((self.bounds.size.height - POPOVER_ARROW_WIDTH) / 2 + self.arrowOffset);
            if (fArrow.origin.y + POPOVER_ARROW_WIDTH > self.bounds.size.height - corner) {
                fArrow.origin.y -= corner;
            }
            if (fArrow.origin.y < corner) {
                fArrow.origin.y += corner;
            }
            fArrow.size.width = POPOVER_ARROW_HEIGHT;
            fArrow.size.height = POPOVER_ARROW_WIDTH;
            
            // assign arrow
            _arrow.image = [UIImage imageNamed:@"app_popover_right.png"];
            
            // break
            break;
        }
            
            // no arrows
        default: {
            
            // popover
            fPopover.size.height = self.bounds.size.height - POPOVER_ARROW_HEIGHT + 2;
            
            // assign arrow
            _arrow.image = nil;
            
            // break
            break;
        }
    }
    
    // frame
    _popover.frame = fPopover;
    _arrow.frame = fArrow;
}


#pragma mark -
#pragma mark Memory Management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    GLog();
    
    // ui
    [_popover release];
    [_arrow release];
    
	// super
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
        
    }
    return self;
}


/*
 * Rotate.
 */
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
        
        
    }
    return self;
}


/*
 * Rotate.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end




