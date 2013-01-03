//
//  AppControllers.m
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

#import "AppControllers.h"


/**
 * AppControllers.
 */
@implementation AppControllers

/**
 * Changes the appearance.
 */
+ (void)appAppearance {
    FLog();
    
    // ios5
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        
        // resizable images
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
	return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad);
}


@end




