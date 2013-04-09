//
//  InformationViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import "InformationViewController.h"
#import "SolyarisAppDelegate.h"
#import "SolyarisConstants.h"
#import "DataNode.h"
#import "Utils.h"
#import "NSData+Base64.h"
#import "Tracker.h"

/**
 * Gesture Stack.
 */
@interface InformationViewController (GestureStack)
- (void)gestureTap:(UITapGestureRecognizer *)recognizer;
@end


/**
 * Swap Stack.
 */
@interface InformationViewController (SwapStack)
- (void)swapListing;
- (void)swapTMDb;
- (void)swapIMDb;
- (void)swapWikipedia;
- (void)swapTrailer:(int)vndx;
- (void)swapReset;
@end


/**
 * Action Stack.
 */
@interface InformationViewController (ActionStack)
- (void)resizeFull;
- (void)resizeDefault;
- (void)resizeDone;
- (void)actionToolsReference:(id)sender;
@end

/**
 * Reference Stack.
 */
@interface InformationViewController (ReferenceStack)
- (void)referenceTMDb;
- (void)referenceIMDb;
- (void)referenceWikipedia;
- (void)referenceAmazon;
- (void)referenceITunes;
@end

/**
 * Share Stack.
 */
@interface InformationViewController (ShareStack)
- (void)shareEmail;
- (void)shareTwitter;
- (void)shareFacebook;
@end



#pragma mark -
#pragma mark InformationViewController
#pragma mark -

/**
 * InformationViewController.
 */
@implementation InformationViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeResizeFull      0.3f
#define kAnimateTimeResizeDefault	0.3f

// share
#define kShareTitle                 @"title"
#define kShareTagline               @"tagline"
#define kShareReleased              @"released"
#define kShareRuntime               @"runtime"
#define kShareThumb                 @"thumb"
#define kShareImage                 @"image"
#define kShareOverview              @"overview"
#define kShareLink                  @"link"


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize modalView = _modalView;
@synthesize contentView = _contentView;



