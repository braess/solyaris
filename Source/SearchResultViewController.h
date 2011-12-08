//
//  SearchResultViewController.h
//  Solyaris
//
//  Created by CNPP on 8.7.2011.
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
#import "Search.h"
#import "SearchResult.h"
#import "CacheImageView.h"


// Constants
#define kSearchCellHeight  45.0f


/*
 * Delegate.
 */
@protocol SearchResultDelegate <NSObject>
- (void)searchSelected:(SearchResult*)result;
@end


/**
 * SearchResultViewController.
 */
@interface SearchResultViewController : UITableViewController {
    
    // delegate
	id<SearchResultDelegate>delegate;
    
    // data
    NSMutableString* _type;
    NSMutableArray* _data;
}

// Properties
@property (assign) id<SearchResultDelegate> delegate;

// Business
- (void)searchResultShow:(Search*)search;
- (void)searchResultReset;


@end


/**
 * SearchResultCell.
 */
@interface SearchResultCell : UITableViewCell {
    
    // ui
    UILabel *_labelData;
    CacheImageView *_thumbImageView;

    
}

// Properties
@property (nonatomic,retain) UILabel *labelData;

// Business
- (void)loadThumb:(NSString*)thumb type:(NSString*)type;


@end