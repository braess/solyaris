//
//  ActionBar.h
//  Solyaris
//
//  Created by CNPP on 1.9.2011.
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