#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id)init {
	return [self initWithFrame:CGRectMake(0, 0, 580, 640)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
        
        // data manager
        SolyarisDataManager *solyarisDM = [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] solyarisDataManager];
        _solyarisDataManager = [solyarisDM retain];
        
        // type
        type_movie = NO;
        type_person = NO;
        
        // modes
        mode_listing = NO;
        mode_tmdb = NO;
        mode_imdb = NO;
        mode_wikipedia = NO;
        mode_trailer = NO;
        
        // screen
        fullscreen = NO;
        
        // localization
        _sloc = [[SolyarisLocalization alloc] init];
        
        // fields
        _referenceTMDb = [[NSMutableString alloc] init];
        _referenceIMDb = [[NSMutableString alloc] init];
        _referenceWikipedia = [[NSMutableString alloc] init];
        _referenceAmazon = [[NSMutableString alloc] init];
        _referenceITunes = [[NSMutableString alloc] init];
        
        // favorite
        NSMutableDictionary *favorite = [[NSMutableDictionary alloc] init];
        _favorite = [favorite retain];
        [favorite release];
        
        // share
        NSMutableDictionary *share = [[NSMutableDictionary alloc] init];
        _share = [share retain];
        [share release];

	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // frames
    CGRect contentFrame = CGRectMake(screen.size.width/2.0-vframe.size.width/2.0, screen.size.height/2.0-vframe.size.height/2.0, vframe.size.width, vframe.size.height);
    CGRect headerFrame = CGRectMake(0, 0, contentFrame.size.width, kInformationHeaderHeight);
    CGRect footerFrame = CGRectMake(0, contentFrame.size.height-kInformationFooterHeight, contentFrame.size.width, kInformationFooterHeight);
    CGRect componentFrame = CGRectMake(0, kInformationHeaderHeight, contentFrame.size.width, contentFrame.size.height-kInformationHeaderHeight-kInformationFooterHeight);
    CGRect trailerFrame = CGRectMake(kInformationGapInset, kInformationHeaderHeight+kInformationGapInset, contentFrame.size.width-2*kInformationGapInset, contentFrame.size.height-kInformationHeaderHeight-kInformationFooterHeight-2*kInformationGapInset);
    CGRect actionBarFrame = CGRectMake(0, 0, footerFrame.size.width, footerFrame.size.height);
    CGRect toolsFrame = CGRectMake(footerFrame.size.width-kInformationGapInset-80, 5, 80, kInformationFooterHeight-10);
    CGRect navigatorFrame = CGRectMake(kInformationGapInset, 5, 80, kInformationFooterHeight-10);
    
    // view
    UIView *sview = [[UIView alloc] initWithFrame:screen];
    sview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // view
    self.view = sview;
    [sview release];
    
    
    // modal
    UIView *mView = [[UIView alloc] initWithFrame:screen];
    mView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mView.backgroundColor = [UIColor blackColor];
    mView.opaque = NO;
    mView.alpha = 0.3;
    _modalView = [mView retain];
    [self.view addSubview:_modalView];
    [mView release];

	
	// content
    InformationBackgroundView *ctView = [[InformationBackgroundView alloc] initWithFrame:contentFrame];
    
    
    // header view
    InformationMovieView *nfoMovieView = [[InformationMovieView alloc] initWithFrame:headerFrame];
    nfoMovieView.tag = TagInformationHeaderMovie;
    nfoMovieView.hidden = YES;
    
    InformationPersonView *nfoPersonView = [[InformationPersonView alloc] initWithFrame:headerFrame];
    nfoPersonView.tag = TagInformationHeaderPerson;
    nfoPersonView.hidden = YES;
    
    
    // add header view to content
    _informationMovieView = [nfoMovieView retain];
    [ctView addSubview:_informationMovieView];
    [nfoMovieView release];
    
    _informationPersonView = [nfoPersonView retain];
    [ctView addSubview:_informationPersonView];
    [nfoPersonView release];
    
    
    // resize
    UIButton *btnResize = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnResize.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    btnResize.frame = CGRectMake(contentFrame.size.width-44, 0, 44, 44);
    [btnResize setImage:[UIImage imageNamed:@"btn_resize-full.png"] forState:UIControlStateNormal];
    [btnResize addTarget:self action:@selector(actionResize:) forControlEvents:UIControlEventTouchUpInside];
    _buttonResize = [btnResize retain];
    
    // close
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnClose.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    btnClose.frame = CGRectMake(contentFrame.size.width-44, 0, 44, 44);
    [btnClose setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    _buttonClose = [btnClose retain];
    
    // ipad
    if (iPad) {
        [ctView  addSubview:_buttonResize];
    }
    else {
        [ctView  addSubview:_buttonClose];
    }
    
    // button favorite
    UIButton *btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFavorite.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    btnFavorite.frame = CGRectMake(headerFrame.size.width-44-kInformationGapInset+6, headerFrame.size.height-44-kInformationGapOffset+(iPad ? 1 : 10), 44, 44);
    [btnFavorite setImage:[UIImage imageNamed:@"btn_favorite-off.png"] forState:UIControlStateNormal];
    [btnFavorite setImage:[UIImage imageNamed:@"btn_favorite-on.png"] forState:UIControlStateSelected];
    [btnFavorite setImage:[UIImage imageNamed:@"btn_favorite-on.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnFavorite addTarget:self action:@selector(actionFavorite:) forControlEvents:UIControlEventTouchUpInside];
    _buttonFavorite = [btnFavorite retain];
    [ctView addSubview:_buttonFavorite];
    
    // button share
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    btnShare.frame = CGRectMake(headerFrame.size.width-88-kInformationGapInset+6, headerFrame.size.height-44-kInformationGapOffset+(iPad ? 1 : 10), 44, 44);
    [btnShare setImage:[UIImage imageNamed:@"btn_share.png"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(actionShare:) forControlEvents:UIControlEventTouchUpInside];
    _buttonShare = [btnShare retain];
    [ctView addSubview:_buttonShare];
    
    
    // button trailer
    UIButton *btnTrailer = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnTrailer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    btnTrailer.frame = CGRectMake(headerFrame.size.width-132-kInformationGapInset+6, headerFrame.size.height-44-kInformationGapOffset+(iPad ? 1 : 10), 44, 44);
    [btnTrailer setImage:[UIImage imageNamed:@"btn_trailer.png"] forState:UIControlStateNormal];
    [btnTrailer addTarget:self action:@selector(actionTrailer:) forControlEvents:UIControlEventTouchUpInside];
    _buttonTrailer = [btnTrailer retain];
    [ctView addSubview:_buttonTrailer];

    
    // component listing
    ListingView *componentListing = [[ListingView alloc] initWithFrame:componentFrame];
    componentListing.delegate = self;
    componentListing.tag = TagInformationComponentListing;
    componentListing.hidden = YES;
    
    // add listing to content
    _componentListing = [componentListing retain];
    [ctView addSubview:_componentListing];
    [componentListing release];
    
    
    // component tmdb
	TMDbView *componentTMDb = [[TMDbView alloc] initWithFrame:componentFrame];
    componentTMDb.tag = TagInformationComponentTMDb;
    
    // add tmdb to content
    _componentTMDb = [componentTMDb retain];
    [ctView addSubview:_componentTMDb];
    [componentTMDb release];
    
    // component imdb
    HTMLView *componentIMDb = [[HTMLView alloc] initWithFrame:componentFrame];
    componentIMDb.tag = TagInformationComponentIMDb;
    componentIMDb.hidden = YES;
    [componentIMDb base:@"imdb"];
    
    // add imdb to content
    _componentIMDb = [componentIMDb retain];
    [ctView addSubview:_componentIMDb];
    [componentIMDb release];
    
    // component wikipedia
    HTMLView *componentWikipedia = [[HTMLView alloc] initWithFrame:componentFrame];
    componentWikipedia.tag = TagInformationComponentWikipedia;
    componentWikipedia.hidden = YES;
    [componentWikipedia base:@"wikipedia"];
    
    // add wikipedia to content
    _componentWikipedia = [componentWikipedia retain];
    [ctView addSubview:_componentWikipedia];
    [componentWikipedia release];
    
    
    // component trailer
    VideoView *componentTrailer = [[VideoView alloc] initWithFrame:trailerFrame];
    componentTrailer.tag = TagInformationComponentTrailer;
    componentTrailer.hidden = YES;
    
    // add trailer to content
    _componentTrailer = [componentTrailer retain];
    [ctView addSubview:_componentTrailer];
    [componentTrailer release];

    
    // footer view
    UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
    footerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin);
    footerView.tag = TagInformationFooter;
	footerView.backgroundColor = [UIColor clearColor];
	footerView.opaque = YES;
    
    // actions
    ActionBar *abar = [[ActionBar alloc] initWithFrame:actionBarFrame];
    
    // flex
	UIBarButtonItem *itemFlex = [[UIBarButtonItem alloc] 
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                             target:nil 
                             action:nil];
    
    // negative space (weird 12px offset...)
    UIBarButtonItem *nspace = [[UIBarButtonItem alloc] 
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                               target:nil 
                               action:nil];
    nspace.width = -12;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] 
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                               target:nil 
                               action:nil];
    spacer.width = -10;
    
    
    // action items
    ActionBarButtonItem *actionListing = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_listing.png"] 
                                                                           selected:[UIImage imageNamed:@"tab_listing_selected.png"] 
                                                                              title:NSLocalizedString(@"Cast", @"Cast") 
                                                                             target:self 
                                                                             action:@selector(swapListing)];
    [actionListing setFrame:CGRectMake(0, 0, 80, kInformationFooterHeight)];
    _actionListing = [actionListing retain];
    [actionListing release];
    
    ActionBarButtonItem *actionTMDb = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_tmdb.png"] 
                                                                        selected:[UIImage imageNamed:@"tab_tmdb_selected.png"] 
                                                                                  title:NSLocalizedString(@"Info", @"Info")
                                                                                 target:self 
                                                                                 action:@selector(swapTMDb)];
    [actionTMDb setFrame:CGRectMake(0, 0, 80, kInformationFooterHeight)];
    _actionTMDb = [actionTMDb retain];
    [actionTMDb release];
    
    ActionBarButtonItem *actionIMDb = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_imdb.png"] 
                                                                        selected:[UIImage imageNamed:@"tab_imdb_selected.png"] 
                                                                           title:NSLocalizedString(@"IMDb", @"IMDb")
                                                                          target:self 
                                                                          action:@selector(swapIMDb)];
    [actionIMDb setFrame:CGRectMake(0, 0, 80, kInformationFooterHeight)];
    _actionIMDb = [actionIMDb retain];
    [actionIMDb release];
    
    ActionBarButtonItem *actionWikipedia = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_wikipedia.png"] 
                                                                             selected:[UIImage imageNamed:@"tab_wikipedia_selected.png"] 
                                                                                title:NSLocalizedString(@"Wikipedia", @"Wikipedia")
                                                                               target:self 
                                                                               action:@selector(swapWikipedia)];
    [actionWikipedia setFrame:CGRectMake(0, 0, 80, kInformationFooterHeight)];
    _actionWikipedia = [actionWikipedia retain];
    [actionWikipedia release];
    
    
    // add action tab bar
    [abar setItems:[NSArray arrayWithObjects:nspace,itemFlex,_actionListing,spacer,_actionTMDb,spacer,_actionIMDb,spacer,_actionWikipedia,itemFlex,nspace,nil]];
    [footerView addSubview:abar];
    [itemFlex release];
    [spacer release];
    [nspace release];
    [abar release];
    
    // navigator
    HTMLNavigatorView *htmlNavigator = [[HTMLNavigatorView alloc] initWithFrame:navigatorFrame];
    htmlNavigator.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin);
    htmlNavigator.delegate = self;
    
    _htmlNavigator = [htmlNavigator retain];
    [htmlNavigator release];
    
    // tools
    UIView *toolsView = [[UIView alloc] initWithFrame:toolsFrame];
    toolsView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    toolsView.backgroundColor = [UIColor clearColor];
    
    // reference
    UIButton *btnReference = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReference.frame = CGRectMake(toolsView.frame.size.width-44, 0, 44, 44);
    btnReference.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [btnReference setImage:[UIImage imageNamed:@"btn_reference.png"] forState:UIControlStateNormal];
    [btnReference addTarget:self action:@selector(actionToolsReference:) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:btnReference];
    
    // ipad
    if (iPad) {
        
        // add navigator to footer
        [footerView addSubview:_htmlNavigator];
        
        // add tools to footer
        [footerView addSubview:toolsView];
    }
    [toolsView release];
    
    // add footer view to content
    [ctView addSubview:footerView];
    [footerView release];
    
    // add & release content
    _contentView = [ctView retain];
    [self.view addSubview:_contentView];
    [self.view bringSubviewToFront:_contentView];
    [ctView release];
    
    // hide
    _contentView.hidden = YES;
    
    
    // loader
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loader.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    loader.center = self.view.center;
    loader.hidden = YES;
    
    _loader = [loader retain];
    [self.view addSubview:_loader];
    [loader release];
    
    
    // gestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelegate:self];
    [_modalView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
}



