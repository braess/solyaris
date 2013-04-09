//
//  Appearance.h
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

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

/**
 * Appearance.
 */
@interface Appearance : NSObject {
    
}

// Business
+ (void)appearance;

@end


// Data types
enum {
    ButtonStyleDefault,
    ButtonStyleLite
};

/**
 * Button.
 */
@interface Button : UIButton {
    
}
- (id)initStyle:(int)style;

@end



/**
 * LinkButtonDelegate Protocol.
 */
@class LinkButton;
@protocol LinkButtonDelegate <NSObject>
- (void)linkButtonTouched:(LinkButton*)lb;
@optional
- (void)linkButtonDown:(LinkButton*)lb;
- (void)linkButtonUp:(LinkButton*)lb;
@end


/**
 * Link Button.
 */
@interface LinkButton : UIButton {
    
    // delegate
	id<LinkButtonDelegate>delegate;
    
    // link
    NSString *_link;
    
    // private
@private
    BOOL mode_transparent;
}

// Properties
@property (assign) id<LinkButtonDelegate> delegate;
@property (nonatomic, retain) NSString *link;

// Business
- (void)transparent:(BOOL)flag;

@end


/**
 * ActionBar.
 */
@interface ActionBar : UIToolbar {
    
}

@end

/**
 * Custom ActionBarButton.
 */
@interface ActionBarButton : UIButton {
    
    
}

// Constructor
- (id)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;
- (id)initWithImage:(UIImage *)image selected:(UIImage*)selected title:(NSString *)title target:(id)target action:(SEL)action;

@end


/**
 * Custom ActionBarButtonItem.
 */
@interface ActionBarButtonItem : UIBarButtonItem {
    
    // button
    ActionBarButton *_barButton;
}

// Constructor
- (id)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;
- (id)initWithImage:(UIImage *)image selected:(UIImage*)selected title:(NSString *)title target:(id)target action:(SEL)action;
- (void)setSelected:(BOOL)s;
- (void)setFrame:(CGRect)frame;
- (void)setTitle:(NSString *)title;
- (void)dark:(BOOL)flag;

@end


/**
 * PopoverBackgroundView.
 */
@interface PopoverBackgroundView : UIPopoverBackgroundView {
    UIImageView *_popover;
    UIImageView *_arrow;
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}
@end



/**
 * NavigationController.
 */
@interface NavigationController : UINavigationController

@end


/**
 * MailComposeController.
 */
@interface MailComposeController : MFMailComposeViewController

@end





