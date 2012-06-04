//
//  DBDataViewController.m
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

#import "DBDataViewController.h"
#import "CellSearch.h"
#import "SolyarisConstants.h"
#import "Tracker.h"

/**
 * Animation Stack.
 */
@interface DBDataViewController (AnimationStack)
- (void)animationScrollResults:(NSIndexPath*)ip;
@end


/**
 * DBDataViewController.
 */
@implementation DBDataViewController


#pragma mark -
#pragma mark Constants

// constants
#define kDabaDataScrollDelay      0.45


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize header;


#pragma mark -
#pragma mark View lifecycle


/*
 * Load.
 */
- (void)loadView {
    [super loadView];
    FLog();
   
    // data
    NSMutableArray *dta = [[NSMutableArray alloc] init];
    _data = [dta retain];
    [dta release];
    
    // self
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews = YES;
    
    // frames
    CGRect fHeader = CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight);
    CGRect fContent = CGRectMake(0, kHeaderHeight, self.view.frame.size.width, self.view.frame.size.height-kHeaderHeight);
    
    // header
    HeaderView *hdr = [[HeaderView alloc] initWithFrame:fHeader];
    header = [hdr retain];
    [self.view addSubview:header];
    [hdr release];
    
    // results
    UITableView *results = [[UITableView alloc] initWithFrame:fContent style:UITableViewStylePlain];
    results.delegate = self;
    results.dataSource = self;
    results.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    results.hidden = YES;
    
    _results = [results retain];
    [self.view addSubview:_results];
    [results release];
    
    // loader
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loader.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    loader.center = CGPointMake(self.view.frame.size.width/2.0, (self.view.frame.size.height/2.0));
    loader.hidden = YES;
    
    _loader = [loader retain];
    [self.view addSubview:_loader];
    [loader release];
    
    // not found
    SearchNotfoundView *notfound = [[SearchNotfoundView alloc] initWithFrame:fContent];
    notfound.hidden = YES;
    
    _notfound = [notfound retain];
    [self.view addSubview:_notfound];
    [notfound release];
    
    // error
    UIView *error = [[UIView alloc] initWithFrame:fContent];
    error.backgroundColor = [UIColor clearColor];
    error.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    error.hidden = YES;
    
    UILabel *lblError = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fContent.size.width, 45)];
    lblError.backgroundColor = [UIColor clearColor];
    lblError.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lblError.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblError.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    lblError.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    lblError.shadowOffset = CGSizeMake(1,1);
    [lblError setText:NSLocalizedString(@"Something went wrong.", @"Something went wrong.")];
    
    [error addSubview:lblError];
    [lblError release];
    
    _error = [error retain];
    [self.view addSubview:_error];
    [error release];
    
    // reset
    [self dbDataReset];
    
}




#pragma mark -
#pragma mark Business

/**
 * Resets the controller.
 */
- (void)reset {
    GLog();
    
    // reset modes
    mode_reset = NO;
    mode_loading = NO;
    mode_result = NO;
    mode_notfound = NO;
    mode_error = NO;
    
    // reset data
    [_data removeAllObjects];
    
    
    // reset ui
    [_loader stopAnimating];
    _loader.hidden = YES;
    _results.hidden = YES;
    _notfound.hidden = YES;
    _error.hidden = YES;
}

/**
 * Updates the controller.
 */
- (void)update {
    GLog();
    
    // loading
    if (mode_loading) {
        
        // show results 
        [self.view bringSubviewToFront:_results];
        _results.hidden = NO;
        [_results reloadData];
        
        // loader
        [_loader startAnimating];
        _loader.center = CGPointMake(self.view.frame.size.width/2.0,kHeaderHeight+24);
        [self.view bringSubviewToFront:_loader];
        _loader.hidden = NO;
    }
    
    // found
    if (mode_result) {
        
        // show results 
        [self.view bringSubviewToFront:_results];
        _results.hidden = NO;
        [_results reloadData];
    }
    
    // notfound
    if (mode_notfound) {
        
        // show not found
        [self.view bringSubviewToFront:_notfound];
        _notfound.hidden = NO;
    }
    
    // error
    if (mode_error) {
        
        // head
        [self.header head:NSLocalizedString(@"Ooops", @"Ooops")];
        _error.hidden = NO;
    }
    
    // layout
    [self.view setNeedsLayout];
}


/**
 * Resets the data.
 */