/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // track
    [Tracker trackView:@"Information"];

}

/*
 * Enters the view.
 */
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	DLog();
    
}

/*
 * Leaves the view.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     FLog();

}


/*
 * Cleanup rotation.
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    FLog();
    
    // resize
    [self resize];
    
}



#pragma mark -
#pragma mark Business

/*
 * Loading.
 */
- (void)loading:(BOOL)loading {
    GLog();
    
    // mode
    mode_loading = loading;
    if (mode_loading) {
        
        // loader
        [_loader startAnimating];
        _loader.hidden = NO;
    }
    else {
        
        // unload
        [_loader stopAnimating];
        _loader.hidden = YES;
    }
}


/*
 * Resize.
 */
- (void)resize {
    FLog();
    
    // fullscreen
    if (fullscreen) {
        [self resizeFull];
    }
    
    // resize components
    [_componentListing resize];
    [_componentTMDb resize];
    [_componentIMDb resize];
    [_componentWikipedia resize];
    [_componentTrailer resize];
}

/*
 * Information movie.
 */
- (void)informationMovie:(Movie*)movie nodes:(NSArray *)nodes {
    FLog();
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
    }
    
    // type
    type_person = NO;
    type_movie = YES;
    
    // references
    [_referenceTMDb setString:[NSString stringWithFormat:@"%@%i",urlTMDbMovie,[movie.mid intValue]]];
    if (([movie.imdb length] > 0)) {
        [_referenceIMDb setString:[NSString stringWithFormat:@"%@%@",urlIMDbMovie,movie.imdb]];
    }
    else {
        [_referenceIMDb setString:[NSString stringWithFormat:@"%@%@",urlIMDbSearch,[movie.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    [_referenceWikipedia setString:[NSString stringWithFormat:@"%@%@",[_sloc urlWikipediaSearch],[movie.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceAmazon setString:[NSString stringWithFormat:@"%@%@",[_sloc urlAmazonSearch],[movie.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceITunes setString:[NSString stringWithFormat:@"%@%@",urlITunesSearch,[movie.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    // header
    [_informationMovieView reset:movie];
    _informationPersonView.hidden = YES;
    _informationMovieView.hidden = NO;
    

    // component listing
    [_componentListing reset:nodes];
    [_actionListing setTitle:NSLocalizedString(@"Cast", @"Cast")];
    
    // component tmdb
    [_componentTMDb resetMovie:movie];
    
    // component imdb
    [_componentIMDb reset:_referenceIMDb];
    
    // component wikipedia
    [_componentWikipedia reset:_referenceWikipedia];
    
    // component trailer
    [_componentTrailer resetTrailer:movie];
    _buttonTrailer.hidden = YES;
    if ([_componentTrailer.videos count] > 0) {
        _buttonTrailer.hidden = NO;
    }
    
    // favorite
    BOOL fav = [_solyarisDataManager solyarisDataFavorite:typeMovie dbid:movie.mid] ? YES : NO;
    [_favorite setObject:[NSNumber numberWithBool:fav] forKey:kFav];
    [_favorite setObject:typeMovie forKey:kFavType];
    [_favorite setObject:movie.mid forKey:kFavDBID];
    [_favorite setObject:movie.title forKey:kFavTitle];
    [_favorite setObject:movie.released ? [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:movie.released]] : @"-" forKey:kFavMeta];
    [_favorite setObject:_referenceTMDb forKey:kFavLink];
    
    [_buttonFavorite setSelected:fav];
    
    // share
    [_share setObject:movie.title forKey:kShareTitle];
    [_share setObject:movie.tagline forKey:kShareTagline];
    [_share setObject:movie.released ? [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:movie.released]] : @"-" forKey:kShareReleased];
    [_share setObject:movie.runtime ? [NSString stringWithFormat:@"%@m",movie.runtime] : @"-" forKey:kShareRuntime];
    [_share setObject:movie.overview && movie.description.length > 10 ? movie.overview : @"-" forKey:kShareOverview];
    [_share setObject:_referenceTMDb forKey:kShareLink];
    
    _buttonShare.hidden = NO;
    
    // thumb
    [_favorite setObject:@"" forKey:kFavThumb];
    [_share setObject:@"" forKey:kShareThumb];
    [_share setObject:@"" forKey:kShareImage];
    for (Asset *a in movie.assets) {
        if ([a.type isEqualToString:assetPoster] && [a.size isEqualToString:assetSizeThumb]) {
            [_favorite setObject:a.value forKey:kFavThumb];
            [_share setObject:a.value forKey:kShareThumb];
        }
        if ([a.type isEqualToString:assetPoster] && [a.size isEqualToString:assetSizeMid]) {
            [_share setObject:a.value forKey:kShareImage];
        }
    }
    
    // swap listing
    [self swapReset];
    [self swapListing];
    
}

/**
 * Information person.
 */
- (void)informationPerson:(Person*)person nodes:(NSArray *)nodes {
    FLog();
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    // type
    type_movie = NO;
    type_person = YES;
    
    // references
    [_referenceTMDb setString:[NSString stringWithFormat:@"%@%i",urlTMDbPerson,[person.pid intValue]]];
    [_referenceIMDb setString:[NSString stringWithFormat:@"%@%@",urlIMDbSearch,[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceWikipedia setString:[NSString stringWithFormat:@"%@%@",[_sloc urlWikipediaSearch],[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceAmazon setString:[NSString stringWithFormat:@"%@%@",[_sloc urlAmazonSearch],[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceITunes setString:[NSString stringWithFormat:@"%@%@",urlITunesSearch,[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    // header
    [_informationPersonView reset:person];
    _informationMovieView.hidden = YES;
    _informationPersonView.hidden = NO;
    
    // component listing
    [_componentListing reset:nodes];
    [_actionListing setTitle:NSLocalizedString(@"Movies", @"Movies")];
    
    // component tmdb
    [_componentTMDb resetPerson:person];
    
    // component imdb
    [_componentIMDb reset:_referenceIMDb];
    
    // component wikipedia
    [_componentWikipedia reset:_referenceWikipedia];
    
    // component trailer
    _buttonTrailer.hidden = YES;
    [_componentTrailer reset];
    
    // share
    _buttonShare.hidden = YES;
    
    // favorite
    BOOL fav = [_solyarisDataManager solyarisDataFavorite:typePerson dbid:person.pid] ? YES : NO;
    [_favorite setObject:[NSNumber numberWithBool:fav] forKey:kFav];
    [_favorite setObject:typePerson forKey:kFavType];
    [_favorite setObject:person.pid forKey:kFavDBID];
    [_favorite setObject:person.name forKey:kFavTitle];
    [_favorite setObject:person.birthday ? [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:person.birthday]] : @"-" forKey:kFavMeta];
    [_favorite setObject:_referenceTMDb forKey:kFavLink];
    
    [_buttonFavorite setSelected:fav];
    
    // thumb
    [_favorite setObject:@"" forKey:kFavThumb];
    for (Asset *a in person.assets) {
        if ([a.type isEqualToString:assetProfile] && [a.size isEqualToString:assetSizeThumb]) {
            [_favorite setObject:a.value forKey:kFavThumb];
            break;
        }
    }
    
    // swap listing
    [self swapReset];
    [self swapListing];
    
}



#pragma mark -
#pragma mark Swap

/*
 * Swap listing.
 */
- (void)swapListing {
    FLog();
    
    // change mode
    if (! mode_listing) {
        
        // track
        [Tracker trackView:@"InformationListing"];
        
        // reset
        [self swapReset];
        
        // mode
        mode_listing = YES;
        
        // action
        [_actionListing setSelected:YES];
        
        // component
        [_componentListing load];
        [_componentListing setHidden:NO];
        [_componentListing scrollTop:NO];
    }

}

/*
 * Swap TMDb.
 */
- (void)swapTMDb {
    FLog();
    
    // change mode
    if (! mode_tmdb) {
        
        // track
        [Tracker trackView:@"InformationTMDb"];
        
        // reset
        [self swapReset];
        
        // mode
        mode_tmdb = YES;
        
        // action
        [_actionTMDb setSelected:YES];
        
        // component
        [_componentTMDb load];
        [_componentTMDb setHidden:NO];
        [_componentTMDb scrollTop:NO];
    }
}

/*
 * Swap IMDb.
 */
- (void)swapIMDb {
    FLog();
    
    // change mode
    if (! mode_imdb) {
        
        // track
        [Tracker trackView:@"InformationIMDb"];
        
        // reset
        [self swapReset];
        
        // mode
        mode_imdb = YES;
        
        // action
        [_actionIMDb setSelected:YES];
        
        // component
        [_componentIMDb load];
        [_componentIMDb scrollTop:NO];
        [_componentIMDb setHidden:NO];
        [_htmlNavigator setHidden:NO];
        
    }
}

/*
 * Swap Wikipedia.
 */
- (void)swapWikipedia {
    FLog();
    
    // change mode
    if (! mode_wikipedia) {
        
        // track
        [Tracker trackView:@"InformationWikipedia"];
        
        // reset
        [self swapReset];
        
        // mode
        mode_wikipedia = YES;
        
        // action
        [_actionWikipedia setSelected:YES];
        
        // component
        [_componentWikipedia load];
        [_componentWikipedia scrollTop:NO];
        [_componentWikipedia setHidden:NO];
        [_htmlNavigator setHidden:NO];
        
    }
}


/*
 * Swap Trailer.
 */
- (void)swapTrailer:(int)vndx {
    FLog();
    
    // track
    [Tracker trackView:@"InformationTrailer"];
    
    // reset
    [self swapReset];
    
    // mode
    mode_trailer = YES;
    
    // button
    [_buttonTrailer setSelected:YES];
    
    // component
    [_componentTrailer unload];
    [_componentTrailer load:vndx];
    [_componentTrailer scrollTop:NO];
    [_componentTrailer setHidden:NO];
}


/*
 * Swap reset.
 */
- (void)swapReset {
    FLog();
    
    // reset mode
    mode_listing = NO;
    mode_tmdb = NO;
    mode_imdb = NO;
    mode_wikipedia = NO;
    mode_trailer = NO;
    
    // actions
    [_actionListing setSelected:NO];
    [_actionTMDb setSelected:NO];
    [_actionIMDb setSelected:NO];
    [_actionWikipedia setSelected:NO];
    
    // button
    [_buttonTrailer setSelected:NO];
    
    // hide views
    _componentListing.hidden = YES;
    _componentTMDb.hidden = YES;
    _componentIMDb.hidden = YES;
    _componentWikipedia.hidden = YES;
    _componentTrailer.hidden = YES;
    [_componentTrailer unload];
    _htmlNavigator.hidden = YES;
    
}


#pragma mark -
#pragma mark Listing Delegate

/*
 * Selected.
 */
- (void)listingSelected:(NSNumber *)nid type:(NSString *)type {
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(informationSelected:type:)]) {
        [delegate informationSelected:nid type:type];
    }
}



#pragma mark -
#pragma mark HTML Delegate

/*
 * Navigator.
 */
- (void)navigateBack {
    
    // imdb
    if (mode_imdb) {
        [_componentIMDb navigateBack];
    }
    
    // imdb
    if (mode_wikipedia) {
        [_componentWikipedia navigateBack];
    }
}
- (void)navigateForward {
    
    // imdb
    if (mode_imdb) {
        [_componentIMDb navigateForward];
    }
    
    // imdb
    if (mode_wikipedia) {
        [_componentWikipedia navigateForward];
    }
}


#pragma mark -
#pragma mark Actions

/*
 * Resize.
 */
- (void)actionResize:(id)sender {
    FLog();
    
    // toggle
    if (fullscreen) {
        // resize
        [self resizeDefault];
    }
    else {
        // resize
        [self resizeFull];
    }
    fullscreen = ! fullscreen;

}
- (void)resizeFull {
    DLog();
    
    // layout
    BOOL landscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // frame
    CGRect fSelf = screen;
    if (landscape) {
        fSelf.size.width = screen.size.height;
        fSelf.size.height = screen.size.width;
    }

    
    // animate
	[UIView beginAnimations:@"resize_full" context:nil];
    [UIView setAnimationDuration:kAnimateTimeResizeFull];
	_contentView.frame = fSelf;
	[UIView commitAnimations];
    
    // button
    [_buttonResize setImage:[UIImage imageNamed:@"btn_resize-default.png"] forState:UIControlStateNormal];
    
    // resize done
	[self performSelector:@selector(resizeDone) withObject:nil afterDelay:kAnimateTimeResizeFull];
    
}
- (void)resizeDefault {
    GLog();
    
    // layout
    BOOL landscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // frame
    CGRect fSelf = screen;
    if (landscape) {
        fSelf.size.width = screen.size.height;
        fSelf.size.height = screen.size.width;
    }
    
    // frame
    CGRect fSmall = CGRectMake(fSelf.size.width/2.0-vframe.size.width/2.0, fSelf.size.height/2.0-vframe.size.height/2.0, vframe.size.width, vframe.size.height);
    
    // animate
	[UIView beginAnimations:@"resize_default" context:nil];
    [UIView setAnimationDuration:kAnimateTimeResizeDefault];
	_contentView.frame = fSmall;
	[UIView commitAnimations];
    
    // button
    [_buttonResize setImage:[UIImage imageNamed:@"btn_resize-full.png"] forState:UIControlStateNormal];
    
    // resize done
	[self performSelector:@selector(resizeDone) withObject:nil afterDelay:kAnimateTimeResizeDefault];
}

- (void)resizeDone {
    
    // resize components
    [_componentListing resize];
    [_componentTMDb resize];
    [_componentIMDb resize];
    [_componentWikipedia resize];
    [_componentTrailer resize];
}

/*
 * Action close.
 */
- (void)actionClose:(id)sender {
    DLog();
    
    // dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(informationDismiss)]) {
        
        // reset
        [self performSelector:@selector(swapReset) withObject:nil afterDelay:0.6];
        
        // dismiss
		[delegate informationDismiss];
	}
}

/*
 * Action favorite.
 */
- (void)actionFavorite:(id)sender {
    DLog();
    
    // favorite
    if (! [[_favorite objectForKey:kFav] boolValue]) {
        
        // track
        [Tracker trackEvent:TEventInfo action:@"Favorite" label:@"add"];
        
        // data
        [_solyarisDataManager managerFavoriteAdd:_favorite];
        
        // favorite
        [_favorite setObject:[NSNumber numberWithBool:YES] forKey:kFav];
        
        // toggle
        [_buttonFavorite setSelected:YES];
    }
    // defav
    else {
        
        // track
        [Tracker trackEvent:TEventInfo action:@"Favorite" label:@"remove"];
        
        // data
        [_solyarisDataManager managerFavoriteRemove:_favorite];
        
        // favorite
        [_favorite setObject:[NSNumber numberWithBool:NO] forKey:kFav];
        
        // toggle
        [_buttonFavorite setSelected:NO];
    }
    
}

/*
 * Action share.
 */
- (void)actionShare:(id)sender {
    DLog();
    
    // action sheet
    UIActionSheet *shareAction = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"Share",@"Share")
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    
    // actions
    [shareAction addButtonWithTitle:NSLocalizedString(@"Email", @"Email")];
    [shareAction addButtonWithTitle:NSLocalizedString(@"Twitter", @"Twitter")];
    if (NSClassFromString(@"SLComposeViewController") != nil && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        [shareAction addButtonWithTitle:NSLocalizedString(@"Facebook", @"Facebook")];
    }
    [shareAction addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
    shareAction.cancelButtonIndex = shareAction.numberOfButtons-1;

    // show
    [shareAction setTag:ActionInformationShare];
    [shareAction showFromRect:_buttonShare.frame inView:self.contentView animated:YES];
    [shareAction release];
}


/*
 * Action trailer.
 */
- (void)actionTrailer:(id)sender {
	DLog();
    
    // single
    if ([_componentTrailer.videos count] == 1) {
        
        // swap
        [self swapTrailer:0];
    }
    // select
    else {
        
        // on the trail
        UIActionSheet *trailerActions = [[UIActionSheet alloc]
                                         initWithTitle:nil
                                         delegate:self
                                         cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        
        // videos
        for (Video *v in _componentTrailer.videos) {
            [trailerActions addButtonWithTitle:v.title];
        }
        [trailerActions addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        trailerActions.cancelButtonIndex = [_componentTrailer.videos count];
        
        // show
        [trailerActions setTag:ActionInformationTrailers];
        [trailerActions showFromRect:_buttonTrailer.frame inView:self.contentView animated:YES];
        [trailerActions release];
    }

}


/*
 * Tools reference.
 */
- (void)actionToolsReference:(id)sender {
    FLog();
    
    // last action hero
    UIActionSheet *referenceActions = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Open on TMDb",@"Open on TMDb"),NSLocalizedString(@"Open on IMDb",@"Open on IMDb"),NSLocalizedString(@"Open on Wikipedia",@"Open on Wikipedia"),NSLocalizedString(@"Find on Amazon",@"Find on Amazon"),NSLocalizedString(@"Find on iTunes",@"Find on iTunes"),nil];
    
    // show
    [referenceActions setTag:ActionInformationToolsReference];
    [referenceActions showFromRect:CGRectMake(_contentView.frame.origin.x + _contentView.frame.size.width-kInformationGapInset-32, _contentView.frame.origin.y + _contentView.frame.size.height-kInformationGapOffset-(kInformationFooterHeight/2.0), 32, 32) inView:self.view animated:YES];
    [referenceActions release];
    
}



#pragma mark -
#pragma mark Gestures

/*
 * Gesture tap.
 */
- (void)gestureTap:(UITapGestureRecognizer *)recognizer {
    FLog();
    
    // dismiss
	if (!mode_loading && delegate != nil && [delegate respondsToSelector:@selector(informationDismiss)]) {
        
        // reset
        [self performSelector:@selector(swapReset) withObject:nil afterDelay:0.6];
        
        // dismiss
		[delegate informationDismiss];
	}
    
}


#pragma mark -
#pragma mark Share

/*
 * Share email.
 */
- (void)shareEmail {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Share" label:@"Email"];
    
    // email
    if ([MailComposeController canSendMail]) {
        
        // movie
        NSString *movie_title = [_share objectForKey:kShareTitle];
        NSString *movie_tagline = [_share objectForKey:kShareTagline];
        NSString *movie_released = [_share objectForKey:kShareReleased];
        NSString *movie_runtime = [_share objectForKey:kShareRuntime];
        NSString *movie_overview = [_share objectForKey:kShareOverview];
        NSString *movie_thumb = [_share objectForKey:kShareThumb];
        NSString *movie_link = [_share objectForKey:kShareLink];
        
        // image
        NSData *movie_image = nil;
        if (movie_thumb.length > 0) {
            NSError *error = nil;
            NSHTTPURLResponse *response;
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:movie_thumb] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (! error && response != nil && [response statusCode] == 200 && data != nil) {
               movie_image = UIImagePNGRepresentation([UIImage imageWithData:data]);
            }
        }
        
        // html
        NSString *html = [NSString stringWithFormat:
        @"<div style='max-width:480px;'>"
        "<table border='0' cellpadding='0' cellspacing='0' style='font-family:Helvetica, Arial, sans-serif; color:#4C4C4C; font-size:14px; line-height:18px; margin:0px; padding:0px;'>"
        "<tbody>"
        "<tr><td style='width:%ipx'>$THUMB$</td><td valign='top'>$INFO$</td></tr>"
        "<tr><td colspan='2' style='padding:10px 0 0 0;'>$OVERVIEW$</td></tr>"
        "</tbody>"
        "<tfoot>"
        "<tr><td colspan='2' style='padding:25px 0 0 0;'>$FOOTER$</td></tr>"
        "</tfoot>"
        "</table>"
        "</div>",movie_image ? 105 : 0];
        
        // info
        NSString *html_info = [NSString stringWithFormat:@"<h1 style='font-size:18px; line-height:18px; margin:0 0 3px 0; padding:12px 0 0 0;'><a href='%@' style='color:#4C4C4C; text-decoration:none;'>%@</a></h1><h2 style='font-size:14px; line-height:18px; font-weight:normal; margin:0 0 9px 0; padding:0;'>%@</h2><p style='padding:0; margin:0;'><span style='display:inline-block; width:80px;'>%@</span>%@<br/><span style='display:inline-block; width:80px;'>%@</span>%@</p>", movie_link, movie_title, movie_tagline, NSLocalizedString(@"Year:", @"Year:"), movie_released, NSLocalizedString(@"Runtime:", @"Runtime:"), movie_runtime];
        html = [html stringByReplacingOccurrencesOfString:@"$INFO$" withString:html_info];
        
        // thumb
        NSString *html_thumb = movie_image ? [NSString stringWithFormat:@"<img src='data:image/png;base64,%@' width='92' height='auto' style='display:block; margin:0 5px 0 0;'/>",[movie_image base64EncodingWithLineLength:0]] : @"";
        html = [html stringByReplacingOccurrencesOfString:@"$THUMB$" withString:html_thumb];
        
        // overview
        html = [html stringByReplacingOccurrencesOfString:@"$OVERVIEW$" withString:movie_overview];
        
        // footer
        NSData *icon = UIImagePNGRepresentation([UIImage imageNamed:@"app_icon.png"]);
        NSString *html_footer = [NSString stringWithFormat:@"<p style='padding:0; margin:0;'><a href='%@' style='color:#4C4C4C; text-decoration:none'><img src='data:image/png;base64,%@' width='45' height='45' style='display:block; float:left; margin:0 8px 0 0;'/><div style='padding:5px 0 0 0;'><span style='font-weight:bold'>%@</span><br/><span>%@</span></div></a></p>",vAppSite,[icon base64EncodingWithLineLength:0],NSLocalizedString(@"Solyaris", @"Solyaris"),NSLocalizedString(@"Visual Movie Browser", @"Visual Movie Browser")];
        html = [html stringByReplacingOccurrencesOfString:@"$FOOTER$" withString:html_footer];
        
        
        // mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        
        // ipad
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            composer.modalPresentationStyle = UIModalPresentationFormSheet;
            composer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        }
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[%@] %@",NSLocalizedString(@"Solyaris", @"Solyaris"), movie_title]];
        
		// message
		[composer setMessageBody:html isHTML:YES];
        
		// present
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composer animated:YES completion:nil];
        
		// release
		[composer release];
    }
}

/*
 * Share twitter.
 */
- (void)shareTwitter {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Share" label:@"Twitter"];
    
    // check twitter support
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        // movie
        NSString *movie_title = [_share objectForKey:kShareTitle];
        NSString *movie_released = [_share objectForKey:kShareReleased];
        movie_released = (movie_released && movie_released.length > 1) ? [NSString stringWithFormat:@" (%@)",movie_released] : @"";
        NSString *movie_img = [_share objectForKey:kShareImage];
        NSString *movie_link = [_share objectForKey:kShareLink];
        
        // composition view controller
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        // initial text
        [composeViewController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"Just found the movie %@%@. \n%@",@"Just found the movie %@. \n%@"),movie_title,movie_released,movie_link]];
        
        // initial image
        if (movie_img.length > 0) {
            NSError *error = nil;
            NSHTTPURLResponse *response;
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:movie_img] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (! error && response != nil && [response statusCode] == 200 && data != nil) {
                [composeViewController addImage:[UIImage imageWithData:data]];
            }
        }
        
        
        // completion handler
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            // dismiss the composition view controller
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
            
            // result
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    FLog("SLCompose: cancel");
                    break;
                case SLComposeViewControllerResultDone:
                    FLog("SLCompose: done");
                    break;
                default:
                    break;
            }
            
        };
        [composeViewController setCompletionHandler:completionHandler];
        
        // modal
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composeViewController animated:YES completion:nil];
    }
   
}

/*
 * Share facebook.
 */
- (void)shareFacebook {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Share" label:@"Facebook"];
    
    // check facebook support
    if (NSClassFromString(@"SLComposeViewController") != nil && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        // movie
        NSString *movie_title = [_share objectForKey:kShareTitle];
        NSString *movie_released = [_share objectForKey:kShareReleased];
        movie_released = (movie_released && movie_released.length > 1) ? [NSString stringWithFormat:@" (%@)",movie_released] : @"";
        NSString *movie_img = [_share objectForKey:kShareImage];
        NSString *movie_link = [_share objectForKey:kShareLink];
        
        // composition view controller
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // initial text
        [composeViewController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"Just found the movie %@%@. \n%@",@"Just found the movie %@. \n%@"),movie_title,movie_released,movie_link]];
        
        // initial image
        if (movie_img.length > 0) {
            NSError *error = nil;
            NSHTTPURLResponse *response;
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:movie_img] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (! error && response != nil && [response statusCode] == 200 && data != nil) {
                [composeViewController addImage:[UIImage imageWithData:data]];
            }
        }
        
        // completion handler
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            // result
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    FLog("SLCompose: cancel");
                    break;
                case SLComposeViewControllerResultDone:
                    FLog("SLCompose: done");
                    break;
                default:
                    break;
            }
            
            // dismiss the composition view controller
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
            
        };
        [composeViewController setCompletionHandler:completionHandler];
        
        // modal
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composeViewController animated:YES completion:nil];
    }
}



