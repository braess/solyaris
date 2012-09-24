//
//  ActionBar.m
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

#import "ActionBar.h"
#import <QuartzCore/QuartzCore.h>


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
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        
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

