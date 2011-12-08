//
//  SearchViewController.h
//  Solyaris
//
//  Created by CNPP on 5.8.2011.
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


/*
 * Delegate.
 */
@protocol SearchDelegate <NSObject>
- (void)search:(NSString*)q type:(NSString*)type;
- (void)reset;
- (void)logo;
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
    UIButton *_buttonLogo;
    UILabel *_labelTitle;
    UILabel *_labelClaim;
    
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Properties
@property (assign) id<SearchDelegate> delegate;
@property (nonatomic, retain) UIButton *buttonMovie;
@property (nonatomic, retain) UIButton *buttonPerson;


// Action Methods
- (void)actionLogo:(id)sender;
- (void)actionMovie:(id)sender;
- (void)actionPerson:(id)sender;
- (void)actionReset:(id)sender;

// Business
- (void)claim:(NSString*)claim;
- (void)resize;

@end