#pragma mark -
#pragma mark Reference

/*
 * Reference TMDb.
 */
- (void)referenceTMDb {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Reference" label:@"TMDb"];
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceTMDb]];
}

/*
 * Reference IMDb.
 */
- (void)referenceIMDb {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Reference" label:@"IMDb"];
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceIMDb]];
}

/*
 * Reference Wikipedia.
 */
- (void)referenceWikipedia {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Reference" label:@"Wikipedia"];
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceWikipedia]];
}

/*
 * Reference amazon.
 */
- (void)referenceAmazon {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Reference" label:@"Amazon"];

    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceAmazon]];
}

/*
 * Reference iTunes.
 */
- (void)referenceITunes {
    FLog();
    
    // track
    [Tracker trackEvent:TEventInfo action:@"Reference" label:@"iTunes"];
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceITunes]];
}


#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // share
        case ActionInformationShare: {
            
            // cancel
            if (buttonIndex == actionSheet.cancelButtonIndex) {
                return;
            }
            
            // type
            switch (buttonIndex) {
                    
                // email
                case 0:
                    [self shareEmail];
                    break;
                    
                // twitter
                case 1:
                    [self shareTwitter];
                    break;
                    
                // facebook
                case 2:
                    [self shareFacebook];
                    break;
                    
                // nothing
                default:
                    break;
            }

            
            // br
            break;
        }
            
        // trailers
		case ActionInformationTrailers: {
            
            // trailer
            if (buttonIndex < [_componentTrailer.videos count]) {
                
                // switch
                [self swapTrailer:buttonIndex];
            }
            
            // twix
			break;
		}
            
        // reference
		case ActionInformationToolsReference: {
            
            // type
            switch (buttonIndex) {
                    
                // TMDb
                case 0:
                    [self referenceTMDb];
                    break;
                    
                // IMDb
                case 1:
                    [self referenceIMDb];
                    break;
                    
                // Wikipedia
                case 2:
                    [self referenceWikipedia];
                    break;
                    
                // Amazon
                case 3:
                    [self referenceWikipedia];
                    break;
                    
                // iTunes
                case 4:
                    [self referenceITunes];
                    break;
                    
                // nothing
                default:
                    break;
            }
            
            // kit kat time
			break;
		}
            
            
        // default
		default: {
			break;
		}
	}
	
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Protocol

