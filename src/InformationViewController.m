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


/**
 * Section Stack.
 */
@interface InformationViewController (SectionStack)
- (UIView *)sectionHeader:(NSString*)label;
- (UIView *)sectionFooter;
@end



/**
 * Action Stack.
 */
@interface InformationViewController (SwapStack)
- (void)swapListing;
- (void)swapInformation;
- (void)swapIMDb;
- (void)swapWikipedia;
- (void)swapReset;
@end


#pragma mark -
#pragma mark InformationViewController
#pragma mark -

/**
 * InformationViewController.
 */
@implementation InformationViewController

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize modalView = _modalView;
@synthesize contentView = _contentView;
@synthesize movies = _movies;
@synthesize actors = _actors;
@synthesize directors = _directors;
@synthesize crew = _crew;


// local vars
CGRect vframe;
float informationHeaderHeight = 110;
float informationFooterHeight = 60;


// sections
int cellHeight = 36;
int cellInset = 15;
int informationGapHeight = 39;
int informationGapOffset = 10;
int informationGapInset = 15;


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
        
        // modes
        mode_listing = NO;
        mode_information = NO;
        mode_imdb = NO;
        mode_wikipedia = NO;

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
    CGRect wframe = window.frame;
    CGRect cframe = CGRectMake(wframe.size.width/2.0-vframe.size.width/2.0, wframe.size.height/2.0-vframe.size.height/2.0, vframe.size.width, vframe.size.height);
    CGRect hframe = CGRectMake(0, 0, cframe.size.width, informationHeaderHeight);
    CGRect fframe = CGRectMake(0, cframe.size.height-informationFooterHeight, cframe.size.width, informationFooterHeight);
    CGRect tframe = CGRectMake(0, informationHeaderHeight, cframe.size.width, cframe.size.height-informationHeaderHeight-informationFooterHeight);
    CGRect aframe = CGRectMake(informationGapInset, informationGapOffset, fframe.size.width-2*informationGapInset, fframe.size.height-2*informationGapOffset);
    
    
    // view
    self.view = [[UIView alloc] initWithFrame:wframe];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.hidden = YES;
    
    // modal
    UIView *mView = [[UIView alloc] initWithFrame:wframe];
    mView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mView.backgroundColor = [UIColor blackColor];
    mView.opaque = NO;
    mView.alpha = 0.3;
    self.modalView = [mView retain];
    [self.view addSubview:_modalView];
    [mView release];

	
	// content
    InformationBackgroundView *ctView = [[InformationBackgroundView alloc] initWithFrame:cframe];
    
    
    // header view
    InformationMovieView *nfoMovieView = [[InformationMovieView alloc] initWithFrame:hframe];
    nfoMovieView.tag = TagInformationMovie;
    nfoMovieView.hidden = YES;
    
    InformationPersonView *nfoPersonView = [[InformationPersonView alloc] initWithFrame:hframe];
    nfoPersonView.tag = TagInformationMovie;
    nfoPersonView.hidden = YES;
    
    // drop that shadow
	CAGradientLayer *dropShadow = [[[CAGradientLayer alloc] init] autorelease];
	dropShadow.frame = CGRectMake(0, hframe.size.height, hframe.size.width, 15);
	dropShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.02].CGColor,(id)[UIColor colorWithWhite:0 alpha:0].CGColor,nil];
	[nfoMovieView.layer insertSublayer:dropShadow atIndex:0];
    [nfoPersonView.layer insertSublayer:dropShadow atIndex:0];
    
    // add header view to content
    _informationMovieView = [nfoMovieView retain];
    [ctView addSubview:_informationMovieView];
    [nfoMovieView release];
    
    _informationPersonView = [nfoPersonView retain];
    [ctView addSubview:_informationPersonView];
    [nfoPersonView release];

    
    // table view
    UITableView *listingTableView = [[UITableView alloc] initWithFrame:tframe style:UITableViewStyleGrouped];
    listingTableView.tag = TagInformationContent;
    listingTableView.delegate = self;
    listingTableView.dataSource = self;
	listingTableView.backgroundColor = [UIColor clearColor];
	listingTableView.opaque = YES;
	listingTableView.backgroundView = nil;
    listingTableView.sectionHeaderHeight = 0; 
    listingTableView.sectionFooterHeight = 0;
    
    // add table view to content
    _listingTableView = [listingTableView retain];
    [ctView addSubview:_listingTableView];
    [ctView sendSubviewToBack:_listingTableView];
    [listingTableView release];
    
    
    // footer view
    UIView *footerView = [[UIView alloc] initWithFrame:fframe];
    footerView.autoresizingMask = UIViewAutoresizingNone;
    footerView.tag = TagInformationFooter;
	footerView.backgroundColor = [UIColor clearColor];
	footerView.opaque = YES;
    
    // actions
    ActionBar *abar = [[ActionBar alloc] initWithFrame:aframe];
    
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
    
    ActionBarButtonItem *actionInformation = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_information.png"] 
                                                                                  title:NSLocalizedString(@"Info", @"Info")
                                                                                 target:self 
                                                                                 action:@selector(swapInformation)];
    _actionInformation = [actionInformation retain];
    [actionInformation release];
    
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
    [abar setItems:[NSArray arrayWithObjects:nspace,itemFlex,_actionListing,_actionInformation,_actionIMDb,_actionWikipedia,itemFlex,nspace,nil]];
    [footerView addSubview:abar];
    [itemFlex release];
    
    // add footer view to content
    [ctView addSubview:footerView];
    [footerView release];
    
    
    // add & release content
    self.contentView = [ctView retain];
    [self.view addSubview:_contentView];
    [self.view bringSubviewToFront:_contentView];
    [ctView release];
    
	    
}