- (void)dbDataReset {
    GLog();
    
    // check
    if (! mode_reset) {
        
        // reset
        [self reset];
        mode_reset = YES;
        
        // update
        [self update];
    }
    
}


/**
 * Shows the loader.
 */
- (void)dbDataLoading {
    FLog();
    
    // title
    [self.header head:NSLocalizedString(@"Loading...", @"Loading...")];
    
    // reset & update
    [self reset];
    mode_loading = YES;
    [self update];
}

/**
 * Shows the search results.
 */
- (void)dbSearchResult:(Search *)search {
    FLog();
    
    // reset
    [self reset];
    
    // check for null
    if (search == NULL) {
        
        // in the moode
        mode_error = YES;
        
        // update
        [self update];
        
        // nothing
        return;
    }
    
    // data
    for (SearchResult* s in search.results) {
        
        // data
        DBData *dta = [[DBData alloc] initData:DBDataSearchResult ref:s.ref type:s.type label:s.data thumb:s.thumb];
        
        // add
        [_data addObject:dta];
        [dta release];
    }
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:TRUE];
	[_data sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    

    // title
    if ([search.type isEqualToString:typePerson]) {
        [self.header head:[NSString stringWithFormat:@"%i %@",[_data count], ([_data count] == 1 ? NSLocalizedString(@"Person", @"Person") : NSLocalizedString(@"People", @"People"))]];
    }
    else {
        [self.header head:[NSString stringWithFormat:@"%i %@",[_data count], ([_data count] == 1 ? NSLocalizedString(@"Movie", @"Movie") : NSLocalizedString(@"Movies", @"Movies"))]];
    }
    
    // found
    if ([_data count] > 0) {
        
        // flag
        mode_result = YES;
    }
    else {
        [_notfound.labelMessage setText:[NSString stringWithFormat:@"%@ «%@»",NSLocalizedString(@"No results for", @"No results for"),search.query]];
        mode_notfound = YES;
    }
    
    // update
    [self update];
}


/**
 * Shows the popular results.
 */
- (void)dbPopularResult:(Popular *)popular more:(BOOL)more {
    FLog();
    
    // current
    int current = [_data count] > 0 ? [_data count]-1 : 0;
    
    // reset
    if (more) {
        
        // remove
        [_data removeLastObject];
        [_results deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:current inSection:SectionDBDataResults]] withRowAnimation:UITableViewRowAnimationNone];

    }
    else {
        
        // reset
        [self reset];
    }
    
    // check for null
    if (popular == NULL || [popular.results count] <= 0) {
        
        // in the moode
        mode_error = YES;
        
        // update
        [self update];
        
        // nothing
        return;
    }
    
    // results
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[popular.results allObjects]];
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:TRUE];
	[results sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    // data
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (int i = current; i < [results count]; i++) {
        
        // popular
        PopularResult *p = (PopularResult*) [results objectAtIndex:i];
        
        // data
        DBData *dta = [[DBData alloc] initData:DBDataPopularMovies ref:p.ref type:p.type label:p.data thumb:p.thumb];
        dta.sort = p.sort;
        
        // add
        [_data addObject:dta];
        [dta release];
        
        // index
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:SectionDBDataResults]];
    }
    [results release];
    
    // more
    int nb = [_data count];
    if ([popular.parsed intValue] < [popular.total intValue]) {
        
        // always more
        DBData *dta = [[DBData alloc] init];
        dta.dta = DBDataPopularMovies;
        dta.ref = [NSNumber numberWithInt:0];
        dta.sort = [NSNumber numberWithInt:[_data count]];
        dta.label = NSLocalizedString(@"Load more movies", @"Load more movies");
        dta.type = popular.type;
        dta.more = YES;
        
        // add
        [_data addObject:dta];
        [dta release];
        
        // index
        [indexes addObject:[NSIndexPath indexPathForRow:nb-1 inSection:SectionDBDataResults]];
    }
    
    
    // title
    if ([popular.type isEqualToString:typeMovie]) {
        [self.header head:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"Popular Movies", @"Popular Movies"),nb]];
    }
    else if ([popular.type isEqualToString:typePerson]) {
        [self.header head:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"Popular People", @"Popular People"),nb]];
    }
    
    // flag
    mode_result = YES;
    
    // update
    if (more) {
        
        // insert
        [_results insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
        
        // scroll
        [self performSelector:@selector(animationScrollResults:) withObject:[NSIndexPath indexPathForRow:MAX(0,current-1) inSection:SectionDBDataResults] afterDelay:kDabaDataScrollDelay];
    }
    else {
        [self update];
    }
    [indexes release];

}