/*
 * Dismisses the email composition interface.
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	FLog();
	
	// result
	switch (result) {
		case MFMailComposeResultCancelled:
			FLog("Email: canceled");
			break;
		case MFMailComposeResultSaved:
			FLog("Email: saved");
			break;
		case MFMailComposeResultSent:
			FLog("Email: sent");
			break;
		case MFMailComposeResultFailed:
			FLog("Email: failed");
			break;
		default:
			FLog("Email: not sent");
			break;
	}
	
	// close modal
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark -
#pragma mark Memory management

/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	FLog();
    
    // data
    [_solyarisDataManager release];
    
    // ui
    [_modalView release];
    [_contentView release];

    // actions
    [_actionListing release];
    [_actionTMDb release];
    [_actionIMDb release];
    [_actionWikipedia release];
    
    // buttons
    [_buttonResize release];
    [_buttonClose release];
    [_buttonFavorite release];
    [_buttonTrailer release];
    [_buttonShare release];
    
    // components
    [_componentListing release];
    [_componentTMDb release];
    [_componentIMDb release];
    [_componentWikipedia release];
    [_componentTrailer release];
    
    // loader
    [_loader release];
    
    // localization
    [_sloc release];
    
    // reference
    [_referenceTMDb release]; 
    [_referenceIMDb release]; 
    [_referenceWikipedia release]; 
    [_referenceAmazon release]; 
    [_referenceITunes release];
    
    // favorite
    [_favorite release];
    
    // share
    [_share release];
	
	// duper
    [super dealloc];
}


@end




#pragma mark -
#pragma mark InformationBackgroundView
#pragma mark -

/**
 * InformationBackgroundView.
 */
