//
//  RelatedViewController.h
//  Solyaris
//
//  Created by Beat Raess on 29.5.2012.
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

#import <UIKit/UIKit.h>
#import "DBDataViewController.h"

/*
 * Delegate.
 */
@protocol RelatedDelegate <NSObject>
- (void)relatedSelected:(DBData*)data;
- (void)relatedLoadMore:(DBData*)data;
- (void)relatedClose;
@end


/**
 * RelatedViewController.
 */
@interface RelatedViewController : UIViewController <DBDataDelegate, UIGestureRecognizerDelegate> {
    
    // delegate
	id<RelatedDelegate>delegate;
    
    // private
    @private
    
    // frame
    CGRect vframe;
    CGPoint vPos;
    
    // ui
    UIView *_modalView;
    UIView *_contentView;
    UIView *_containerView;
    UIButton *_buttonClose;
    
    // controllers
    DBDataViewController *_dbDataViewController;
    
}

// Properties
@property (assign) id<RelatedDelegate> delegate;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic, retain) UIView *contentView;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Business
- (void)loadedRelated:(Movie*)movie more:(BOOL)more;
- (void)resize;
- (CGPoint)position:(double)r posx:(double)px posy:(double)py;

// Actions
- (void)actionClose:(id)sender;

@end


/**
 * RelatedView.
 */
@interface RelatedView : UIView {
    UIView *_line;
}
@end
