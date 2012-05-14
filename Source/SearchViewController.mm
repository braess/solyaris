//
//  SearchViewController.m
//  Solyaris
//
//  Created by Beat Raess on 25.4.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import "SearchViewController.h"
#import "SolyarisConstants.h"


/*
 * Formatter Stack.
 */
@interface DashboardViewController (Formatters)
- (void)formatTerm;
@end


/**
 * Animation Stack.
 */
@interface DashboardViewController (Animations)
- (void)animationFooterShow;
- (void)animationFooterShowDone;
- (void)animationFooterHide;
- (void)animationFooterHideDone;
@end


/**
 * SearchViewController
 */
@implementation SearchViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeSearchFooterShow     0.21f
#define kAnimateTimeSearchFooterHide     0.15f



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
        
	}
	return self;
    
}


#pragma mark -
#pragma mark Properties

// synthesize
@synthesize delegate;
@synthesize modalView = _modalView;
@synthesize contentView = _contentView;



#pragma mark -
#pragma mark View lifecycle

/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
    
    // view
    self.view = [[UIView alloc] initWithFrame:CGRectZero];

    
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
    UIView *contentView = [[SearchView alloc] initWithFrame:CGRectZero];
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
    labelSearch.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    labelSearch.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    labelSearch.shadowOffset = CGSizeMake(1,1);
    labelSearch.opaque = YES;
    labelSearch.numberOfLines = 1;
    
    _labelSearch = [labelSearch retain];
    [_footerView addSubview:_labelSearch];
    [labelSearch release];
    
    Button *buttonSearch = [[Button alloc] init];
    [buttonSearch setTitle:NSLocalizedString(@"Search", @"Search") forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(actionSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonSearch = [buttonSearch retain];
    [_footerView addSubview:_buttonSearch];
    [buttonSearch release];
    
    
    // search dashboard
    DashboardViewController *dashboardViewController = [[DashboardViewController alloc] init];
    [dashboardViewController loadView];
    dashboardViewController.delegate = self;
	_dashboardViewController = [dashboardViewController retain];
    [dashboardViewController release];
    
    
    // search result
    DBDataViewController *dbDataViewController = [[DBDataViewController alloc] init];
    [dbDataViewController loadView];
    dbDataViewController.delegate = self;
    dbDataViewController.header.delegate = self;
	_dbDataViewController = [dbDataViewController retain];
    [dbDataViewController release];
    
    // navigation controller
    NavigationController *searchNavigationController = [[NavigationController alloc] initWithRootViewController:_dashboardViewController];
    searchNavigationController.navigationBar.hidden = YES;
    _searchNavigationController = [searchNavigationController retain];
    [searchNavigationController release];
    
    // add to container
    [_containerView addSubview:_searchNavigationController.view];
    
    // gestures
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    _tapRecognizer = [tapRecognizer retain];
    [tapRecognizer release];
    
    // tap tap
    if (iPad) {
        [_modalView addGestureRecognizer:_tapRecognizer];
    }
    
    // vars
    NSMutableString *strTerm = [[NSMutableString alloc] init];
    _term = [strTerm retain];
    [strTerm release];
    
    // resize & reset
    [self resize];
    [self reset];
}

/**
 * Resize.
 */
- (void)resize {
    FLog();
    
    // vars
    BOOL landscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    float kheight = iPad ? (landscape ? 59 : 0) : (landscape ? 162 : 216);
    float fheight = iPad ? kHeaderHeight : 0;
    float cheight = iPad ? (vframe.size.height-kheight) : (landscape ? vframe.size.width-vframe.origin.y-kheight : vframe.size.height-kheight);
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // frames
    CGRect selfFrame = landscape ? CGRectMake(0,vframe.origin.y,window.frame.size.height,window.frame.size.width-vframe.origin.y) : CGRectMake(0,vframe.origin.y,window.frame.size.width,window.frame.size.height-vframe.origin.y);
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
        
        // frames
        _buttonSearch.frame = CGRectMake(footerFrame.size.width-75, 7, 75, footerFrame.size.height-10);
        _labelSearch.frame = CGRectMake(0, 4, footerFrame.size.width-85, footerFrame.size.height-10);
    }
    
    
}





#pragma mark -
#pragma mark Business

/**
 * Reset.
 */
- (void)reset {
    FLog();
    
    // defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // reset term
    NSString *trm = (NSString*) [defaults objectForKey:udSearchTerm];
    [_term setString:trm?trm:@""];
    
    // format
    [self formatTerm];
    
    // pop
    [_searchNavigationController popToRootViewControllerAnimated:YES];
    
    // reset
    [_dbDataViewController dbDataReset];
    
}


/**
 * Search reset.
 */