@implementation InformationBackgroundView


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
	
	// super
    if ((self = [super initWithFrame:frame])) {
		
		// init
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = iPad ? (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin) : (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        self.contentMode = UIViewContentModeRedraw; // Thats the one
        
        // texture
        UIImage *texture = [UIImage imageNamed:@"bg_content.png"];
        _texture = [texture retain];
        _tsize.size = _texture.size;

	}
	
	// self
	return self;
}


/*
 * Draw that thing.
 */
- (void)drawRect:(CGRect)rect {
    GLog();
    
	// vars
	float w = self.frame.size.width;
	float h = self.frame.size.height;
    
    // rects
    CGRect mrect = CGRectMake(0, 0, w, h);
    
    
	// context
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
    CGContextSetShouldAntialias(context, NO);
    
	
	// background
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:239.0/255.0 alpha:1.0].CGColor);
	CGContextFillRect(context, mrect);
    
    // texture
    CGContextClipToRect(context, mrect);
    CGContextDrawTiledImage(context,_tsize,_texture.CGImage);
	
    
	// header lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kInformationHeaderHeight-1);
	CGContextAddLineToPoint(context, w, kInformationHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kInformationHeaderHeight);
	CGContextAddLineToPoint(context, w, kInformationHeaderHeight);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-kInformationFooterHeight);
	CGContextAddLineToPoint(context, w, h-kInformationFooterHeight);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-kInformationFooterHeight+1);
	CGContextAddLineToPoint(context, w, h-kInformationFooterHeight+1);
	CGContextStrokePath(context);
     
}


