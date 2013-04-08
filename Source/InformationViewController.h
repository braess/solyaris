//
//  InformationViewController.h
//  Solyaris
//
//  Created by CNPP on 28.7.2011.
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
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "Appearance.h"
#import "CacheImageView.h"
#import "ListingView.h"
#import "HTMLView.h"
#import "TMDbView.h"
#import "VideoView.h"
#import "Movie.h"
#import "Person.h"
#import "Asset.h"
#import "SolyarisLocalization.h"
#import "SolyarisDataManager.h"


// Constants
#define kInformationHeaderHeight        (iPad ? 110.0f : 80.0f)
#define kInformationFooterHeight        (iPad ? 55.0f : 44.0f)
#define kInformationGapOffset           10.0f
#define kInformationGapInset            (iPad ? 15.0f : 10.0f)


//  Tags
enum {
    TagInformationHeaderMovie,
    TagInformationHeaderPerson,
	TagInformationComponentListing,
    TagInformationComponentTMDb,
    TagInformationComponentIMDb,
    TagInformationComponentWikipedia,
    TagInformationComponentTrailer,
	TagInformationFooter
};

//  Actions
enum {
    ActionInformationToolsReference,
    ActionInformationShare,
    ActionInformationTrailers
};


/**
 * InformationMovieView.
 */
@interface InformationMovieView : UIView {
    
    // labels
    UILabel *_labelTitle;
    UILabel *_labelTagline;
    UILabel *_labelRuntime;
    UILabel *_labelReleased;
    CacheImageView *_imagePoster;
}

// Interface
- (void)reset:(Movie*)movie;

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

// Interface
- (void)reset:(Person*)person;

@end



/*
 * Info Delegate.
 */
@protocol InformationDelegate <NSObject>
- (void)informationDismiss;
- (void)informationSelected:(NSNumber*)nid type:(NSString*)type;
@end


/**
 * InformationViewController.
 */
@interface InformationViewController : UIViewController <UIActionSheetDelegate, ListingDelegate, HTMLDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate> {
    
    // delegate
	id<InformationDelegate> delegate;
    
    // data
    SolyarisDataManager *_solyarisDataManager;
    
    // ui
    UIView *_modalView;
    UIView *_contentView;
    InformationMovieView *_informationMovieView;
    InformationPersonView *_informationPersonView;
    ListingView *_componentListing;
    TMDbView *_componentTMDb;
    HTMLView *_componentIMDb;
    HTMLView *_componentWikipedia;
    HTMLNavigatorView *_htmlNavigator;
    VideoView *_componentTrailer;
    
    // switch
    ActionBarButtonItem *_actionListing;
    ActionBarButtonItem *_actionTMDb;
    ActionBarButtonItem *_actionIMDb;
    ActionBarButtonItem *_actionWikipedia;
    
    // buttons
    UIButton *_buttonResize;
    UIButton *_buttonClose;
    UIButton *_buttonTrailer;
    UIButton *_buttonFavorite;
    UIButton *_buttonShare;
    
    // loader
    UIActivityIndicatorView *_loader;
    
    // private
    @private
    CGRect vframe;
    
    // types
    bool type_movie;
    bool type_person;
    
    // modes
    bool mode_listing;
    bool mode_tmdb;
    bool mode_imdb;
    bool mode_wikipedia;
    bool mode_trailer;
    
    bool fullscreen;
    
    // localization
    SolyarisLocalization *_sloc;
    
    // references
    NSMutableString *_referenceTMDb;
    NSMutableString *_referenceIMDb;
    NSMutableString *_referenceWikipedia;
    NSMutableString *_referenceAmazon;
    NSMutableString *_referenceITunes;
    
    // favorite
    NSMutableDictionary *_favorite;
    
    // share
    NSMutableDictionary *_share;
    
    // modes
    BOOL mode_loading;
    
}


// Properties
@property (assign) id<InformationDelegate> delegate;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic, retain) UIView *contentView;



// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Actions
- (void)actionResize:(id)sender;
- (void)actionClose:(id)sender;
- (void)actionFavorite:(id)sender;
- (void)actionTrailer:(id)sender;
- (void)actionShare:(id)sender;

// Business Methods
- (void)resize;
- (void)informationMovie:(Movie*)movie nodes:(NSArray*)nodes;
- (void)informationPerson:(Person*)person nodes:(NSArray*)nodes;
- (void)loading:(BOOL)loading;

@end




/**
 * InformationBackgroundView.
 */
@interface InformationBackgroundView : UIView {
    @private
    UIImage *_texture;
    CGRect _tsize;
}
@end