- (void)searchChanged:(NSString *)txt {
    GLog();
    
    // pop
    if ([_searchNavigationController.viewControllers count] > 1) {
        
        // pop
        [_searchNavigationController popToRootViewControllerAnimated:YES];
        
        // reset
        [_dbDataViewController dbDataReset];
        
        // footer
        [self animationFooterShow];
    }

    // term
    [_term setString:txt];
    
    // format
    [self formatTerm];

}

/**
 * Data loading.
 */
- (void)dataLoading {
    FLog();
    
    // loading
    [_dbDataViewController dbDataLoading];
    
    // push
    [_searchNavigationController popToRootViewControllerAnimated:NO];
    [_searchNavigationController pushViewController:_dbDataViewController animated:YES];
    
    // footer
    [self animationFooterHide];
    
}

/**
 * Loaded search.
 */
- (void)loadedSearch:(Search *)search {
    FLog();
    
    // result
    [_dbDataViewController dbSearchResult:search];
}

/**
 * Loaded popular.
 */
- (void)loadedPopular:(Popular*)popular more:(BOOL)more {
    FLog();
    
    // result
    [_dbDataViewController dbPopularResult:popular more:more];
}


/**
 * Loaded now playing.
 */
- (void)loadedNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more {
    FLog();
    
    // result
    [_dbDataViewController dbNowPlayingResult:nowplaying more:more];
}

/**
 * Loaded history.
 */
- (void)loadedHistory:(NSArray *)history type:(NSString *)type {
    FLog();
    
    // result
    [_dbDataViewController dbHistoryResult:history type:type];
}



#pragma mark -
#pragma mark Header Delegate

/*
 * Header back.
 */
- (void)headerBack {
    FLog();
    
    // pop
    [_searchNavigationController popToRootViewControllerAnimated:YES];
    
    // footer
    [self animationFooterShow];
    
}


#pragma mark -
#pragma mark Dashboard Delegate

/*
 * Dashboard now playing.
 */
- (void)dashboardNowPlaying:(NSString *)type {
    FLog();
    
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
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(popular:more:)]) {
        [delegate popular:type more:NO];
    }
}

/*
 * Dashboard history.
 */
- (void)dashboardHistory:(NSString *)type {
    FLog();
    
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
    if (delegate && [delegate respondsToSelector:@selector(dataSelected:)]) {
        [delegate dataSelected:data];
    }
 
}

/*
 * Load more.
 */
- (void)dbDataLoadMore:(int)dbdata {
    FLog();
    
    // switch
    switch (dbdata) {
            
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



#pragma mark -
#pragma mark Gestures

/*
 * Tapped.
 */
- (void)tapped:(UITapGestureRecognizer*) recognizer {
	DLog();
    
    // what's the point
    CGPoint point = [recognizer locationInView:self.view];
    if (point.y > _contentView.frame.size.height+60) {
        
        // delegate
        if (delegate && [delegate respondsToSelector:@selector(searchClose)]) {
            [delegate searchClose];
        }
        
    }
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


#pragma mark -
#pragma mark Formatters


/*
 * Format term.
 */
- (void)formatTerm {
    
    // hint
    if (_term == NULL || [[_term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0) {
        [_labelSearch setText:NSLocalizedString(@"Type something to search", @"Type something to search")];
        _buttonSearch.enabled = NO;
    }
    else {
        [_labelSearch setText:[NSString stringWithFormat:@"%@ «%@»",NSLocalizedString(@"Search", @"Search"),_term]];
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
	GLog();
    
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
    
    // controller
    [_searchNavigationController release];
    [_dashboardViewController release];
    [_dbDataViewController release];
    
    // gestures
    [_tapRecognizer release];
	
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
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
	
	// init self
    if ((self = [super initWithFrame:frame])) {
		
		// init
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw; 

	}
	
	// return
	return self;
}


/*
 * Draw that thing.
 */
- (void)drawRect:(CGRect)rect {
    
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
    
    // textures
    UIImage *texture = [UIImage imageNamed:@"bg_content.png"];
    CGRect tcRect;
    tcRect.size = texture.size; 

    CGContextSaveGState(context);
    CGContextClipToRect(context, mrect);
    CGContextDrawTiledImage(context,tcRect,texture.CGImage);
    CGContextRestoreGState(context);
     
	// header lines
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, w, 0);
	CGContextStrokePath(context);
    
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kHeaderHeight-1);
	CGContextAddLineToPoint(context, w, kHeaderHeight-1);
	CGContextStrokePath(context);

    
    // ipad footr
    if (iPad) {
        
        // footer lines
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
        CGContextMoveToPoint(context, 0, h-kHeaderHeight+1);
        CGContextAddLineToPoint(context, w, h-kHeaderHeight+1);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
        CGContextMoveToPoint(context, 0, h);
        CGContextAddLineToPoint(context, w, h);
        CGContextStrokePath(context);
        
        
    }
    
    
}

@end



