//
//  SearchViewController.m
//  Solyaris
//
//  Created by Beat Raess on 25.4.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
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

#import "SearchViewController.h"
#import "SolyarisConstants.h"
#import "Tracker.h"

/*
 * Formatter Stack.
 */
@interface SearchViewController (Formatters)
- (void)formatTerm;
@end


/**
 * Animation Stack.
 */
@interface SearchViewController (Animations)
- (void)animationFooterShow;
- (void)animationFooterShowDone;
- (void)animationFooterHide;
- (void)animationFooterHideDone;
@end


/**
 * Notification Stack.
 */
@interface SearchViewController (Notifications)
- (void)notificationSearchTerm:(NSNotification*)notification;
- (void)notificationSearchType:(NSNotification*)notification;
@end

/**
 * Gesture Stack.
 */
@interface SearchViewController (GestureStack)
- (void)gestureTap:(UITapGestureRecognizer *)recognizer;
@end



/**
 * SearchViewController.
 */
@implementation SearchViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeSearchFooterShow     0.21f
#define kAnimateTimeSearchFooterHide     0.15f



#pragma mark -
#pragma mark Properties

// synthesize
@synthesize delegate;
@synthesize dta;
@synthesize exp;
@synthesize modalView = _modalView;
@synthesize contentView = _contentView;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
        
        // vars
        NSMutableString *strTerm = [[NSMutableString alloc] init];
        _term = [strTerm retain];
        [strTerm release];
        
        // notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationSearchTerm:)
                                                     name:ntSearchTerm
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationSearchType:)
                                                     name:ntSearchType
                                                   object:nil];
        
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
    
    // view
    UIView *sview = [[UIView alloc] initWithFrame:CGRectZero];
    self.view = sview;
    [sview release];

    // modal
    UIView *modalView = [[UIView alloc] initWithFrame:CGRectZero];
    modalView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    modalView.backgroundColor = [UIColor blackColor];
    modalView.opaque = NO;
    modalView.alpha = 0.1;
    _modalView = [modalView retain];
    [self.view addSubview:_modalView];
    [modalView release];
    
    // content view
    UIView *contentView = [[SearchView alloc] initWithFrame:CGRectZero type:iPad ? SearchViewFooter : SearchViewDefault];
    _contentView = [contentView retain];
    [self.view addSubview:_contentView];
    [contentView release];
    
    // layer
    CAGradientLayer *dropShadow = [[CAGradientLayer alloc] init];
    dropShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.09].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.03].CGColor,(id)[UIColor colorWithWhite:0 alpha:0].CGColor,nil];
    
    _dropShadow = [dropShadow retain];
    [dropShadow release];
    
    // drop it like it's hot
    if (iPad) {
        [_contentView.layer insertSublayer:_dropShadow atIndex:0];
    }
    
    
    // container
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    containerView.autoresizesSubviews = YES;
    
    _containerView = [containerView retain];
    [self.contentView addSubview:_containerView];
    [containerView release];
    
    // footer view
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _footerView = [footerView retain];
    [footerView release];
    
    // on foot
    if (iPad) {
        [self.contentView addSubview:_footerView];
    }
    
    // footer stuff
    UILabel *labelSearch = [[UILabel alloc] initWithFrame:CGRectZero];
    labelSearch.backgroundColor = [UIColor clearColor];
    labelSearch.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    labelSearch.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    labelSearch.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    labelSearch.shadowOffset = CGSizeMake(0,1);
    labelSearch.opaque = YES;
    labelSearch.numberOfLines = 1;
    
    _labelSearch = [labelSearch retain];
    [_footerView addSubview:_labelSearch];
    [labelSearch release];
    
    Button *buttonSearch = [[Button alloc] initStyle:ButtonStylePrimary];
    [buttonSearch setTitle:NSLocalizedString(@"Search", @"Search") forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(actionSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonSearch = [buttonSearch retain];
    [_footerView addSubview:_buttonSearch];
    [buttonSearch release];
    
    Button *buttonExport = [[Button alloc] init];
    [buttonExport setTitle:NSLocalizedString(@"Email", @"Email") forState:UIControlStateNormal];
    [buttonExport addTarget:self action:@selector(actionExport:) forControlEvents:UIControlEventTouchUpInside];
    [buttonExport setHidden:YES];
    
    _buttonExport = [buttonExport retain];
    [_footerView addSubview:_buttonExport];
    [buttonExport release];
    
    
    // search dashboard
    DashboardViewController *dashboardViewController = [[DashboardViewController alloc] init];
    dashboardViewController.delegate = self;
    
    // navigation controller
    NavigationController *searchNavigationController = [[NavigationController alloc] initWithRootViewController:dashboardViewController];
    searchNavigationController.navigationBar.hidden = YES;
    _searchNavigationController = [searchNavigationController retain];
    [searchNavigationController release];
    [dashboardViewController release];
    
    // add to container
    [self addChildViewController:_searchNavigationController];
    [_containerView addSubview:_searchNavigationController.view];
    
    
    // gestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelegate:self];
    [_modalView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    // resize & reset
    [self resize];
}


/*
 * View will appear.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog();
    
    // track
    [Tracker trackView:@"Search"];
    
    // defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // reset term
    NSString *trm = (NSString*) [defaults objectForKey:udSearchTerm];
    [_term setString:trm?trm:@""];
    
    // format
    [self formatTerm];
    
    // section
    NSString *section = [defaults objectForKey:udSearchSection];
    NSString *type = [defaults objectForKey:udSearchType];
    type = type ? type : typeMovie;
    if (section) {
        
        // search
        if ([section isEqualToString:udvSectionSearch] && [_term length] > 0) {
            if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
                [delegate search:_term type:type];
            }
        }
        else if ([section isEqualToString:udvSectionNowPlaying]) {
            if (delegate && [delegate respondsToSelector:@selector(nowPlaying:more:)]) {
                [self dbdata];
                [delegate nowPlaying:type more:NO];
            }
        }
        else if ([section isEqualToString:udvSectionPopular]) {
            if (delegate && [delegate respondsToSelector:@selector(popular:more:)]) {
                [self dbdata];
                [delegate popular:type more:NO];
            }
        }
        else if ([section isEqualToString:udvSectionFavorites]) {
            [self favorites:type];
        }
        else if ([section isEqualToString:udvSectionHistory]) {
            if (delegate && [delegate respondsToSelector:@selector(history:)]) {
                [self dbdata];
                [delegate history:type];
            }
        }
    }
}

/*
 * Rotation.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self resize];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resize];
}

/**
 * Resize.
 */
- (void)resize {
    FLog();
    
    // vars
    BOOL landscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    float kheight = iPad ? (landscape ? 59 : 0) : (landscape ? 162 : 216);
    float fheight = iPad ? 44 : 0;
    float cheight = iPad ? (vframe.size.height-kheight) : (landscape ? vframe.size.width-vframe.origin.y-kheight : vframe.size.height-kheight);
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // frames
    CGRect selfFrame = landscape ? CGRectMake(0,vframe.origin.y,screen.size.height,screen.size.width-vframe.origin.y) : CGRectMake(0,vframe.origin.y,screen.size.width,screen.size.height-vframe.origin.y);
    CGRect modalFrame = CGRectMake(0,0,selfFrame.size.width,selfFrame.size.height);
    CGRect contentFrame = CGRectMake(0, 0, selfFrame.size.width, cheight);
    CGRect footerFrame = CGRectMake(10+(selfFrame.size.width-vframe.size.width)/2.0,contentFrame.size.height-fheight,vframe.size.width-20,fheight);
    CGRect containerFrame = CGRectMake(10+(selfFrame.size.width-vframe.size.width)/2.0, 0, vframe.size.width-20, contentFrame.size.height-fheight);
    CGRect navigatorFrame = CGRectMake(0,0,containerFrame.size.width,containerFrame.size.height);
    CGRect shadowFrame = CGRectMake(0,cheight,selfFrame.size.width,20);
    
    // views
    self.view.frame = selfFrame;
    _modalView.frame = modalFrame;
    _contentView.frame = contentFrame;
    _containerView.frame = containerFrame;
    _footerView.frame = footerFrame;
    _dropShadow.frame = shadowFrame;
    
    // navigation
    _searchNavigationController.view.frame = navigatorFrame;
    
    // footer
    if (iPad) {
        
        // search
        _buttonSearch.frame = CGRectMake(footerFrame.size.width-75, 7, 75, footerFrame.size.height-10);
        _labelSearch.frame = CGRectMake(0, 4, footerFrame.size.width-85, footerFrame.size.height-10);
        
        // export
        _buttonExport.frame = CGRectMake(footerFrame.size.width-75, 7, 75, footerFrame.size.height-10);
    }
    
}


#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}

/*
 * Touches.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}



#pragma mark -
#pragma mark Controller

/**
 * Favorites.
 */
- (void)favorites:(NSString*)type {
    FLog();
    
    // section
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:udvSectionFavorites forKey:udSearchSection];
    [defaults synchronize];
    
    // controller
    FavoritesViewController *favoritesViewController = [[FavoritesViewController alloc] init];
    favoritesViewController.delegate = self;
    [favoritesViewController setType:type];
    
    // export delegate
    self.exp = favoritesViewController;
    
    // push
    [_searchNavigationController popToRootViewControllerAnimated:NO];
    [_searchNavigationController pushViewController:favoritesViewController animated:YES];
    [favoritesViewController release];
    
    // footer
    _buttonSearch.hidden = YES;
    _labelSearch.hidden = YES;
    _buttonExport.hidden = NO;
    
}


/**
 * DBData.
 */
- (void)dbdata {
    FLog();
    
    // controller
    DBDataViewController *dbDataViewController = [[DBDataViewController alloc] init];
    dbDataViewController.delegate = self;
    [dbDataViewController loadView];
    
    // data delgate
    self.dta = dbDataViewController;
    
    // push
    [_searchNavigationController popToRootViewControllerAnimated:NO];
    [_searchNavigationController pushViewController:dbDataViewController animated:YES];
    [dbDataViewController release];
    
    // footer
    [self animationFooterHide];
    
}

/*
 * Back.
 */
- (void)back {
    FLog();
    
    // section
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:udSearchSection];
    
    // pop
    [_searchNavigationController popToRootViewControllerAnimated:YES];
    
    // fluff
    self.dta = nil;
    self.exp = nil;
    
    // footer
    [self animationFooterShow];
    
}