#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    FLog();
    
    // whats the point
    CGPoint tPoint = [[touches anyObject] locationInView:self];
    
    // header
    if (tPoint.y < kInformationHeaderHeight) {
        
        // listing
        ListingView *cListing = (ListingView*) [self viewWithTag:TagInformationComponentListing];
        [cListing scrollTop:YES];
        
        // tmdb
        TMDbView *cTMDb = (TMDbView*) [self viewWithTag:TagInformationComponentTMDb];
        [cTMDb scrollTop:YES];
        
        // imdb
        HTMLView *cIMDb = (HTMLView*) [self viewWithTag:TagInformationComponentIMDb];
        [cIMDb scrollTop:YES];
        
        // wikipedia
        HTMLView *cWikipedia = (HTMLView*) [self viewWithTag:TagInformationComponentWikipedia];
        [cWikipedia scrollTop:YES];
    }
}

/*
 * Touches.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
    
    // self
    [_texture release];
	
	// release 
    [super dealloc];
}


@end




#pragma mark -
#pragma mark InformationMovieView
#pragma mark -

/**
 * InformationMovieView.
 */
@implementation InformationMovieView



#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // self
    if ((self = [super initWithFrame:frame])) {
        
        // view
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        
        // vars
        float gapInset = iPad ? 15 : 10;
        float gapOffset = 10;
        float roff = iPad ? 0 : -5;
        
        // frames
        CGRect iframe = iPad ? CGRectMake(gapInset, gapOffset, 60, 90) : CGRectMake(gapInset, gapOffset, 40, 60);
        CGRect mframe = CGRectMake(2*gapInset+iframe.size.width+roff, gapOffset+2*roff, frame.size.width-(2*gapInset+iframe.size.height), frame.size.height-2*gapInset);
        
        // poster
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:iframe];
        ciView.autoresizingMask = UIViewAutoresizingNone;
        [ciView placeholderImage:iPad ? [UIImage imageNamed:@"placeholder_info_movie.png"] : [UIImage imageNamed:@"placeholder_info_movie_redux.png"]];
        
        _imagePoster = [ciView retain];
        [self addSubview:_imagePoster];
        [ciView release];
        
        // title
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y, mframe.size.width, iPad ? 36 : 34)];
        lblTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:iPad ? 21.0 : 15];
        lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblTitle.shadowOffset = CGSizeMake(0,1);
        lblTitle.opaque = YES;
        lblTitle.numberOfLines = 1;
        
        _labelTitle = [lblTitle retain];
        [self addSubview:_labelTitle];
        [lblTitle release];
        
        // tagline
        UILabel *lblTagline = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+(iPad ? 30 : 23), mframe.size.width, 18)];
        lblTagline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lblTagline.backgroundColor = [UIColor clearColor];
        lblTagline.font = [UIFont fontWithName:@"Helvetica" size:iPad ? 15.0 : 12];
        lblTagline.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblTagline.opaque = YES;
        lblTagline.numberOfLines = 1;
        
        _labelTagline = [lblTagline retain];
        [self addSubview:_labelTagline];
        [lblTagline release];
        
        // property
        float pwidth = 75;
        
        
        // released
        UILabel *lblPropReleased = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+(iPad ? 54 : 42), pwidth, 15)];
        lblPropReleased.backgroundColor = [UIColor clearColor];
        lblPropReleased.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropReleased.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropReleased.opaque = YES;
        lblPropReleased.numberOfLines = 1;
        [lblPropReleased setText:NSLocalizedString(@"Year:", @"Year:")];
        
        [self addSubview:lblPropReleased];
        [lblPropReleased release];
        
        UILabel *lblReleased = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+(iPad ? 54 : 42), mframe.size.width-pwidth, 15)];
        lblReleased.backgroundColor = [UIColor clearColor];
        lblReleased.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblReleased.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblReleased.opaque = YES;
        lblReleased.numberOfLines = 1;
        
        _labelReleased = [lblReleased retain];
        [self addSubview:_labelReleased];
        [lblReleased release];
        
        
        // runtime
        UILabel *lblPropRuntime = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+(iPad ? 69 : 57), pwidth, 15)];
        lblPropRuntime.backgroundColor = [UIColor clearColor];
        lblPropRuntime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropRuntime.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropRuntime.opaque = YES;
        lblPropRuntime.numberOfLines = 1;
        [lblPropRuntime setText:NSLocalizedString(@"Runtime:", @"Runtime:")];
        
        [self addSubview:lblPropRuntime];
        [lblPropRuntime release];
        
        UILabel *lblRuntime = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+(iPad ? 69 : 57), mframe.size.width-pwidth, 15)];
        lblRuntime.backgroundColor = [UIColor clearColor];
        lblRuntime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblRuntime.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblRuntime.opaque = YES;
        lblRuntime.numberOfLines = 1;
        
        _labelRuntime = [lblRuntime retain];
        [self addSubview:_labelRuntime];
        [lblRuntime release];
        
        
        
    }
    return self;
}


