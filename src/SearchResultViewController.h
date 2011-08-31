//
//  SearchResultViewController.h
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"
#import "SearchResult.h"
#import "CacheImageView.h"


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