//
//  SearchViewController.h
//  Solyaris
//
//  Created by Beat Raess on 25.4.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

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
- (void)dataSelected:(DBData*)data;
- (void)searchClose;
@end


/**
 * SearchTabViewController
 */
@interface SearchViewController : UIViewController <HeaderDelegate, DashboardDelegate, SearchResultDelegate>  {
    
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
    
    // gestures
    UITapGestureRecognizer *_tapRecognizer;
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




