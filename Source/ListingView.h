//
//  ListingView.h
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
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
#import "CacheImageView.h"
#import "SolyarisConstants.h"


// Constants
#define kListingCellHeight  36.0f
#define kListingCellInset   (iPad ? 15.0f : 10.0f)
#define kListingCellThumb   25.0f
#define kListingGapHeight   (iPad ? 35.0f : 34.0f)
#define kListingGapOffset   5.0f
#define kListingGapInset    (iPad ? 15.0f : 10.0f)


// Sections
enum {
    SectionListingDirectors,
    SectionListingCrew,
	SectionListingActors,
	SectionListingMovies
};


/*
 * Listing Delegate.
 */
@protocol ListingDelegate <NSObject>
- (void)listingSelected:(NSNumber*)nid type:(NSString*)type;
@end


/**
 * ListingView.
 */
@interface ListingView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    // delegate
	id<ListingDelegate> delegate;
    
    // ui
    UITableView *_tableView;
    
    // data
	NSMutableArray *_movies;
	NSMutableArray *_actors;
    NSMutableArray *_directors;
    NSMutableArray *_crew;

}

// Properties
@property (assign) id<ListingDelegate> delegate;


// Methods
- (void)reset:(NSArray*)nodes;
- (void)load;
- (void)scrollTop:(bool)animated;
- (void)resize;

@end



/**
 * ListingCell.
 */
@interface ListingCell : UITableViewCell {
    
    // ui
    UILabel *_labelInfo;
    UILabel *_labelMeta;
    NSString *_type;
    CacheImageView *_thumbImageView;
    
    // state
    bool loaded;
    
}

// Properties
@property (nonatomic,retain) UILabel *labelInfo;
@property (nonatomic,retain) UILabel *labelMeta;
@property (nonatomic,retain) NSString *type;
@property bool loaded;
@property bool visible;

// Business
- (void)update;
- (void)reset;
- (void)loadThumb:(NSString*)thumb type:(NSString*)type;

@end