#pragma mark -
#pragma mark Business

/**
 * Search reset.
 */
- (void)searchChanged:(NSString*)txt {
    GLog();
    
    // pop
    if ([_searchNavigationController.viewControllers count] > 1) {
        
        // section
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:udSearchSection];
        
        // pop
        [_searchNavigationController popToRootViewControllerAnimated:YES];
        
        // footer
        [self animationFooterShow];
    }

    // term
    [_term setString:txt];
    
    // format
    [self formatTerm];

}

/**
 * Loaded search.
 */
- (void)loadedSearch:(Search *)search {
    FLog();
    
    // section
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:udvSectionSearch forKey:udSearchSection];
    [defaults synchronize];
    
    // result
    [dta dataSearch:search];
}

/**
 * Loaded popular.
 */
- (void)loadedPopular:(Popular*)popular more:(BOOL)more {
    FLog();
    
    // section
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:udvSectionPopular forKey:udSearchSection];
    [defaults synchronize];
    
    // result
    [dta dataPopular:popular more:more];
}


/**
 * Loaded now playing.
 */
- (void)loadedNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more {
    FLog();
    
    // section
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:udvSectionNowPlaying forKey:udSearchSection];
    [defaults synchronize];
    
    // result
    [dta dataNowPlaying:nowplaying more:more];
}