/*
 * Resize.
 */
- (void)resize {
    // handled by default ui resize
}


/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // reload
    [_listingTableView reloadData];
    
    // scroll to top
    [_listingTableView setContentOffset:CGPointMake(0, 0) animated:NO];

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
- (void)informationMovie:(NSString *)name poster:(NSString*)poster tagline:(NSString *)tagline overview:(NSString *)overview released:(NSDate *)released runtime:(NSNumber *)runtime trailer:(NSString *)trailer homepage:(NSString *)homepage imdb_id:(NSString *)imdb_id {
    FLog();
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
    }
    
    // show
    _informationPersonView.hidden = YES;
    
    // poster
    [_informationMovieView.imagePoster loadImageFromURL:poster];
    
    // data
    [_informationMovieView.labelName setText:name];
    [_informationMovieView.labelTagline setText:tagline];
    [_informationMovieView.labelReleased setText:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:released]]];
    [_informationMovieView.labelRuntime setText:[NSString stringWithFormat:@"%im",[runtime intValue]]];
    
    // actions
    [_actionListing setTitle:NSLocalizedString(@"Cast", @"Cast")];
    
    // swap listing
    [self swapListing];
    
    // show
    _informationMovieView.hidden = NO;
    
}

/**
 * Information person.
 */
- (void)informationPerson:(NSString *)name profile:(NSString *)profile biography:(NSString *)biography birthday:(NSDate *)birthday birthplace:(NSString *)birthplace known_movies:(NSNumber *)known_movies {
    FLog();
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    // show
    _informationMovieView.hidden = YES;
    
    // profile
    [_informationPersonView.imageProfile loadImageFromURL:profile];
    
    // data
    [_informationPersonView.labelName setText:name];
    [_informationPersonView.labelBirthday setText:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:birthday]]];
    [_informationPersonView.labelBirthplace setText:birthplace];
    [_informationPersonView.labelKnownMovies setText:[NSString stringWithFormat:@"%i",[known_movies intValue]]];
    
    
    // actions
    [_actionListing setTitle:NSLocalizedString(@"Movies", @"Movies")];
    
    // swap listing
    [self swapListing];
    
    // show
    _informationPersonView.hidden = NO;
    
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
        
        // views
        _listingTableView.hidden = NO;
    }

}

/*
 * Swap information.
 */
- (void)swapInformation {
    FLog();
    
    // change mode
    if (! mode_information) {
        
        // reset
        [self swapReset];
        
        // mode
        mode_information = YES;
        
        // action
        [_actionInformation setSelected:YES];
        

    }
}

/*
 * Swap imdb.
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
        
    }
}

/*
 * Swap reset.
 */
- (void)swapReset {
    FLog();
    
    // reset mode
    mode_listing = NO;
    mode_information = NO;
    mode_imdb = NO;
    mode_wikipedia = NO;
    
    // actions
    [_actionListing setSelected:NO];
    [_actionInformation setSelected:NO];
    [_actionIMDb setSelected:NO];
    [_actionWikipedia setSelected:NO];
    
    // hide views
    _listingTableView.hidden = YES;
    
}


