//
//  ListingView.m
//  IMDG
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "ListingView.h"
#import "IMDGConstants.h"
#import "DataNode.h"


/**
 * Section Stack.
 */
@interface ListingView (SectionStack)
- (UIView *)sectionHeader:(NSString*)label;
- (UIView *)sectionFooter;
@end



/**
 * ListingView.
 */
@implementation ListingView

#pragma mark -
#pragma mark Constants


// local vars
static int listingCellHeight = 36;
static int listingCellInset = 15;
static int listingGapHeight = 39;
static int listingGapOffset = 10;
static int listingGapInset = 15;


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id) initWithFrame:(CGRect)frame {
	GLog();
	
	// init UIView
    self = [super initWithFrame:frame];
	
	// init HTMLView
    if (self != nil) {
        
        // view
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        
        // table view
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.opaque = YES;
        tableView.backgroundView = nil;
        tableView.sectionHeaderHeight = 0; 
        tableView.sectionFooterHeight = 0;
        
        // add listing to content
        _tableView = [tableView retain];
        [self addSubview:_tableView];
        [tableView release];
        
        // data
        _movies = [[NSMutableArray alloc] init];
        _actors = [[NSMutableArray alloc] init];
        _directors = [[NSMutableArray alloc] init];
        _crew = [[NSMutableArray alloc] init];
        
    }
    return self; 
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    
    // table view
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


#pragma mark -
#pragma mark Interface

/**
 * Reset.
 */
- (void)reset:(NSArray*)nodes {
	FLog();
    
    // data
    [_movies removeAllObjects];
    [_actors removeAllObjects];
    [_directors removeAllObjects];
    [_crew removeAllObjects];
    
    // nodes
    for (DataNode *dta in nodes) {
        
        // movie
        if ([dta.type isEqualToString:typeMovie]) {
            [_movies addObject:dta];
        }
        
        // actor
        else if ([dta.edge.type isEqualToString:typePersonActor]) {
            [_actors addObject:dta];
        }
        
        // director
        else if ([dta.edge.type isEqualToString:typePersonDirector]) {
            [_directors addObject:dta];
        }
        
        // crew
        else if ([dta.edge.type isEqualToString:typePersonCrew]) {
            [_crew addObject:dta];
        }
    }
    
    // reload
    [_tableView reloadData];
    
    
}

/**
 * Loads the default home.
 */
- (void)load {
    FLog();
    
    // reload
    [_tableView reloadData];

}


/**
 * Scroll to top.
 */
- (void)scrollTop:(bool)animated {
    FLog();
    
    // scrolling 
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:animated];

}


/*
 * Resize.
 */
- (void)resize {
    
    // scroll to top (reloads data)
    [self scrollTop:NO];
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
		case SectionListingMovies: {
			return [_movies count];
            break;
		}
        case SectionListingActors: {
			return [_actors count];
            break;
		}
        case SectionListingDirectors: {
			return [_directors count];
            break;
		}
		case SectionListingCrew: {
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
    return listingGapHeight;
}

/*
 * Customize the section footer height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionListingMovies) {
        return listingGapInset;
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
    return listingCellHeight;
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
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, listingGapHeight)];
    
    // label
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(listingGapInset, listingGapOffset, shView.frame.size.width-2*listingGapInset, listingGapHeight-listingGapOffset)];
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
    // footer
    else {
        return [self sectionFooter];
    }
}
- (UIView *)sectionFooter{
    
    // view
    UIView *sfView = [[UIView alloc] initWithFrame:self.frame];
    
    // view
    UIView *sfLine = [[UIView alloc] initWithFrame:CGRectMake(listingGapInset, -1, self.frame.size.width-2*listingGapInset, 1)];
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
		case SectionListingMovies: {
			if ([_movies count] > 0)  return NSLocalizedString(@"Movies",@"Movies");
            break;
		}
        case SectionListingActors: {
			if ([_actors count] > 0)  return NSLocalizedString(@"Actors",@"Actors");
            break;
		}
        case SectionListingDirectors: {
			if ([_directors count] > 0)  return NSLocalizedString(@"Directors",@"Directors");
            break;
		}
		case SectionListingCrew: {
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
    static NSString *CellListingIdentifier = @"CellListing";
	
	// create cell
	ListingCell *cell = (ListingCell*) [tableView dequeueReusableCellWithIdentifier:CellListingIdentifier];
	if (cell == nil) {
		cell = [[[ListingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellListingIdentifier] autorelease];
	}
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
    }
	
	// info
	DataNode *dta;
	if ([indexPath section] == SectionListingMovies) {
		dta = [_movies objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionListingActors) {
		dta = [_actors objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionListingDirectors) {
		dta = [_directors objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionListingCrew) {
		dta = [_crew objectAtIndex:[indexPath row]];
	}
    
    // label
    NSString *nfo = dta.label;
    if ([indexPath section] == SectionListingMovies && ! [dta.meta isEqualToString:@""]) {
        nfo = [NSString stringWithFormat:@"%@ (%@)",dta.label,dta.meta];
    }
    
    
    // label
	cell.labelInfo.text = nfo;
	cell.labelMeta.text = dta.edge.label;
    cell.type = dta.type;
    cell.loaded = NO;
    cell.visible = NO;
    if (dta.loaded) {
        cell.loaded = YES;
    }
    if (dta.visible) {
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
	DataNode *dta;
	if ([indexPath section] == SectionListingMovies) {
		dta = [_movies objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionListingActors) {
		dta = [_actors objectAtIndex:[indexPath row]];
	}
    else if ([indexPath section] == SectionListingDirectors) {
		dta = [_directors objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionListingCrew) {
		dta = [_crew objectAtIndex:[indexPath row]];
	}
    
    // check
    if (! dta.loaded) {
        
        // state
        dta.loaded = YES;
        [_tableView reloadData];
        
        // load
        if (delegate && [delegate respondsToSelector:@selector(listingSelected:type:)]) {
            NSString *type = [dta.type isEqualToString:typeMovie] ? typeMovie : typePerson;
            [delegate listingSelected:dta.nid type:type];
        }
    }
}




#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	
	// superduper
	[super dealloc];
}



@end



/**
 * ListingCell.
 */
@implementation ListingCell


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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    // init
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        // background
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        // intendation
        self.indentationWidth = listingGapInset;
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
    CGRect bg = CGRectMake(listingCellInset, 0, self.frame.size.width-2*listingCellInset, listingCellHeight+1);
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
    finfo.origin.x = CGRectGetMinX (self.contentView.bounds) + listingCellInset + 5;
    finfo.origin.y = CGRectGetMinY (self.contentView.bounds) + 9;
    [_labelInfo setFrame: finfo];
    
    // meta
    CGRect fmeta = _labelMeta.frame;
    fmeta.origin.x = CGRectGetMaxX (_labelInfo.frame) + 10;
    fmeta.origin.y = CGRectGetMinY (self.contentView.bounds) + 9;
    [_labelMeta setFrame: fmeta];
    
    // disclosure
    CGRect fdisc = CGRectMake(self.frame.size.width-listingCellInset-25, 9, 16, 16);
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
	GLog();
	
	// super
    [super dealloc];
}

@end

