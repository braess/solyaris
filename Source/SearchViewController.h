//
//  SearchViewController.h
//  Solyaris
//
//  Created by Beat Raess on 25.4.2012.
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
#import "AppControllers.h"
#import "AppButtons.h"
#import "HeaderView.h"
#import "DashboardViewController.h"
#import "DBDataViewController.h"
#import <QuartzCore/QuartzCore.h>


// Declarations
@class SearchNavigationController;


/*
 * Delegate.
 */
@protocol SearchDelegate <NSObject>
- (void)search:(NSString*)q type:(NSString*)type;
- (void)popular:(NSString*)type more:(BOOL)more;
- (void)nowPlaying:(NSString*)type more:(BOOL)more;
- (void)history:(NSString*)type;
- (void)searchSelected:(DBData*)data;
- (void)searchClose;
@end


/**
 * SearchTabViewController.
 */
@interface SearchViewController : UIViewController <HeaderDelegate, DashboardDelegate, DBDataDelegate>  {
    
    // delegate
	id<SearchDelegate>delegate;
    
    // private
    @private
    
    // frame
    CGRect vframe;
    
    // search
    NSMutableString *_term;
    
    // ui
    UIView *_contentView;
    UIView *_modalView;
    UIView *_containerView;
    UIView *_footerView;
    CAGradientLayer *_dropShadow;
    
    // footer
    Button *_buttonSearch;
    UILabel *_labelSearch;
    
    // controllers
    NavigationController *_searchNavigationController;
    DashboardViewController *_dashboardViewController;
    DBDataViewController *_dbDataViewController;
    
}

// Properties
@property (assign) id<SearchDelegate> delegate;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic, retain) UIView *contentView;


// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Business
- (void)searchChanged:(NSString*)txt;
- (void)dataLoading;
- (void)loadedSearch:(Search*)search;
- (void)loadedPopular:(Popular*)popular more:(BOOL)more;
- (void)loadedNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more;
- (void)loadedHistory:(NSArray*)history type:(NSString *)type;
- (void)resize;
- (void)reset;

// Actions
- (void)actionSearch:(id)sender;

@end


/**
 * SearchView.
 */
@interface SearchView : UIView {
    @private
    UIImage *_texture;
    CGRect _tsize;
}
@end




