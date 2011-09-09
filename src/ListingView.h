//
//  ListingView.h
//  IMDG
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>


//  Sections
enum {
    SectionListingDirectors,
	SectionListingActors,
	SectionListingMovies,
    SectionListingCrew
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
    UIImageView *_iconMovie;
    UIImageView *_iconActor;
    UIImageView *_iconDirector;
    UIImageView *_iconCrew;
    
    // state
    bool loaded;
    
}

// Properties
@property (nonatomic,retain) UILabel *labelInfo;
@property (nonatomic,retain) UILabel *labelMeta;
@property (nonatomic,retain) NSString *type;
@property bool loaded;
@property bool visible;

@end