/**
 * Loaded history.
 */
- (void)loadedHistory:(NSArray *)history type:(NSString *)type {
    FLog();
    
    // section
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:udvSectionHistory forKey:udSearchSection];
    [defaults synchronize];
    
    // result
    [dta dataHistory:history type:type];
}



#pragma mark -
#pragma mark Notifications

/*
 * Notification search term.
 */
- (void)notificationSearchTerm:(NSNotification*)notification {
    GLog();
    
    // term
    NSString *term = [[notification userInfo] objectForKey:ntvSearchTerm];
    if (term) {
        [self searchChanged:term];
    }
}

/*
 * Notification search type.
 */
- (void)notificationSearchType:(NSNotification*)notification {
    GLog();
    
    // term
    [self formatTerm];
}


#pragma mark -
#pragma mark Dashboard Delegate

/*
 * Dashboard now playing.
 */
- (void)dashboardNowPlaying:(NSString *)type {
    FLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:@"Now Playing" label:type];
    
    // data
    [self dbdata];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(nowPlaying:more:)]) {
        [delegate nowPlaying:type more:NO];
    }
}

/*
 * Dashboard popular.
 */
- (void)dashboardPopular:(NSString *)type {
    FLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:@"Popular" label:type];
    
    // data
    [self dbdata];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(popular:more:)]) {
        [delegate popular:type more:NO];
    }
}

