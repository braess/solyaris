//
//  InformationViewController.m
//  IMDG
//
//  Created by CNPP on 28.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "InformationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IMDGConstants.h"
#import "BlockerView.h"
#import "DataNode.h"


/**
 * Section Stack.
 */
@interface InformationViewController (SectionStack)
- (UIView *)sectionHeader:(NSString*)label;
- (UIView *)sectionFooter;
@end



/**
 * Swap Stack.
 */
@interface InformationViewController (SwapStack)
- (void)swapListing;
- (void)swapTMDb;
- (void)swapIMDb;
- (void)swapWikipedia;
- (void)swapReset;
@end


/**
 * Action Stack.
 */
@interface InformationViewController (ActionStack)
- (void)actionResize:(id)sender;
- (void)resizeFull;
- (void)resizeDefault;
- (void)actionToolsReference:(id)sender;
@end

/**
 * Reference Stack.
 */
@interface InformationViewController (ReferenceStack)
- (void)referenceAmazon;
- (void)referenceITunes;
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


// local vars
static float informationHeaderHeight = 110;
static float informationFooterHeight = 60;

static int informationGapOffset = 10;
static int informationGapInset = 15;



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
	return [self initWithFrame:CGRectMake(0, 0, 600, 600)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
        
        // type
        type_movie = NO;
        type_person = NO;
        
        // modes
        mode_listing = NO;
        mode_tmdb = NO;
        mode_imdb = NO;
        mode_wikipedia = NO;
        
        // screen
        fullscreen = NO;
        
        // fields
        _referenceTMDb = [[NSMutableString alloc] init];
        _referenceIMDb = [[NSMutableString alloc] init];
        _referenceWikipedia = [[NSMutableString alloc] init];
        _referenceAmazon = [[NSMutableString alloc] init];
        _referenceITunes = [[NSMutableString alloc] init];

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

    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // frames
    CGRect windowFrame = window.frame;
    CGRect contentFrame = CGRectMake(windowFrame.size.width/2.0-vframe.size.width/2.0, windowFrame.size.height/2.0-vframe.size.height/2.0, vframe.size.width, vframe.size.height);
    CGRect headerFrame = CGRectMake(0, 0, contentFrame.size.width, informationHeaderHeight);
    CGRect footerFrame = CGRectMake(0, contentFrame.size.height-informationFooterHeight, contentFrame.size.width, informationFooterHeight);
    CGRect componentFrame = CGRectMake(0, informationHeaderHeight, contentFrame.size.width, contentFrame.size.height-informationHeaderHeight-informationFooterHeight);
    
    
    // view
    self.view = [[UIView alloc] initWithFrame:windowFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.hidden = YES;
    
    // modal
    UIView *mView = [[UIView alloc] initWithFrame:windowFrame];
    mView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mView.backgroundColor = [UIColor blackColor];
    mView.opaque = NO;
    mView.alpha = 0.3;
    self.modalView = [mView retain];
    [self.view addSubview:_modalView];
    [mView release];
    
    // blocker
    float safety = 25;
    BlockerView *bView = [[BlockerView alloc] initWithFrame:CGRectMake(contentFrame.origin.x-safety, contentFrame.origin.y-safety, contentFrame.size.width+2*safety, contentFrame.size.height+2*safety)];
    [_modalView addSubview:bView];

	
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
	btnResize.frame = CGRectMake(contentFrame.size.width-32, 0, 32, 32);
	[btnResize setImage:[UIImage imageNamed:@"btn_resize-full.png"] forState:UIControlStateNormal];
	[btnResize addTarget:self action:@selector(actionResize:) forControlEvents:UIControlEventTouchUpInside];
    _buttonResize = [btnResize retain];
	[ctView  addSubview:_buttonResize];
    [btnResize release];

    
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
    
    // add imdb to content
    _componentIMDb = [componentIMDb retain];
    [ctView addSubview:_componentIMDb];
    [componentIMDb release];
    
    // component wikipedia
    HTMLView *componentWikipedia = [[HTMLView alloc] initWithFrame:componentFrame];
    componentWikipedia.tag = TagInformationComponentWikipedia;
    componentWikipedia.hidden = YES;
    
    // add wikipedia to content
    _componentWikipedia = [componentWikipedia retain];
    [ctView addSubview:_componentWikipedia];
    [componentWikipedia release];

    
    
    // footer view
    UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
    footerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin);
    footerView.tag = TagInformationFooter;
	footerView.backgroundColor = [UIColor clearColor];
	footerView.opaque = YES;
    
    // actions
    ActionBar *abar = [[ActionBar alloc] initWithFrame:CGRectMake(informationGapInset, informationGapOffset, footerFrame.size.width-2*informationGapInset, footerFrame.size.height-2*informationGapOffset)];
    
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

    
    // action items
    ActionBarButtonItem *actionListing = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_listing.png"] 
                                                                              title:NSLocalizedString(@"Cast", @"Cast") 
                                                                             target:self 
                                                                             action:@selector(swapListing)];
    _actionListing = [actionListing retain];
    [actionListing release];
    
    ActionBarButtonItem *actionTMDb = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_tmdb.png"] 
                                                                                  title:NSLocalizedString(@"Info", @"Info")
                                                                                 target:self 
                                                                                 action:@selector(swapTMDb)];
    _actionTMDb = [actionTMDb retain];
    [actionTMDb release];
    
    ActionBarButtonItem *actionIMDb = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_imdb.png"] 
                                                                           title:NSLocalizedString(@"IMDb", @"IMDb")
                                                                          target:self 
                                                                          action:@selector(swapIMDb)];
    _actionIMDb = [actionIMDb retain];
    [actionIMDb release];
    
    ActionBarButtonItem *actionWikipedia = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_wikipedia.png"] 
                                                                                title:NSLocalizedString(@"Wikipedia", @"Wikipedia")
                                                                               target:self 
                                                                               action:@selector(swapWikipedia)];
    _actionWikipedia = [actionWikipedia retain];
    [actionWikipedia release];
    
    
    
    // add action tab bar
    [abar setItems:[NSArray arrayWithObjects:nspace,itemFlex,_actionListing,_actionTMDb,_actionIMDb,_actionWikipedia,itemFlex,nspace,nil]];
    [footerView addSubview:abar];
    [itemFlex release];
    
    
    
    // navigator
    HTMLNavigatorView *htmlNavigator = [[HTMLNavigatorView alloc] initWithFrame:CGRectMake(informationGapInset, 10, 80, 40)];
    htmlNavigator.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin);
    htmlNavigator.delegate = self;
    
    // add navigator to footer
    _htmlNavigator = [htmlNavigator retain];
    [footerView addSubview:_htmlNavigator];
    [htmlNavigator release];
    
    
    // tools
    UIView *toolsView = [[UIView alloc] initWithFrame:CGRectMake(footerFrame.size.width-informationGapInset-80, 10, 80, 40)];
    toolsView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    toolsView.backgroundColor = [UIColor clearColor];
    
    // reference
    UIButton *btnReference = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReference.frame = CGRectMake(toolsView.frame.size.width-40, 4, 32, 32);
    btnReference.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [btnReference setImage:[UIImage imageNamed:@"btn_reference.png"] forState:UIControlStateNormal];
    [btnReference addTarget:self action:@selector(actionToolsReference:) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:btnReference];

    
    // add tools to footer
    [footerView addSubview:toolsView];
    
    
    // add footer view to content
    [ctView addSubview:footerView];
    [footerView release];
    
    // add & release content
    _contentView = [ctView retain];
    [self.view addSubview:_contentView];
    [self.view bringSubviewToFront:_contentView];
    [ctView release];
    
	    
}