#pragma mark -
#pragma mark Interface

/**
 * Reset.
 */
- (void)reset:(Movie *)movie {
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
    }
    
    // poset
    NSString *poster = @"";
    NSString *posterSize = [NSString stringWithFormat:@"%@",((iPad && [Utils isRetina]) ? assetSizeMid : assetSizeThumb)];
    for (Asset *a in movie.assets) {
        
        // poster
        if ([a.type isEqualToString:assetPoster] && [a.size isEqualToString:posterSize]) { 
            poster = a.value;
            break;
        }
    }
    
    
    // header
    [_imagePoster loadImage:poster];
    [_labelTitle setText:movie.title];
    [_labelTagline setText:movie.tagline];
    [_labelReleased setText:(movie.released) ? [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:movie.released]] : @"-"];
    [_labelRuntime setText:([movie.runtime intValue] > 0) ? [NSString stringWithFormat:@"%im",[movie.runtime intValue]] : @"-"];
    
}




#pragma mark -
#pragma mark Memory

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    GLog();
    
    // release
    [_labelTitle release];
    [_labelTagline release];
    [_labelRuntime release];
    [_labelReleased release];
    [_imagePoster release];
    
    // sup
    [super dealloc];
}



@end




#pragma mark -
#pragma mark InformationPersonView
#pragma mark -

/**
 * InformationPersonView.
 */
@implementation InformationPersonView



#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // self
    if ((self = [super initWithFrame:frame])) {
        
        // view
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        
        // vars
        float gapInset = iPad ? 15 : 10;
        float gapOffset = 10;
        float roff = iPad ? 0 : -5;
        
        // frames
        CGRect iframe = iPad ? CGRectMake(gapInset, gapOffset, 60, 90) : CGRectMake(gapInset, gapOffset, 40, 60);
        CGRect mframe = CGRectMake(2*gapInset+iframe.size.width+roff, gapOffset+2*roff, frame.size.width-(2*gapInset+iframe.size.height), frame.size.height-2*gapInset);
        
        // poster
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:iframe];
        ciView.autoresizingMask = UIViewAutoresizingNone;
        [ciView placeholderImage:iPad ? [UIImage imageNamed:@"placeholder_info_person.png"] : [UIImage imageNamed:@"placeholder_info_person_redux.png"]];
        
        _imageProfile = [ciView retain];
        [self addSubview:_imageProfile];
        [ciView release];
        
        // name
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y, mframe.size.width, iPad ? 36 : 34)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont fontWithName:@"Helvetica-Bold" size:iPad ? 21.0 : 15];
        lblName.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblName.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblName.shadowOffset = CGSizeMake(0,1);
        lblName.opaque = YES;
        lblName.numberOfLines = 1;
        
        _labelName = [lblName retain];
        [self addSubview:_labelName];
        [lblName release];
        
        // property
        float pwidth = 75;
        
        
        // known movies
        UILabel *lblPropKnownMovies = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+(iPad ? 39 : 28), pwidth, 15)];
        lblPropKnownMovies.backgroundColor = [UIColor clearColor];
        lblPropKnownMovies.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropKnownMovies.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropKnownMovies.opaque = YES;
        lblPropKnownMovies.numberOfLines = 1;
        [lblPropKnownMovies setText:NSLocalizedString(@"Movies:", @"Movies:")];
        
        [self addSubview:lblPropKnownMovies];
        [lblPropKnownMovies release];
        
        UILabel *lblKnownMovies = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+(iPad ? 39 : 28), mframe.size.width-pwidth, 15)];
        lblKnownMovies.backgroundColor = [UIColor clearColor];
        lblKnownMovies.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblKnownMovies.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblKnownMovies.opaque = YES;
        lblKnownMovies.numberOfLines = 1;
        
        _labelKnownMovies = [lblKnownMovies retain];
        [self addSubview:_labelKnownMovies];
        [lblKnownMovies release];
        
        
        // birthplace
        UILabel *lblPropBirthday = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+(iPad ? 54 : 43), pwidth, 15)];
        lblPropBirthday.backgroundColor = [UIColor clearColor];
        lblPropBirthday.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropBirthday.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropBirthday.opaque = YES;
        lblPropBirthday.numberOfLines = 1;
        [lblPropBirthday setText:NSLocalizedString(@"Birthday:", @"Birthday:")];
        
        [self addSubview:lblPropBirthday];
        [lblPropBirthday release];
        
        UILabel *lblBirthday = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+(iPad ? 54 : 43), mframe.size.width-pwidth, 15)];
        lblBirthday.backgroundColor = [UIColor clearColor];
        lblBirthday.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblBirthday.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblBirthday.opaque = YES;
        lblBirthday.numberOfLines = 1;
        
        _labelBirthday = [lblBirthday retain];
        [self addSubview:_labelBirthday];
        [lblBirthday release];
        
        // birthplace
        UILabel *lblPropBirthplace = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+(iPad ? 69 : 58), pwidth, 15)];
        lblPropBirthplace.backgroundColor = [UIColor clearColor];
        lblPropBirthplace.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropBirthplace.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropBirthplace.opaque = YES;
        lblPropBirthplace.numberOfLines = 1;
        [lblPropBirthplace setText:NSLocalizedString(@"Birthplace:", @"Birthplace:")];
        
        [self addSubview:lblPropBirthplace];
        [lblPropBirthplace release];
        
        UILabel *lblBirthplace = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+(iPad ? 69 : 58), mframe.size.width-pwidth, 15)];
        lblBirthplace.backgroundColor = [UIColor clearColor];
        lblBirthplace.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblBirthplace.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblBirthplace.opaque = YES;
        lblBirthplace.numberOfLines = 1;
        
        _labelBirthplace = [lblBirthplace retain];
        [self addSubview:_labelBirthplace];
        [lblBirthplace release];
        
        
    }
    return self;
}




#pragma mark -
#pragma mark Interface

/**
 * Reset.
 */
- (void)reset:(Person *)person {
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    
    // profile
    NSString *profile = @"";
    for (Asset *a in person.assets) {
        
        // profile
        if ([a.type isEqualToString:assetProfile] && [a.size isEqualToString:assetSizeMid]) {
            profile = a.value;
            break;
        }
    }
    
    
    // header
    [_imageProfile loadImage:profile];
    [_labelName setText:person.name];
    [_labelBirthday setText:person.birthday ? (person.deathday ? [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:person.birthday],[dateFormatter stringFromDate:person.deathday]] : [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:person.birthday]]) : @"-" ];
    [_labelBirthplace setText: (person.birthplace && ! [person.birthplace isEqualToString:@""]) ? person.birthplace : @"-"];
    [_labelKnownMovies setText:([person.casts intValue] > 0) ? [NSString stringWithFormat:@"%i",[person.casts intValue]]: @"-"];
    
}


#pragma mark -
#pragma mark Memory

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    GLog();
    
    // ui
    [_imageProfile release];
    [_labelName release];
    [_labelBirthday release];
    [_labelBirthplace release];
    [_labelKnownMovies release];
    
    // sup
    [super dealloc];
}


@end