/*
 * Dashboard favorites.
 */
- (void)dashboardFavorites:(NSString *)type {
    FLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:@"Favorites" label:type];
    
    // favorites
    [self favorites:type];
}

/*
 * Dashboard history.
 */
- (void)dashboardHistory:(NSString *)type {
    FLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:@"History" label:type];
    
    // data
    [self dbdata];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(history:)]) {
        [delegate history:type];
    }
}





#pragma mark -
#pragma mark DBData Delegate

/*
 * Data selected.
 */
- (void)dbDataSelected:(DBData *)data {
    FLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(searchSelected:type:)]) {
        [delegate searchSelected:data.ref type:data.type];
    }
 
}

/*
 * Load more.
 */
- (void)dbDataLoadMore:(DBData*)data {
    FLog();
    
    // switch
    switch (data.dta) {
            
        // now playing
        case DBDataNowPlaying: {
            
            // delegate
            if (delegate && [delegate respondsToSelector:@selector(nowPlaying:more:)]) {
                [delegate nowPlaying:typeMovie more:YES];
            }
            break;
        }
        
        // popular movies
        case DBDataPopularMovies: {
            
            // delegate
            if (delegate && [delegate respondsToSelector:@selector(popular:more:)]) {
                [delegate popular:typeMovie more:YES];
            }
            break;
        }
        
        // whatever
        default:
            break;
    }
}

/*
 * Dismiss.
 */
- (void)dbDataDismiss {
    FLog();
    [self back];
}



#pragma mark -
#pragma mark Favorites Delegate

/*
 * Favorite selected.
 */
- (void)favoriteSelected:(Favorite*)favorite {
    FLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(searchSelected:type:)]) {
        [delegate searchSelected:favorite.dbid type:favorite.type];
    }
    
}

/*
 * Dismiss.
 */
- (void)favoritesDismiss {
    FLog();
    
    // back
    [self back];
    
    // footer
    _buttonSearch.hidden = NO;
    _labelSearch.hidden = NO;
    _buttonExport.hidden = YES;
}


#pragma mark -
#pragma mark Actions

/*
 * Action search.
 */
- (void)actionSearch:(id)sender {
    DLog();
    
    // type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *searchType = (NSString*) [defaults objectForKey:udSearchType];
    searchType = searchType ? searchType : typeMovie;
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:_term type:searchType];
    }
}

/*
 * Action export.
 */
- (void)actionExport:(id)sender {
    DLog();
    
    // delegate
    if (exp && [exp respondsToSelector:@selector(exportFavorites)]) {
        [exp exportFavorites];
    }
}



#pragma mark -
#pragma mark Gestures

/*
 * Gesture tap.
 */
- (void)gestureTap:(UITapGestureRecognizer *)recognizer {
    FLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(searchClose)]) {
        [delegate searchClose];
    }
    
}



#pragma mark -
#pragma mark Formatters


