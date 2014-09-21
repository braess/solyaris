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
#import "SolyarisConstants.h"


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
    
    // status
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    // ios6
    if (iOS6) {
        
        // navbar
        UIImage *navbar44 = [[UIImage imageNamed:@"ios6_app_navbar_44.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *navbar32 = [[UIImage imageNamed:@"ios6_app_navbar_32.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
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
        
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-1 forBarMetrics:UIBarMetricsLandscapePhone];
        
        
        // buttons
        UIImage *transparent = [[[UIImage alloc] init] autorelease];
        UIImage *button30 = [[UIImage imageNamed:@"ios6_app_button_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *button30_high = [[UIImage imageNamed:@"ios6_app_button_30-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *button24 = [[UIImage imageNamed:@"ios6_app_button_24.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *button24_high = [[UIImage imageNamed:@"ios6_app_button_24-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *buttonback30 = [[UIImage imageNamed:@"ios6_app_button_back_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
        UIImage *buttonback30_high = [[UIImage imageNamed:@"ios6_app_button_back_30-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
        UIImage *buttonback24 = [[UIImage imageNamed:@"ios6_app_button_back_24.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
        UIImage *buttonback24_high = [[UIImage imageNamed:@"ios6_app_button_back_24-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
        
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
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:transparent forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:transparent forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:transparent forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:transparent forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackButtonBackgroundVerticalPositionAdjustment:1 forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                                                                      [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                                                      [NSValue valueWithUIOffset:UIOffsetZero], UITextAttributeTextShadowOffset,
                                                                                                      nil] forState:UIControlStateNormal];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                                                                      [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                                                      [NSValue valueWithUIOffset:UIOffsetZero], UITextAttributeTextShadowOffset,
                                                                                                      nil] forState:UIControlStateHighlighted];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                                                                      [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.9], UITextAttributeTextColor,
                                                                                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                                                      [NSValue valueWithUIOffset:UIOffsetZero], UITextAttributeTextShadowOffset,
                                                                                                      nil] forState:UIControlStateDisabled];
        
        
        // popup
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            // navbar
            [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            
            // buttons
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setBackButtonBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        }
        
    }
    // ios7
    else {
        
        
        // navbar
        UIImage *navbar = [[UIImage imageNamed:@"app_navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *navbar_shadow = [[UIImage imageNamed:@"app_navbar_shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[UINavigationBar appearance] setBackgroundImage:navbar forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:navbar_shadow];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor,
                                                              [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:@"Helvetica" size:20], UITextAttributeFont,
                                                              nil]];
        
        // buttons
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor,
                                                              [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                              nil] forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], UITextAttributeTextColor,
                                                              [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                              nil] forState:UIControlStateHighlighted];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9], UITextAttributeTextColor,
                                                              nil] forState:UIControlStateDisabled];
        
        // search
        [[UISearchBar appearance] setBackgroundImage:[[[UIImage alloc] init] autorelease] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                                                                      [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                      nil] forState:UIControlStateNormal];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                                                                      [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                      nil] forState:UIControlStateHighlighted];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIFont fontWithName:@"Helvetica" size:15], UITextAttributeFont,
                                                                                                      [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                      nil] forState:UIControlStateDisabled];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitlePositionAdjustment:UIOffsetMake(0, 2) forBarMetrics:UIBarMetricsDefault];
        
        
        // controls
        [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1]];
        [[UISlider appearance] setThumbTintColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1]];
        
        // popup
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            // navbar
            [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setShadowImage:[[[UIImage alloc] init] autorelease]];
            [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setTintColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0]];
            [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                  [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0], UITextAttributeTextColor,
                                                                                                                  nil]];
            
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                  [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1], UITextAttributeTextColor,
                                                                                                                  nil] forState:UIControlStateNormal];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                  [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1], UITextAttributeTextColor,
                                                                                                                  nil] forState:UIControlStateHighlighted];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIPopoverController class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                  [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.6], UITextAttributeTextColor,
                                                                                                                  nil] forState:UIControlStateDisabled];
        }
        
    }
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
    if ((self = [super init])) {
        
        // style
        switch (style) {
                
            // primary
            case ButtonStylePrimary: {
                
                // background
                UIImage *button30 = [[UIImage imageNamed:@"app_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                UIImage *button30_high = [[UIImage imageNamed:@"app_button-high.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                
                [self setBackgroundImage:button30  forState:UIControlStateNormal];
                [self setBackgroundImage:button30_high  forState:UIControlStateHighlighted];
                
                // font
                self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                [self setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateNormal];
                self.titleLabel.shadowOffset = CGSizeMake(0,-1);
                
                // break
                break;
            }
                
            // default
            default: {
                
                // background
                UIImage *transparent = [[[UIImage alloc] init] autorelease];
                [self setBackgroundImage:transparent forState:UIControlStateNormal];
                [self setBackgroundImage:transparent forState:UIControlStateHighlighted];
                [self setBackgroundColor:[UIColor clearColor]];
                
                // font
                self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
                [self setTitleColor:[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0] forState:UIControlStateHighlighted];
                
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
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateHighlighted|UIControlStateSelected];
        
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
    self.titleLabel.frame = CGRectMake(-5, (int)(self.frame.size.height/2.0)+8, self.frame.size.width+10, 12);
    
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
        [_barButton setTitleColor:[UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [_barButton setTitleColor:[UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0] forState:UIControlStateSelected];
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
#pragma mark Implementation SegmentedControl
#pragma mark -

/*
 * Helper Stack.
 */
@interface SegmentedControl (Helpers)
- (void)buttonTouchUpInside:(UIButton*)b;
- (void)buttonTouchDown:(UIButton*)b;
- (void)buttonTouchOther:(UIButton*)b;
- (void)selectButton:(UIButton*)b;
@end


/**
 * Custom SegmentedControl.
 */
@implementation SegmentedControl


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark Object

/*
 * Initialize.
 */
- (id)initWithTitles:(NSArray*)titles {
    return [self initWithTitles:titles size:CGSizeMake(116, 32) gap:1 cap:10 image:@"app_segment.png" selected:@"app_segment-selected.png" divider:@"app_segment_divider.png"];
}
- (id)initWithTitles:(NSArray*)titles size:(CGSize)size gap:(int)gap cap:(int)cap image:(NSString*)image selected:(NSString*)selected divider:(NSString*)divider {
    GLog();
    
    // super
    if ((self = [super init])) {
        
        // self
        self.frame = CGRectMake(0, 0, (size.width * titles.count) + (gap * (titles.count - 1)), size.height);
        
        // buttons
        NSMutableArray *btns = [[NSMutableArray alloc] init];
        _buttons = [btns retain];
        [btns release];
        
        // init segments
        CGFloat offset = 0;
        for (NSUInteger i = 0 ; i < [titles count] ; i++) {
            
            // cap
            SegmentCapLocation capLocation = SegmentCapMiddle;
            if (i == 0) {
                capLocation = SegmentCapLeft;
            }
            else if (i == titles.count - 1) {
                capLocation = SegmentCapRight;
            }
            
            // create segment
            UIButton* button = [[SegmentedControlItem alloc] initSegmentedControlItem:size capLocation:capLocation capWidth:cap title:[titles objectAtIndex:i] image:image selected:selected];
            
            // events
            [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(buttonTouchOther:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(buttonTouchOther:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(buttonTouchOther:) forControlEvents:UIControlEventTouchDragInside];
            
            // add
            [_buttons addObject:button];
            
            
            // frame
            button.frame = CGRectMake(offset, 0.0, button.frame.size.width, button.frame.size.height);
            
            // subview
            [self addSubview:button];
            [button release];
            
            // divider
            if (i != titles.count - 1) {
                UIImageView* div = [[UIImageView alloc] initWithImage:[UIImage imageNamed:divider]];
                div.frame = CGRectMake(offset + size.width, 0.0, gap, size.height);
                div.backgroundColor = [UIColor clearColor];
                div.contentMode = UIViewContentModeTopLeft;
                [self addSubview:div];
                [div release];
            }
            
            // offset
            offset += (size.width + gap);
        }
    }
    return self;
}


#pragma mark -
#pragma mark Business

/**
 * Select.
 */
- (void)select:(int)ndx {
    FLog();
    [self selectButton:[_buttons objectAtIndex:ndx]];
}

/**
 * Returns the segment buttons for customisation.
 */
- (NSArray*)segmentButtons {
    return _buttons;
}

#pragma mark -
#pragma mark Helpers


/*
 * Selects a button.
 */
- (void)selectButton:(UIButton *)b {
    GLog();
    
    // select
    for (UIButton* button in _buttons) {
        
        // select
        if (button == b) {
            button.selected = YES;
            button.highlighted = button.selected ? NO : YES;
        }
        // deselect
        else {
            button.selected = NO;
            button.highlighted = NO;
        }
    }
}

/*
 * Touch down.
 */
- (void)buttonTouchDown:(UIButton*)button {
    GLog();
    
    // select
    [self selectButton:button];
    
    // delegate
    if ([delegate respondsToSelector:@selector(segmentedControlDown:)]) {
        [delegate segmentedControlDown:[_buttons indexOfObject:button]];
    }
}

/*
 * Touch up.
 */
- (void)buttonTouchUpInside:(UIButton*)button {
    GLog();
    
    // select
    [self selectButton:button];
    
    // delegate
    if ([delegate respondsToSelector:@selector(segmentedControlTouched:)]) {
        [delegate segmentedControlTouched:[_buttons indexOfObject:button]];
    }
}

/*
 * Touch other.
 */
- (void)buttonTouchOther:(UIButton*)button {
    GLog();
    
    // select
    [self selectButton:button];
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// release
	[_buttons release];
	
	// done
	[super dealloc];
}

@end





/*
 * Helper Stack.
 */
@interface SegmentedControlItem (Helpers)
-(UIImage*)image:(UIImage*)image withCap:(SegmentCapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;
@end

/**
 * SegmentedControlItem.
 */
@implementation SegmentedControlItem


#pragma mark -
#pragma mark Object

/*
 * Initialize.
 */
- (id)initSegmentedControlItem:(CGSize)size capLocation:(SegmentCapLocation)capLocation capWidth:(NSUInteger)capWidth title:(NSString*)title image:(NSString*)image selected:(NSString*)selected {
    GLog();
    
    // init
    if ((self = [super init])) {
        
        // self
        self.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        
        // image
        UIImage* buttonImage = nil;
        UIImage* buttonSelectedImage = nil;
        if (capLocation == SegmentCapLeftAndRight) {
            buttonImage = [[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
            buttonSelectedImage = [[UIImage imageNamed:selected] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
        }
        else {
            buttonImage = [self image:[[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:capLocation capWidth:capWidth buttonWidth:size.width];
            buttonSelectedImage = [self image:[[UIImage imageNamed:selected] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:capLocation capWidth:capWidth buttonWidth:size.width];
        }
        
        // background
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self setBackgroundImage:buttonSelectedImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:buttonSelectedImage forState:UIControlStateSelected];
        self.adjustsImageWhenHighlighted = NO;
        
        
        // title
        [self setTitle:title forState:UIControlStateNormal];
        
        // fonts
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self setTitleColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        self.titleLabel.shadowOffset = CGSizeMake(0,1);
        [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0] forState:UIControlStateSelected];
        
        
    }
    return self;
    
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // adjust label
    CGRect tFrame = self.titleLabel.frame;
    tFrame.origin.y += 1;
    self.titleLabel.frame = tFrame;
}


#pragma mark -
#pragma mark Helpers

/*
 * Generates a custom image.
 */
-(UIImage*)image:(UIImage*)image withCap:(SegmentCapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth {
    
    // create image
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == SegmentCapLeft) {
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    }
    else if (location == SegmentCapRight) {
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    }
    else if (location == SegmentCapMiddle) {
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    }
    
    
    // result
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // return
    return resultImage;
}
@end




#pragma mark -
#pragma mark Implementation NavigationController
#pragma mark -


/**
 * NavigationController.
 */
@implementation NavigationController


#pragma mark -
#pragma mark Controller

/*
 * Init.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    GLog();
    
    // init super
    if ((self = [super initWithRootViewController:rootViewController])) {
        
        // translucent
        [self.navigationBar setTranslucent:NO];
        
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
 * Status.
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}


/*
 * Dealloc.
 */
- (void)dealloc {
    FLog();
    [super dealloc];
}


@end



#pragma mark -
#pragma mark Implementation MailComposeController
#pragma mark -


/**
 * MailComposeController.
 */
@implementation MailComposeController


#pragma mark -
#pragma mark Controller

/*
 * Init.
 */
- (id)init {
    GLog();
    
    // init super
    if ((self = [super init])) {
        if (! iOS6) {
            
            // translucent
            [self.navigationBar setTranslucent:NO];
            
            // tint
            [self.navigationBar setTintColor:[UIColor whiteColor]];
        }
        
    }
    return self;
}


/*
 * Rotate.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/*
 * Status.
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end



#pragma mark -
#pragma mark Implementation PopoverController
#pragma mark -


/**
 * PopoverController.
 */
@implementation PopoverController


#pragma mark -
#pragma mark Controller

/*
 * Init.
 */
- (id)initWithContentViewController:(UIViewController *)viewController {
    GLog();
    
    // init super
    if ((self = [super initWithContentViewController:viewController])) {
        
    }
    return self;
}



@end