/**
 * Shows the now playing results.
 */
- (void)dbNowPlayingResult:(NowPlaying*)nowplaying more:(BOOL)more {
    FLog();
    
    // current
    int current = [_data count] > 0 ? [_data count]-1 : 0;
    
    // reset
    if (more) {
        
        // remove
        [_data removeLastObject];
        [_results deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:current inSection:SectionDBDataResults]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else {
        
        // reset
        [self reset];
    }
    
    // check for null
    if (nowplaying == NULL || [nowplaying.results count] <= 0) {
        
        // in the moode
        mode_error = YES;
        
        // update
        [self update];
        
        // nothing
        return;
    }
    
    // results
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[nowplaying.results allObjects]];
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:TRUE];
	[results sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    // data
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (int i = current; i < [results count]; i++) {
        
        // now
        NowPlayingResult *np = (NowPlayingResult*) [results objectAtIndex:i];
        
        // data
        DBData *dta = [[DBData alloc] initData:DBDataNowPlaying ref:np.ref type:np.type label:np.data thumb:np.thumb];
        dta.sort = np.sort;
        
        // add
        [_data addObject:dta];
        [dta release];
        
        // index
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:SectionDBDataResults]];
    }
    [results release];
    
    // more
    int nb = [_data count];
    if ([nowplaying.parsed intValue] < [nowplaying.total intValue]) {
        
        // always more
        DBData *dta = [[DBData alloc] init];
        dta.dta = DBDataNowPlaying;
        dta.ref = [NSNumber numberWithInt:0];
        dta.sort = [NSNumber numberWithInt:[_data count]];
        dta.label = NSLocalizedString(@"Load more movies", @"Load more movies");
        dta.type = nowplaying.type;
        dta.more = YES;
        
        // add
        [_data addObject:dta];
        [dta release];
        
        // index
        [indexes addObject:[NSIndexPath indexPathForRow:nb-1 inSection:SectionDBDataResults]];
    }
    
    
    // title
    [self.header head:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"Now Playing", @"Now Playing"),nb]];
    
    // flag
    mode_result = YES;
    
    // update
    if (more) {
        
        // insert
        [_results insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
        
        // scroll
        [self performSelector:@selector(animationScrollResults:) withObject:[NSIndexPath indexPathForRow:MAX(0,current-1) inSection:SectionDBDataResults] afterDelay:kDabaDataScrollDelay];
    }
    else {
        [self update];
    }
    [indexes release];
    
}



/**
 * Shows the history.
 */
- (void)dbHistoryResult:(NSArray *)history type:(NSString *)type {
    FLog();
    
    // reset
    [self reset];
    
    // results
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:history];
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
	[results sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    static NSDateFormatter *yearFormatter;
    if (yearFormatter == nil) {
        yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yyyy"];
    }
    
    // data
    if ([type isEqualToString:typeMovie]) {
        
        // movies
        for (Movie *movie in results) {
            
            // title
            NSString *title = movie.title;
            if (movie.released) {
                title = [NSString stringWithFormat:@"%@ (%@)",title,[yearFormatter stringFromDate:movie.released]];
            }
            
            // thumb
            NSString *thumb = [NSString stringWithString:@""];
            for (Asset *a in movie.assets) {
                
                // poster
                if ([a.type isEqualToString:assetPoster] && [a.size isEqualToString:assetSizeThumb]) { 
                    thumb = a.value;
                    break;
                }
            }
            
            // data
            DBData *dta = [[DBData alloc] initData:DBDataHistory ref:movie.mid type:typeMovie label:title thumb:thumb];
            
            // add
            [_data addObject:dta];
            [dta release];
        }
    }
    else if ([type isEqualToString:typePerson]) {
        
        // person
        for (Person *person in results) {
            
            // thumb
            NSString *thumb = [NSString stringWithString:@""];
            for (Asset *a in person.assets) {
                
                // poster
                if ([a.type isEqualToString:assetProfile] && [a.size isEqualToString:assetSizeThumb]) { 
                    thumb = a.value;
                    break;
                }
            }
            
            // data
            DBData *dta = [[DBData alloc] initData:DBDataHistory ref:person.pid type:typePerson label:person.name thumb:thumb];
            
            // add
            [_data addObject:dta];
            [dta release];
        }
    }
    [results release];
    
    
    
    // title
    if ([type isEqualToString:typeMovie]){
        [self.header head:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"Movie History", @"Movie History"),[history count]]];
    }
    else if ([type isEqualToString:typePerson]) {
        [self.header head:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"People History", @"People History"),[history count]]];
    }
    
    // flag
    mode_result = YES;
    
    // update
    [self update];
    
}