#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 4;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // section
    switch (section) {
		case SectionInformationMovies: {
			return [_movies count];
            break;
		}
        case SectionInformationActors: {
			return [_actors count];
            break;
		}
        case SectionInformationDirectors: {
			return [_directors count];
            break;
		}
		case SectionInformationCrew: {
			return [_crew count];
            break;
		}
        
    }
    
    return 0;
}


/*
 * Customize the section header height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section]==0) {
        return 0.0000000000000000000000000001; // null is ignored...
    }
    return informationGapHeight;
}

/*
 * Customize the section footer height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionInformationCrew) {
        return informationGapInset;
    }
    else if ([self tableView:tableView numberOfRowsInSection:section]==0) {
        return 0.0000000000000000000000000001; // null is ignored...
    }
    return 1;
}

/*
 * Customize the cell height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

/*
 * Customize the section header.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // filler
    if ([self tableView:tableView numberOfRowsInSection:section]==0) {
        return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    // header
    else {
        return [self sectionHeader:[self tableView:tableView titleForHeaderInSection:section]];
    }
}
- (UIView *)sectionHeader:(NSString*)label {
    
    // view
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vframe.size.width, informationGapHeight)];
    
    // label
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(informationGapInset, informationGapOffset, shView.frame.size.width-2*informationGapInset, informationGapHeight-informationGapOffset)];
	lblHeader.backgroundColor = [UIColor clearColor];
	lblHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblHeader.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblHeader.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblHeader.shadowOffset = CGSizeMake(1,1);
	lblHeader.opaque = YES;
	lblHeader.numberOfLines = 1;
    
    // text
    lblHeader.text = label;
    
    // add & release
    [shView addSubview:lblHeader];
    [lblHeader release];
    
    // and back
    return shView;
}

/*
 * Customize the footer view.
 */
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // filler
    if ([self tableView:tableView numberOfRowsInSection:section]==0) {
        return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    // header
    else {
        return [self sectionFooter];
    }
}
- (UIView *)sectionFooter{
    
    // view
    UIView *sfView = [[UIView alloc] initWithFrame:vframe];
    
    // view
    UIView *sfLine = [[UIView alloc] initWithFrame:CGRectMake(informationGapInset, -1, 550, 1)];
    sfLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:0.6];
    
    // add & release
    [sfView addSubview:sfLine];
    [sfLine release];

    
    // and back
    return sfView;
}


#pragma mark -
#pragma mark UITableViewDelegate Protocol

/*
 * Section titles.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// section
    switch (section) {
		case SectionInformationMovies: {
			if ([_movies count] > 0)  return NSLocalizedString(@"Movies",@"Movies");
            break;
		}
        case SectionInformationActors: {
			if ([_actors count] > 0)  return NSLocalizedString(@"Actors",@"Actors");
            break;
		}
        case SectionInformationDirectors: {
			if ([_directors count] > 0)  return NSLocalizedString(@"Directors",@"Directors");
            break;
		}
		case SectionInformationCrew: {
			if ([_crew count] > 0)  return NSLocalizedString(@"Crew",@"Crew");
            break;
		}
    }
    return nil;
    
}


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellInformationIdentifier = @"CellInformation";
	
	// create cell
	InformationCell *cell = (InformationCell*) [tableView dequeueReusableCellWithIdentifier:CellInformationIdentifier];
	if (cell == nil) {
		cell = [[[InformationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellInformationIdentifier] autorelease];
	}
	
	// info
	Information *nfo;
	if ([indexPath section] == SectionInformationMovies) {
		nfo = [_movies objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionInformationActors) {
		nfo = [_actors objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionInformationDirectors) {
		nfo = [_directors objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionInformationCrew) {
		nfo = [_crew objectAtIndex:[indexPath row]];
	}

    
    // label
	cell.labelInfo.text = nfo.value;
	cell.labelMeta.text = nfo.meta;
    cell.type = nfo.type;
    cell.loaded = NO;
    cell.visible = NO;
    if (nfo.loaded) {
        cell.loaded = YES;
    }
    if (nfo.visible) {
        cell.visible = YES;
    }
    [cell setNeedsDisplay];

	// return
    return cell;
    
}


/*
 * Called when a table cell is selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FLog();

    // nfo
	Information *nfo;
	if ([indexPath section] == SectionInformationMovies) {
		nfo = [_movies objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionInformationActors) {
		nfo = [_actors objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionInformationDirectors) {
		nfo = [_directors objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionInformationCrew) {
		nfo = [_crew objectAtIndex:[indexPath row]];
	}
    
    // check
    if (! nfo.loaded) {
        
        // state
        nfo.loaded = YES;
        [_listingTableView reloadData];
        
        // load
        if (delegate && [delegate respondsToSelector:@selector(informationSelected:type:)]) {
            NSString *type = [nfo.type isEqualToString:typeMovie] ? typeMovie : typePerson;
            [delegate informationSelected:nfo.nid type:type];
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
    
    // data
	[_movies release];
    [_actors release];
    [_directors release];
	[_crew release];
    
    // actions
    [_actionListing release];
    [_actionInformation release];
    [_actionIMDb release];
    [_actionWikipedia release];
    
    // listing
    [_listingTableView release];
	
	// duper
    [super dealloc];
}


@end



#pragma mark -
#pragma mark Information
#pragma mark -


/**
 * Information.
 */
