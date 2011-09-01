//
//  InformationViewController.h
//  IMDG
//
//  Created by CNPP on 28.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheImageView.h"
#import "ActionBar.h"



//  Sections
enum {
    SectionInformationDirectors,
	SectionInformationActors,
	SectionInformationMovies,
    SectionInformationCrew
};

//  Tags
enum {
    TagInformationHeaderMovie,
    TagInformationHeaderPerson,
	TagInformationComponentListing,
    TagInformationComponentInformation,
    TagInformationComponentIMDb,
    TagInformationComponentWikipedia,
	TagInformationFooter
};


/**
 * Information.
 */
@interface Information : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *meta;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *nid;
@property bool visible;
@property bool loaded;

// Initializer
- (id)initWithValue:(NSString*)v meta:(NSString*)m type:(NSString*)t nid:(NSNumber*)n visible:(bool)iv loaded:(bool)il;

@end


/**
 * InformationBackgroundView.
 */
@interface InformationBackgroundView : UIView {
}
@end


/**
 * InformationMovieView.
 */
@interface InformationMovieView : UIView {
    
    // labels
    UILabel *_labelName;
    UILabel *_labelTagline;
    UILabel *_labelRuntime;
    UILabel *_labelReleased;
    CacheImageView *_imagePoster;
}

// Properteis
@property (nonatomic,retain) UILabel *labelName;
@property (nonatomic,retain) UILabel *labelTagline;
@property (nonatomic,retain) UILabel *labelRuntime;
@property (nonatomic,retain) UILabel *labelReleased;
@property (nonatomic,retain) CacheImageView *imagePoster;

@end


/**
 * InformationPersonView.
 */
@interface InformationPersonView : UIView {
    
    // labels
    UILabel *_labelName;
    UILabel *_labelBirthday;
    UILabel *_labelBirthplace;
    UILabel *_labelKnownMovies;
    CacheImageView *_imageProfile;
}

// Properteis
@property (nonatomic,retain) UILabel *labelName;
@property (nonatomic,retain) UILabel *labelBirthday;
@property (nonatomic,retain) UILabel *labelBirthplace;
@property (nonatomic,retain) UILabel *labelKnownMovies;
@property (nonatomic,retain) CacheImageView *imageProfile;

@end



/*
 * Info Delegate.
 */
@protocol InformationDelegate <NSObject>
- (void)informationDismiss;
- (void)informationSelected:(NSNumber*)nid type:(NSString*)type;
- (bool)informationOrientationLandscape;
@end


/**
 * InformationViewController.
 */
@interface InformationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    // delegate
	id<InformationDelegate> delegate;
    
    // ui
    UIView *_modalView;
    UIView *_contentView;
    InformationMovieView *_informationMovieView;
    InformationPersonView *_informationPersonView;
    UITableView *_componentListing;
    UITextView *_componentInformation;
    UIWebView *_componentIMDb;
    UIWebView *_componentWikipedia;
    
    // switch
    ActionBarButtonItem *_actionListing;
    ActionBarButtonItem *_actionInformation;
    ActionBarButtonItem *_actionIMDb;
    ActionBarButtonItem *_actionWikipedia;
    
    // buttons
    UIButton *_buttonResize;
    
    // data
	NSMutableArray *_movies;
	NSMutableArray *_actors;
    NSMutableArray *_directors;
    NSMutableArray *_crew;
    
    // private
    @private
    bool mode_listing;
    bool mode_information;
    bool mode_imdb;
    bool mode_wikipedia;
    bool fullscreen;
    CGRect vframe;
    
}


// Properties
@property (assign) id<InformationDelegate> delegate;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) NSMutableArray *movies;
@property (nonatomic, retain) NSMutableArray *actors;
@property (nonatomic, retain) NSMutableArray *directors;
@property (nonatomic, retain) NSMutableArray *crew;


// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Business Methods
- (void)resize;
- (void)informationMovie:(NSString*)name poster:(NSString*)poster tagline:(NSString*)tagline overview:(NSString*)overview released:(NSDate*)released runtime:(NSNumber*)runtime trailer:(NSString*)trailer homepage:(NSString*)homepage imdb_id:(NSString*)imdb_id;
- (void)informationPerson:(NSString*)name profile:(NSString*)profile biography:(NSString*)biography birthday:(NSDate*)birthday birthplace:(NSString*)birthplace known_movies:(NSNumber*)known_movies;


@end



/**
 * InformationCell.
 */
@interface InformationCell : UITableViewCell {
    
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