/**
 * Shows the related movies.
 */
- (void)dbMovieRelated:(Movie *)movie more:(BOOL)more {
    FLog();
    
    // current
    int current = [_data count] > 0 ? [_data count]-1 : 0;
    
    // reset
    if (more) {
        
        // remove
        [_data removeLastObject];
        [_results deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:current inSection:SectionDBDataResults]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else {
        
        // reset
        [self reset];
    }
    
    // check for null
    if (movie == NULL || movie.similar == NULL || [movie.similar.movies count] <= 0) {
        
        // in the moode
        mode_error = YES;
        
        // update
        [self update];
        
        // nothing
        return;
    }
    
    // results
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[movie.similar.movies allObjects]];
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:TRUE];
	[results sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    // data
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (int i = current; i < [results count]; i++) {
        
        // similar
        SimilarMovie *sm = (SimilarMovie*) [results objectAtIndex:i];
        
        // data
        DBData *dta = [[DBData alloc] initData:DBDataMovieRelated ref:sm.mid type:typeMovie label:sm.title thumb:sm.thumb];
        dta.src = movie.mid;
        dta.sort = sm.sort;
        
        // add
        [_data addObject:dta];
        [dta release];
        
        // index
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:SectionDBDataResults]];
    }
    [results release];
    
    // more
    int nb = [_data count];
    if ([movie.similar.parsed intValue] < [movie.similar.total intValue]) {
        
        // always more
        DBData *dta = [[DBData alloc] init];
        dta.dta = DBDataMovieRelated;
        dta.src = movie.mid;
        dta.sort = [NSNumber numberWithInt:[_data count]];
        dta.label = NSLocalizedString(@"Load more movies", @"Load more movies");
        dta.type = typeMovie;
        dta.more = YES;
        
        // add
        [_data addObject:dta];
        [dta release];
        
        // index
        [indexes addObject:[NSIndexPath indexPathForRow:nb-1 inSection:SectionDBDataResults]];
    }
    
    
    // title
    [self.header head:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"Related Movies", @"Related Movies"),nb]];
    
    // flag
    mode_result = YES;
    
    // update
    if (more) {
        
        // insert
        [_results insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
        
        // scroll
        [self performSelector:@selector(animationScrollResults:) withObject:[NSIndexPath indexPathForRow:MAX(0,current-1) inSection:SectionDBDataResults] afterDelay:kDabaDataScrollDelay];
    }
    else {
        [self update];
    }
    [indexes release];
    
}

/**
 * Hides the back.
 */
- (void)hideBack:(BOOL)hide {
    FLog();
    
    // hide
    header.back = ! hide;
}

/**
 * Sets the title font.
 */
- (void)titleFont:(UIFont*)thaFont {
    [self.header.labelTitle setFont:thaFont];
}



#pragma mark -
#pragma mark Animation

/*
 * Scroll results.
 */
