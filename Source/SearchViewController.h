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
#import "DataDelegate.h"
#import "ExportDelegate.h"
#import "DashboardViewController.h"
#import "DBDataViewController.h"
#import "FavoritesViewController.h"
#import <QuartzCore/QuartzCore.h>


/*
 * Delegate.
 */
@protocol SearchDelegate <NSObject>
- (void)search:(NSString*)q type:(NSString*)type;
- (void)popular:(NSString*)type more:(BOOL)more;
- (void)nowPlaying:(NSString*)type more:(BOOL)more;
- (void)history:(NSString*)type;
- (void)searchSelected:(NSNumber*)dbid type:(NSString*)type;
- (void)searchClose;
@end


/**
 * SearchTabViewController.
 */
@interface SearchViewController : UIViewController <DashboardDelegate, DBDataDelegate, FavoritesDelegate, UIGestureRecognizerDelegate>  {
    
    // delegate
	id<SearchDelegate>delegate;
    id<DataDelegate>dta;
    id<ExportDelegate>exp;
    
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
    Button *_buttonExport;
    UILabel *_labelSearch;
    
    // controllers
    NavigationController *_searchNavigationController;
    
}

// Properties
@property (assign) id<SearchDelegate> delegate;
@property (assign) id<DataDelegate> dta;
@property (assign) id<ExportDelegate> exp;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic, retain) UIView *contentView;


// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Controller
- (void)dbdata;
- (void)favorites:(NSString *)type;
- (void)back;

// Business
- (void)searchChanged:(NSString*)txt;
- (void)loadedSearch:(Search*)search;
- (void)loadedPopular:(Popular*)popular more:(BOOL)more;
- (void)loadedNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more;
- (void)loadedHistory:(NSArray*)history type:(NSString *)type;
- (void)resize;

// Actions
- (void)actionSearch:(id)sender;
- (void)actionExport:(id)sender;

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




