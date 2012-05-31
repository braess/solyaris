//
//  DBDataViewController.h
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
#import "Popular.h"
#import "PopularResult.h"
#import "NowPlaying.h"
#import "NowPlayingResult.h"
#import "Similar.h"
#import "SimilarMovie.h"
#import "Movie.h"
#import "Person.h"
#import "Asset.h"
#import "DBData.h"
#import "HeaderView.h"
#import "AppButtons.h"
#import "CacheImageView.h"



// Declarations
@class  SearchNotfoundView;

// Data types
enum {
    SectionDBDataResults
};

// Data types
enum {
    DBDataUndef,
    DBDataSearchResult,
    DBDataNowPlaying,
	DBDataPopularMovies,
    DBDataHistory,
    DBDataMovieRelated
};

/*
 * Delegate.
 */
@protocol DBDataDelegate <NSObject>
- (void)dbDataSelected:(DBData*)data;
- (void)dbDataLoadMore:(DBData*)data;
@end


/**
 * DBDataViewController.
 */
@interface DBDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    // delegate
	id<DBDataDelegate>delegate;
    
    // data
    NSMutableArray* _data;
    
    // private
    @private
    
    // ui
    UITableView *_results;
    UIActivityIndicatorView *_loader;
    SearchNotfoundView *_notfound;
    UIView *_error;

    // modes
    BOOL mode_reset;
    BOOL mode_result;
    BOOL mode_notfound;
    BOOL mode_loading;
    BOOL mode_error;

}

// Properties
@property (assign) id<DBDataDelegate> delegate;
@property (nonatomic,assign) HeaderView* header;

// Business
- (void)reset;
- (void)update;
- (void)dbSearchResult:(Search*)search;
- (void)dbPopularResult:(Popular*)popular more:(BOOL)more;
- (void)dbNowPlayingResult:(NowPlaying*)nowplaying more:(BOOL)more;
- (void)dbMovieRelated:(Movie*)movie more:(BOOL)more;
- (void)dbHistoryResult:(NSArray*)history type:(NSString*)type;
- (void)dbDataReset;
- (void)dbDataLoading;
- (void)hideBack:(BOOL)hide;
- (void)titleFont:(UIFont*)thaFont;

@end



/**
 * SearchNotfoundView.
 */
@interface SearchNotfoundView : UIView {
    
    // ui
    UILabel *_labelMessage;
    UILabel *_labelInfo;
    UIImageView *_logoTMDb;
    LinkButton *_linkbuttonTMDb;
    
}

// Properties
@property (nonatomic, retain) UILabel *labelMessage;

// Actions
- (void)actionTMDb:(id)sender;
@end