/*
 * Resize.
 */
- (void)resize {
    
    // fullscreen
    if (fullscreen) {
        [self resizeFull];
    }
}


/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();


}



#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // ignore
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // ignore
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(informationDismiss)]) {
		[delegate informationDismiss];
	}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // ignore
}



#pragma mark -
#pragma mark Business

/*
 * Information movie.
 */
- (void)informationMovie:(Movie*)movie nodes:(NSArray *)nodes {
    FLog();
    
    // type
    type_person = NO;
    type_movie = YES;
    
    // references
    [_referenceTMDb setString:[NSString stringWithFormat:@"%@%i",urlTMDbMovie,[movie.mid intValue]]];
    if (([movie.imdb_id length] > 0)) {
        [_referenceIMDb setString:[NSString stringWithFormat:@"%@%@",urlIMDbMovie,movie.imdb_id]];
    }
    else {
        [_referenceIMDb setString:[NSString stringWithFormat:@"%@%@",urlIMDbSearch,[movie.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    [_referenceWikipedia setString:[NSString stringWithFormat:@"%@%@",urlWikipediaSearch,[movie.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceAmazon setString:[NSString stringWithFormat:@"%@%@",urlAmazonSearch,[movie.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceITunes setString:[NSString stringWithFormat:@"%@%@",urlITunesSearch,[movie.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    // header
    [_informationMovieView reset:movie];
    _informationPersonView.hidden = YES;
    _informationMovieView.hidden = NO;
    
    
    // component listing
    [_componentListing reset:nodes];
    [_actionListing setTitle:NSLocalizedString(@"Cast", @"Cast")];
    
    // component tmdb
    [_componentTMDb reset:movie.overview slides:nil];
    
    // component imdb
    [_componentIMDb reset:_referenceIMDb];
    
    // component wikipedia
    [_componentWikipedia reset:_referenceWikipedia];

    
    // swap listing
    [self swapListing];
    
}

/**
 * Information person.
 */
- (void)informationPerson:(Person*)person nodes:(NSArray *)nodes {
    FLog();
    
    // type
    type_movie = NO;
    type_person = YES;
    
    // references
    [_referenceTMDb setString:[NSString stringWithFormat:@"%@%i",urlTMDbPerson,[person.pid intValue]]];
    [_referenceIMDb setString:[NSString stringWithFormat:@"%@%@",urlIMDbSearch,[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceWikipedia setString:[NSString stringWithFormat:@"%@%@",urlWikipediaSearch,[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceAmazon setString:[NSString stringWithFormat:@"%@%@",urlAmazonSearch,[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_referenceITunes setString:[NSString stringWithFormat:@"%@%@",urlITunesSearch,[person.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    // header
    [_informationPersonView reset:person];
    _informationMovieView.hidden = YES;
    _informationPersonView.hidden = NO;
    
    // component listing
    [_componentListing reset:nodes];
    [_actionListing setTitle:NSLocalizedString(@"Movies", @"Movies")];
    
    // component tmdb
    [_componentTMDb reset:person.biography slides:nil];
    
    // component imdb
    [_componentIMDb reset:_referenceIMDb];
    
    // component wikipedia
    [_componentWikipedia reset:_referenceWikipedia];
    
    // swap listing
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
 * Swap listing.
 */
- (void)swapWikipedia {
    FLog();
    
    // change mode
    if (! mode_wikipedia) {
        
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
 * Swap reset.
 */
- (void)swapReset {
    FLog();
    
    // reset mode
    mode_listing = NO;
    mode_tmdb = NO;
    mode_imdb = NO;
    mode_wikipedia = NO;
    
    // actions
    [_actionListing setSelected:NO];
    [_actionTMDb setSelected:NO];
    [_actionIMDb setSelected:NO];
    [_actionWikipedia setSelected:NO];
    
    // hide views
    _componentListing.hidden = YES;
    _componentTMDb.hidden = YES;
    _componentIMDb.hidden = YES;
    _componentWikipedia.hidden = YES;
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
        [self resizeDefault];
    }
    else {
        [self resizeFull];
    }
    fullscreen = ! fullscreen;
}
- (void)resizeFull {
    GLog();
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect wframe = window.frame;
    if ([self.delegate informationOrientationLandscape]) {
        wframe.size.width = window.frame.size.height;
        wframe.size.height = window.frame.size.width;
    }

    
    // frame
    CGRect rframe = wframe;
    
    // animate
	[UIView beginAnimations:@"resize_default" context:nil];
    [UIView setAnimationDuration:kAnimateTimeResizeFull];
	_contentView.frame = rframe;
	[UIView commitAnimations];
    
    // button
    [_buttonResize setImage:[UIImage imageNamed:@"btn_resize-default.png"] forState:UIControlStateNormal];
    
}
- (void)resizeDefault {
    GLog();
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect wframe = window.frame;
    if ([self.delegate informationOrientationLandscape]) {
        wframe.size.width = window.frame.size.height;
        wframe.size.height = window.frame.size.width;
    }
    
    // frame
    CGRect rframe = CGRectMake(wframe.size.width/2.0-vframe.size.width/2.0, wframe.size.height/2.0-vframe.size.height/2.0, vframe.size.width, vframe.size.height);
    
    // animate
	[UIView beginAnimations:@"resize_default" context:nil];
    [UIView setAnimationDuration:kAnimateTimeResizeDefault];
	_contentView.frame = rframe;
	[UIView commitAnimations];
    
    // button
    [_buttonResize setImage:[UIImage imageNamed:@"btn_resize-full.png"] forState:UIControlStateNormal];
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
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Open on TMDb",@"Open on TMDb"),NSLocalizedString(@"Open on IMDb",@"Open on IMDb"),NSLocalizedString(@"Open on Wikipedia",@"Open on Wikipedia"),NSLocalizedString(@"Find on Amazon",@"Find on Amazon"),NSLocalizedString(@"Find on iTunes",@"Find on iTunes"),nil];
    
    // show
    [referenceActions setTag:ActionInformationToolsReference];
    [referenceActions showFromRect:CGRectMake(_contentView.frame.origin.x + _contentView.frame.size.width-informationGapInset-32, _contentView.frame.origin.y + _contentView.frame.size.height-informationGapOffset-(informationFooterHeight/2.0), 32, 32) inView:self.view animated:YES];
    [referenceActions release];
    
}


#pragma mark -
#pragma mark Reference

/*
 * Reference TMDb.
 */
- (void)referenceTMDb {
    FLog();
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceTMDb]];
}

/*
 * Reference IMDb.
 */
- (void)referenceIMDb {
    FLog();
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceIMDb]];
}

/*
 * Reference Wikipedia.
 */
- (void)referenceWikipedia {
    FLog();
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceWikipedia]];
}

/*
 * Reference amazon.
 */
- (void)referenceAmazon {
    FLog();

    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_referenceAmazon]];
}

/*
 * Reference iTunes.
 */
- (void)referenceITunes {
    FLog();
    
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
            
        // reference
		case ActionInformationToolsReference: {
            
            // TMDb
			if (buttonIndex == 0) {
				[self referenceTMDb];
			} 
            
			// IMDb
			if (buttonIndex == 1) {
				[self referenceIMDb];
			} 
            
			// Wikipedia
			if (buttonIndex == 2) {
				[self referenceWikipedia];
			} 
            
			// Amazon
			if (buttonIndex == 3) {
				[self referenceAmazon];
			} 
            
            // iTunes
			if (buttonIndex == 4) {
				[self referenceITunes];
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
#pragma mark Memory management

/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    

    // actions
    [_actionListing release];
    [_actionTMDb release];
    [_actionIMDb release];
    [_actionWikipedia release];
    
    // components
    [_componentListing release];
    [_componentTMDb release];
    [_componentIMDb release];
    [_componentWikipedia release];
    
    // reference
    [_referenceTMDb release]; 
    [_referenceIMDb release]; 
    [_referenceWikipedia release]; 
    [_referenceAmazon release]; 
    [_referenceITunes release]; 
	
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
    
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// init
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin);
        self.contentMode = UIViewContentModeRedraw; // Thats the one
        
		// return
		return self;
	}
	
	// nop
	return nil;
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
    UIImage *texture = [UIImage imageNamed:@"texture_information.png"];
    CGRect tcRect;
    tcRect.size = texture.size; 
    
    // main
    CGContextClipToRect(context, mrect);
    CGContextDrawTiledImage(context,tcRect,texture.CGImage);
	
	// header lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, informationHeaderHeight-1);
	CGContextAddLineToPoint(context, w, informationHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, informationHeaderHeight);
	CGContextAddLineToPoint(context, w, informationHeaderHeight);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-informationFooterHeight);
	CGContextAddLineToPoint(context, w, h-informationFooterHeight);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-informationFooterHeight+1);
	CGContextAddLineToPoint(context, w, h-informationFooterHeight+1);
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
    if (tPoint.y < informationHeaderHeight) {
        
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
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        
        // frames
        CGRect iframe = CGRectMake(informationGapInset, informationGapOffset, 60, 90);
        CGRect mframe = CGRectMake(2*informationGapInset+60, informationGapOffset, frame.size.width-(2*informationGapInset+90), frame.size.height-2*informationGapOffset);
        
        // poster
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:iframe];
        ciView.contentMode = UIViewContentModeScaleAspectFill;
        ciView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        [ciView placeholderImage:[UIImage imageNamed:@"placeholder_info_movie.png"]];
        
        _imagePoster = [ciView retain];
        [self addSubview:_imagePoster];
        [ciView release];
        
        // name
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y, mframe.size.width, 36)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont fontWithName:@"Helvetica-Bold" size:21.0];
        lblName.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblName.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblName.shadowOffset = CGSizeMake(1,1);
        lblName.opaque = YES;
        lblName.numberOfLines = 1;
        
        _labelName = [lblName retain];
        [self addSubview:_labelName];
        [lblName release];
        
        // tagline
        UILabel *lblTagline = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+30, mframe.size.width, 18)];
        lblTagline.backgroundColor = [UIColor clearColor];
        lblTagline.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblTagline.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblTagline.opaque = YES;
        lblTagline.numberOfLines = 1;
        
        _labelTagline = [lblTagline retain];
        [self addSubview:_labelTagline];
        [lblTagline release];
        
        // property
        float pwidth = 75;
        
        
        // released
        UILabel *lblPropReleased = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+54, pwidth, 15)];
        lblPropReleased.backgroundColor = [UIColor clearColor];
        lblPropReleased.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropReleased.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropReleased.opaque = YES;
        lblPropReleased.numberOfLines = 1;
        [lblPropReleased setText:NSLocalizedString(@"Year:", @"Year:")];
        [self addSubview:lblPropReleased];
        
        UILabel *lblReleased = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+54, mframe.size.width-pwidth, 15)];
        lblReleased.backgroundColor = [UIColor clearColor];
        lblReleased.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblReleased.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblReleased.opaque = YES;
        lblReleased.numberOfLines = 1;
        
        _labelReleased = [lblReleased retain];
        [self addSubview:_labelReleased];
        [lblReleased release];
        
        
        // runtime
        UILabel *lblPropRuntime = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+69, pwidth, 15)];
        lblPropRuntime.backgroundColor = [UIColor clearColor];
        lblPropRuntime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropRuntime.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropRuntime.opaque = YES;
        lblPropRuntime.numberOfLines = 1;
        [lblPropRuntime setText:NSLocalizedString(@"Runtime:", @"Runtime:")];
        [self addSubview:lblPropRuntime];
        
        UILabel *lblRuntime = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+69, mframe.size.width-pwidth, 15)];
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
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    // poset
    NSString *poster = @"";
    for (Asset *a in movie.assets) {
        
        // poster
        if ([a.type isEqualToString:assetPoster] && [a.size isEqualToString:assetSizeThumb]) {
            poster = a.url;
            break;
        }
    }
    
    
    // header
    [_imagePoster loadFromURL:poster];
    [_labelName setText:movie.name];
    [_labelTagline setText:movie.tagline];
    [_labelReleased setText:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:movie.released]]];
    [_labelRuntime setText:[NSString stringWithFormat:@"%im",[movie.runtime intValue]]];
    
}