- (void)animationScrollResults:(NSIndexPath *)ip {
    FLog();
    
    // scroll
    [_results scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



#pragma mark -
#pragma mark Table View


/*
 * Sections.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


/*
 * Rows.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

/*
 * Customize the cell height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellSearchHeight;
}


/*
 * Cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLog();
    
    // identifiers
    static NSString *CellSearchResultIdentifier = @"CellSearchResult";
	
	// create cell
	CellSearch *cell = (CellSearch*) [tableView dequeueReusableCellWithIdentifier:CellSearchResultIdentifier];
	if (cell == nil) {
		cell = [[[CellSearch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellSearchResultIdentifier] autorelease];
	}	
    
    // reset
    [cell reset];
    
    // data
    DBData *dta = [_data objectAtIndex:indexPath.row];
    
    // cell
    [cell.labelData setText:dta.label];
    if (dta.more) {
        [cell more];
    }
    else {
        [cell loadThumb:dta.thumb type:dta.type];
    }
    
    
    // return
    return cell;
}

/*
 * Selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLog();
    
    // data
    DBData *dta = [_data objectAtIndex:indexPath.row];
    
    // more
    if (dta.more) {
        
        // cell
        CellSearch *cell = (CellSearch*) [tableView cellForRowAtIndexPath:indexPath];
        [cell.labelData setText:NSLocalizedString(@"Loading...", @"Loading...")];
        [cell loading];
        [cell setNeedsLayout];
        
        // delegate
        if (delegate != nil && [delegate respondsToSelector:@selector(dbDataLoadMore:)]) {
            [delegate dbDataLoadMore:dta];
        }
        
    }
    else {
        
        // delegate
        if (delegate != nil && [delegate respondsToSelector:@selector(dbDataSelected:)]) {
            [delegate dbDataSelected:dta];
        }
    }
    
}



#pragma mark -
#pragma mark Memory management


/*
 * Deallocates used memory.
 */
- (void)dealloc {
    GLog();
    
    // data
    [_data release];
    
    // ui
    [header release];
    [_results release];
    [_loader release];
    [_notfound release];
    
    // super
    [super dealloc];
}



@end




#pragma mark -
#pragma mark SearchNotfoundView
#pragma mark -


/**
 * SearchNotfoundView.
 */
@implementation SearchNotfoundView


#pragma mark -
#pragma mark Properties

// accessors
@synthesize labelMessage = _labelMessage;


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
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.contentMode = UIViewContentModeRedraw; 
        
        
        // message
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        lblMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        lblMessage.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblMessage.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblMessage.shadowOffset = CGSizeMake(1,1);
        lblMessage.opaque = YES;
        lblMessage.numberOfLines = 2;
        lblMessage.textAlignment = UITextAlignmentLeft;
        
        self.labelMessage = lblMessage;
        [self addSubview:_labelMessage];
        [lblMessage release];
        
        
        // logo tmdb
        UIImageView *logoTMDb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_tmdb.png"]]; 
        logoTMDb.contentMode = UIViewContentModeCenter;
        
        _logoTMDb = [logoTMDb retain];
        [self addSubview:_logoTMDb];
        [logoTMDb release];
        
        // info
        UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        lblInfo.backgroundColor = [UIColor clearColor];
        lblInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        lblInfo.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblInfo.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblInfo.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblInfo.shadowOffset = CGSizeMake(1,1);
        lblInfo.opaque = YES;
        lblInfo.numberOfLines = 3;
        lblInfo.textAlignment = UITextAlignmentLeft;
        
        [lblInfo setText:NSLocalizedString(@"TMDb is a free, user driven movie database. Help expanding their collection by adding any missing movie or person. ➝ themoviedb.org", @"TMDb is a free, user driven movie database. Help expanding their collection by adding any missing movie or person. ➝ themoviedb.org")];
        
        _labelInfo = [lblInfo retain];
        [self addSubview:_labelInfo];
        [lblInfo release];
        
        // linkbutton
        LinkButton *lbTMDb = [[LinkButton alloc] initWithFrame:CGRectZero];
        [lbTMDb transparent:YES]; 
        [lbTMDb addTarget:self action:@selector(actionTMDb:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _linkbuttonTMDb = [lbTMDb retain];
        [self addSubview:_linkbuttonTMDb];
        [lbTMDb release];
        
        
	}
	
	// return
	return self;
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    
    // labels
    _labelMessage.frame = CGRectMake(10, 0, self.frame.size.width-20, 44);
    _labelInfo.frame = CGRectMake(50, 44, self.frame.size.width-50, 60);
    
    // tmdb
    _logoTMDb.frame = CGRectMake(0,45,45,60);
    _linkbuttonTMDb.frame = CGRectMake(0, 44, self.frame.size.width, 60);
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
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
	CGContextFillRect(context, mrect);
	
    
	// lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, 44);
	CGContextAddLineToPoint(context, w, 44);
	CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, 106);
	CGContextAddLineToPoint(context, w, 106);
	CGContextStrokePath(context);
    
    
}


#pragma mark -
#pragma mark Actions

/*
 * Action TMDb.
 */
- (void)actionTMDb:(id)sender {
    DLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:@"TMDb" label:@""];
    
    // open
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlTMDbMissing]];
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	FLog();
    
    // self
    [_labelMessage release];
    [_labelInfo release];
    [_logoTMDb release];
    [_linkbuttonTMDb release];
	
	// super
    [super dealloc];
}

@end