/*
 * Format term.
 */
- (void)formatTerm {
    
    // type
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:udSearchType];
    type = type ? type : typeMovie;
    
    // hint
    if (_term == NULL || [[_term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0) {
        [_labelSearch setText:NSLocalizedString(@"Type something to search", @"Type something to search")];
        _buttonSearch.enabled = NO;
    }
    else {
        [_labelSearch setText:[NSString stringWithFormat:@"%@ %@ «%@»",NSLocalizedString(@"Search", @"Search"),[type isEqualToString:typePerson] ? NSLocalizedString(@"Person", @"Person") : NSLocalizedString(@"Movie", @"Movie") ,_term]];
        _buttonSearch.enabled = YES;
    }
}



#pragma mark -
#pragma mark Animations


/**
 * Shows the footer.
 */
- (void)animationFooterShow {
	GLog();
    
    // ipad only
    if (iPad) {
        
        // prepare views
        _footerView.alpha = 0;
        _footerView.hidden = NO;
        
        // animate
        [UIView beginAnimations:@"search_footer_show" context:nil];
        [UIView setAnimationDuration:kAnimateTimeSearchFooterShow];
        _footerView.alpha = 1;
        [UIView commitAnimations];
        
        // clean it up
        [self performSelector:@selector(animationFooterShowDone) withObject:nil afterDelay:kAnimateTimeSearchFooterShow];
    }
    
}
- (void)animationFooterShowDone {
	GLog();
    
}


/**
 * Hides the footer.
 */
- (void)animationFooterHide {
	GLog();
    
    // ipad only
    if (iPad) {
        
        // prepare views
        _footerView.alpha = 1.0;
        _footerView.hidden = NO;
        
        // animate
        [UIView beginAnimations:@"search_footer_hide" context:nil];
        [UIView setAnimationDuration:kAnimateTimeSearchFooterHide];
        _footerView.alpha = 0;
        [UIView commitAnimations];
        
        // clean it up
        [self performSelector:@selector(animationFooterHideDone) withObject:nil afterDelay:kAnimateTimeSearchFooterHide];
    }
    
}
- (void)animationFooterHideDone {
	GLog();
    
    // view
	_footerView.alpha = 0;
    _footerView.hidden = YES;
    
}




#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	FLog();
    
    // remove
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // vars
    [_term release];
    
    // ui
    [_contentView release];
    [_modalView release];
    [_containerView release];
    [_footerView release];
    [_dropShadow release];
    
    [_buttonSearch release];
    [_labelSearch release];
    
    [_buttonExport release];
    
    // controller
    [_searchNavigationController release];
	
	// release 
    [super dealloc];
}

@end


#pragma mark -
#pragma mark SearchView
#pragma mark -

/**
 * SearchView.
 */
@implementation SearchView


#pragma mark -
#pragma mark Object

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame type:(int)type {
	GLog();
	
	// init self
    if ((self = [super initWithFrame:frame])) {
		
		// init
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        // type
        _type = type;
        
        // texture
        UIImage *texture = [UIImage imageNamed:@"bg_content.png"];
        _texture = [texture retain];
        _tsize.size = _texture.size;

	}
	
	// return
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
    CGContextSaveGState(context);
    CGContextClipToRect(context, mrect);
    CGContextDrawTiledImage(context,_tsize,_texture.CGImage);
    CGContextRestoreGState(context);
     
	// header lines
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.9 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, w, 0);
	CGContextStrokePath(context);
    
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.9 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, 44-1);
	CGContextAddLineToPoint(context, w, 44-1);
	CGContextStrokePath(context);

    // footer
    if (_type == SearchViewFooter) {
        
        // footer lines
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.9 alpha:1].CGColor);
        CGContextMoveToPoint(context, 0, h-43);
        CGContextAddLineToPoint(context, w, h-43);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.9 alpha:1].CGColor);
        CGContextMoveToPoint(context, 0, h);
        CGContextAddLineToPoint(context, w, h);
        CGContextStrokePath(context);
        
    }
    
    
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