#pragma mark -
#pragma mark Memory

/*
 * Deallocates all used memory.
 */
- (void)dealloc {

    
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
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        
        // frames
        CGRect iframe = CGRectMake(informationGapInset, informationGapOffset, 60, 90);
        CGRect mframe = CGRectMake(2*informationGapInset+60, informationGapOffset, frame.size.width-(2*informationGapInset+90), frame.size.height-2*informationGapOffset);
        
        // poster
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:iframe];
        ciView.contentMode = UIViewContentModeScaleAspectFill;
        ciView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        [ciView placeholderImage:[UIImage imageNamed:@"placeholder_info_person.png"]];
        
        _imageProfile = [ciView retain];
        [self addSubview:_imageProfile];
        [ciView release];
        
        // name
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y, mframe.size.width, 36)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont fontWithName:@"Helvetica-Bold" size:21.0];
        lblName.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblName.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblName.shadowOffset = CGSizeMake(1,1);
        lblName.opaque = YES;
        lblName.numberOfLines = 1;
        
        _labelName = [lblName retain];
        [self addSubview:_labelName];
        [lblName release];
        
        // property
        float pwidth = 75;
        
        
        // known movies
        UILabel *lblPropKnownMovies = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+39, pwidth, 15)];
        lblPropKnownMovies.backgroundColor = [UIColor clearColor];
        lblPropKnownMovies.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropKnownMovies.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropKnownMovies.opaque = YES;
        lblPropKnownMovies.numberOfLines = 1;
        [lblPropKnownMovies setText:NSLocalizedString(@"Movies:", @"Movies:")];
        [self addSubview:lblPropKnownMovies];
        
        UILabel *lblKnownMovies = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+39, mframe.size.width-pwidth, 15)];
        lblKnownMovies.backgroundColor = [UIColor clearColor];
        lblKnownMovies.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblKnownMovies.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblKnownMovies.opaque = YES;
        lblKnownMovies.numberOfLines = 1;
        
        _labelKnownMovies = [lblKnownMovies retain];
        [self addSubview:_labelKnownMovies];
        [lblKnownMovies release];
        
        
        // birthplace
        UILabel *lblPropBirthday = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+54, pwidth, 15)];
        lblPropBirthday.backgroundColor = [UIColor clearColor];
        lblPropBirthday.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropBirthday.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropBirthday.opaque = YES;
        lblPropBirthday.numberOfLines = 1;
        [lblPropBirthday setText:NSLocalizedString(@"Birthday:", @"Birthday:")];
        [self addSubview:lblPropBirthday];
        
        UILabel *lblBirthday = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+54, mframe.size.width-pwidth, 15)];
        lblBirthday.backgroundColor = [UIColor clearColor];
        lblBirthday.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblBirthday.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblBirthday.opaque = YES;
        lblBirthday.numberOfLines = 1;
        
        _labelBirthday = [lblBirthday retain];
        [self addSubview:_labelBirthday];
        [lblBirthday release];
        
        // birthplace
        UILabel *lblPropBirthplace = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x, mframe.origin.y+69, pwidth, 15)];
        lblPropBirthplace.backgroundColor = [UIColor clearColor];
        lblPropBirthplace.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblPropBirthplace.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblPropBirthplace.opaque = YES;
        lblPropBirthplace.numberOfLines = 1;
        [lblPropBirthplace setText:NSLocalizedString(@"Birthplace:", @"Birthplace:")];
        [self addSubview:lblPropBirthplace];
        
        UILabel *lblBirthplace = [[UILabel alloc] initWithFrame:CGRectMake(mframe.origin.x+pwidth, mframe.origin.y+69, mframe.size.width-pwidth, 15)];
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
            profile = a.url;
            break;
        }
    }
    
    
    // header
    [_imageProfile loadFromURL:profile];
    [_labelName setText:person.name];
    [_labelBirthday setText:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:person.birthday]]];
    [_labelBirthplace setText:person.birthplace];
    [_labelKnownMovies setText:[NSString stringWithFormat:@"%i",[person.known_movies intValue]]];
    
}


#pragma mark -
#pragma mark Memory

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    
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