@implementation Information

#pragma mark -
#pragma mark Properties

// accessors
@synthesize value;
@synthesize meta;
@synthesize type;
@synthesize nid;
@synthesize loaded;
@synthesize visible;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initWithValue:(NSString *)v meta:(NSString *)m type:(NSString *)t nid:(NSNumber *)n visible:(bool)iv loaded:(bool)il{
    GLog();
    if ((self = [super init])) {
		self.value = v;
		self.meta = m;
		self.type = t;
        self.nid = n;
        self.visible = iv;
        self.loaded = il;
		return self;
	}
	return nil;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[value release];
	[meta release];
	[type release];
    [nid release];
	
	// super
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
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
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
    GLog();
    
    // scroll to top
    UITableView *tv = (UITableView*) [self viewWithTag:TagInformationContent];
    [tv setContentOffset:CGPointMake(0, 0) animated:YES];
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
#pragma mark Properties

// accessors
@synthesize labelName = _labelName;
@synthesize labelTagline = _labelTagline;
@synthesize labelReleased = _labelReleased;
@synthesize labelRuntime = _labelRuntime;
@synthesize imagePoster = _imagePoster;


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


@end




#pragma mark -
#pragma mark InformationPersonView
#pragma mark -

/**
 * InformationPersonView.
 */
@implementation InformationPersonView


#pragma mark -
#pragma mark Properties

// accessors
@synthesize labelName = _labelName;
@synthesize labelBirthday = _labelBirthday;
@synthesize labelBirthplace = _labelBirthplace;
@synthesize labelKnownMovies = _labelKnownMovies;
@synthesize imageProfile = _imageProfile;


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


@end



#pragma mark -
#pragma mark InformationCell
#pragma mark -

/**
 * InformationCell.
 */
@implementation InformationCell


#pragma mark -
#pragma mark Properties

// accessors
@synthesize labelInfo=_labelInfo;
@synthesize labelMeta=_labelMeta;
@synthesize type=_type;
@synthesize loaded, visible;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    // init
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        // background
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        // intendation
        self.indentationWidth = informationGapInset;
        self.indentationLevel = 0;
        
        
        // back
        UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = backView;
        
        
        // labels
        UILabel *lblInfo = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        lblInfo.backgroundColor = [UIColor clearColor];
        lblInfo.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblInfo.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
        lblInfo.opaque = YES;
        lblInfo.numberOfLines = 1;
        
        _labelInfo = [lblInfo retain];
        [self.contentView addSubview: _labelInfo];
        [lblInfo release];
        
        UILabel *lblMeta = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        lblMeta.backgroundColor = [UIColor clearColor];
        lblMeta.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblMeta.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblMeta.opaque = YES;
        lblMeta.numberOfLines = 1;
        
        _labelMeta = [lblMeta retain];
        [self.contentView addSubview: lblMeta];
        [lblMeta release];
        
        // icons
        CGRect iframe = CGRectMake(0, 0, 16, 16);
        
		_iconMovie = [[UIImageView alloc] initWithFrame:iframe];
		_iconMovie.image = [UIImage imageNamed:@"icon_mini_movie.png"];
		_iconMovie.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_iconMovie.backgroundColor = [UIColor clearColor];
		_iconMovie.contentMode = UIViewContentModeCenter;
        _iconMovie.hidden = YES;
        [self.contentView addSubview: _iconMovie];
        
        _iconActor = [[UIImageView alloc] initWithFrame:iframe];
		_iconActor.image = [UIImage imageNamed:@"icon_mini_actor.png"];
		_iconActor.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_iconActor.backgroundColor = [UIColor clearColor];
		_iconActor.contentMode = UIViewContentModeCenter;
        _iconActor.hidden = YES;
        [self.contentView addSubview: _iconActor];
        
        _iconDirector = [[UIImageView alloc] initWithFrame:iframe];
		_iconDirector.image = [UIImage imageNamed:@"icon_mini_director.png"];
		_iconDirector.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_iconDirector.backgroundColor = [UIColor clearColor];
		_iconDirector.contentMode = UIViewContentModeCenter;
        _iconDirector.hidden = YES;
        [self.contentView addSubview: _iconDirector];
        
        _iconCrew = [[UIImageView alloc] initWithFrame:iframe];
		_iconCrew.image = [UIImage imageNamed:@"icon_mini_crew.png"];
		_iconCrew.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_iconCrew.backgroundColor = [UIColor clearColor];
		_iconCrew.contentMode = UIViewContentModeCenter;
        _iconCrew.hidden = YES;
        [self.contentView addSubview: _iconCrew];
        
    }
    return self;
}

