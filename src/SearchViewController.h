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
- (void)search:(NSString*)q type:(NSString*)type;
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
    UIButton *_buttonPerson;
    UIButton *_buttonReset;
    
    // private
    @private
    CGRect vframe;
    UIView *_background;
    UIImageView *_logo;
    UILabel *_labelTitle;
    
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Properties
@property (assign) id<SearchDelegate> delegate;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIButton *buttonMovie;
@property (nonatomic, retain) UIButton *buttonPerson;


// Action Methods
- (void)actionMovie:(id)sender;
- (void)actionPerson:(id)sender;
- (void)actionReset:(id)sender;

// Business
- (void)resize;

@end
