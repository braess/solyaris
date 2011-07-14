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


/*
 * Delegate.
 */
@protocol SearchResultDelegate <NSObject>
- (void)selectedResult:(SearchResult*)result;
- (void)cancelSearch;
@end


/**
 * SearchResultViewController.
 */
@interface SearchResultViewController : UITableViewController {
    
    // delegate
	id<SearchResultDelegate>delegate;
    
    // data
    NSMutableArray* _data;
}

// Properties
@property (assign) id<SearchResultDelegate> delegate;

// Business
- (void)showResults:(Search*)search;
- (void)resetResults;

// Actions
- (void)actionCancel:(id)sender;

@end