#pragma mark -
#pragma mark TableCell Methods

/*
 * Draws the cell.
 */
- (void)drawRect:(CGRect)rect {
    //[super drawRect:rect];
	
    // get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    //CGContextSetShouldAntialias(ctx, NO);
    
    // background
    CGRect bg = CGRectMake(cellInset, 0, self.frame.size.width-2*cellInset, cellHeight+1);
    UIColor *bgc = self.highlighted ? [UIColor colorWithWhite:0 alpha:0.06] : [UIColor colorWithWhite:0 alpha:0.03];
    CGContextSetFillColorWithColor(ctx, bgc.CGColor);
	CGContextFillRect(ctx, bg);
    
    // lines
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(ctx, bg.origin.x, 0);
	CGContextAddLineToPoint(ctx, bg.origin.x+bg.size.width, 0);
	CGContextStrokePath(ctx);
    
}


/* 
 * Sub stuff.
*/
- (void) layoutSubviews {

    // size
    [_labelInfo sizeToFit];
    [_labelMeta sizeToFit];
    
    // position
    CGRect finfo = _labelInfo.frame;
    finfo.origin.x = CGRectGetMinX (self.contentView.bounds) + 12;
    finfo.origin.y = CGRectGetMinY (self.contentView.bounds) + 9;
    [_labelInfo setFrame: finfo];
    
    // meta
    CGRect fmeta = _labelMeta.frame;
    fmeta.origin.x = CGRectGetMaxX (_labelInfo.frame) + 10;
    fmeta.origin.y = CGRectGetMinY (self.contentView.bounds) + 9;
    [_labelMeta setFrame: fmeta];
    
    // disclosure
    CGRect fdisc = CGRectMake(self.frame.size.width-50, 9, 16, 16);
    _iconMovie.hidden = YES;
    _iconActor.hidden = YES;
    _iconDirector.hidden = YES;
    _iconCrew.hidden = YES;
    if (loaded) {
        
        // movie
        if ([_type isEqualToString:typeMovie]) {
            _iconMovie.frame = fdisc;
            _iconMovie.hidden = NO;
        }
        // actor
        else if ([_type isEqualToString:typePersonActor]) {
            _iconActor.frame = fdisc;
            _iconActor.hidden = NO;
        }
        // crew
        else if ([_type isEqualToString:typePersonDirector]) {
            _iconDirector.frame = fdisc;
            _iconDirector.hidden = NO;
        }
        // crew
        else if ([_type isEqualToString:typePersonCrew]) {
            _iconCrew.frame = fdisc;
            _iconCrew.hidden = NO;
        }
        

    }

}


/*
* Disable highlighting of currently selected cell.
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

/*
 * Highlight.
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:NO];
    [self setNeedsDisplay];
}

 




#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	FLog();
	
	// super
    [super dealloc];
}


@end

