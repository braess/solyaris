//
//  SearchViewController.h
//  IMDG
//
//  Created by CNPP on 5.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 * Delegate.
 */
@protocol SearchDelegate <NSObject>
- (void)search:(NSString*)q type:(NSString*)t;
- (void)reset;
@end


/**
 * SearchViewController.
 */
@interface SearchViewController : UIViewController <UISearchBarDelegate> {
    
    // delegate
	id<SearchDelegate>delegate;
    
    // ui
    UISearchBar *_searchBar;
    UIButton *_buttonMovie;
    UIButton *_buttonActor;
    UIButton *_buttonDirector;
    UIButton *_buttonReset;
    
    // private
    @private
    UIView *_background;
    UILabel *_labelTitle;
    UILabel *_labelClaim;
    
}

// Properties
@property (assign) id<SearchDelegate> delegate;
@property (nonatomic, retain) UIButton *buttonMovie;
@property (nonatomic, retain) UIButton *buttonActor;
@property (nonatomic, retain) UIButton *buttonDirector;

// Action Methods
- (void)actionMovie:(id)sender;
- (void)actionActor:(id)sender;
- (void)actionDirector:(id)sender;
- (void)actionReset:(id)sender;

// Business
- (void)resize;

@end
