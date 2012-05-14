//
//  ListingView.m
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
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

#import "ListingView.h"
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
    GLog();
    
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
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

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
    return kListingGapHeight;
}

/*
 * Customize the section footer height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionListingMovies) {
        return kListingGapInset;
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
    return kListingCellHeight-1; // compensate anti alias stuff
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
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kListingGapHeight)];
    
    // label
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(kListingGapInset, kListingGapOffset, shView.frame.size.width-2*kListingGapInset, kListingGapHeight-kListingGapOffset)];
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
    UIView *sfLine = [[UIView alloc] initWithFrame:CGRectMake(kListingGapInset, -1, self.frame.size.width-2*kListingGapInset, 1)];
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
    
	// formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
    }
    
    // identifiers
    static NSString *CellListingIdentifier = @"CellListing";
	
	// create cell
	ListingCell *cell = (ListingCell*) [tableView dequeueReusableCellWithIdentifier:CellListingIdentifier];
	if (cell == nil) {
		cell = [[[ListingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellListingIdentifier] autorelease];
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
    
    // thumb
    [cell loadThumb:dta.thumb type:dta.type];
    
    // state
    cell.loaded = NO;
    cell.visible = NO;
    if (dta.loaded) {
        cell.loaded = YES;
    }
    if (dta.visible) {
        cell.visible = YES;
    }
    
    // flush
    [cell update];
    
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
        
        // load
        if (delegate && [delegate respondsToSelector:@selector(listingSelected:type:)]) {
            NSString *type = [dta.type isEqualToString:typeMovie] ? typeMovie : typePerson;
            [delegate listingSelected:dta.nid type:type];
        }
        
        // state
        dta.loaded = YES;
        
        // update
        ListingCell *cell = (ListingCell*) [tableView cellForRowAtIndexPath:indexPath];
        cell.loaded = YES;
        [cell update];
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
    [_tableView release];
    
    // data
	[_movies release];
	[_actors release];
    [_directors release];
    [_crew release];
	
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
        self.indentationWidth = kListingGapInset;
        self.indentationLevel = 0;
        
        
        // back
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = [backView retain];
        [backView release];
        
        
        // labels
        UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        lblInfo.backgroundColor = [UIColor clearColor];
        lblInfo.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblInfo.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
        lblInfo.opaque = YES;
        lblInfo.numberOfLines = 1;
        
        _labelInfo = [lblInfo retain];
        [self.contentView addSubview: _labelInfo];
        [lblInfo release];
        
        UILabel *lblMeta = [[UILabel alloc] initWithFrame:CGRectZero];
        lblMeta.backgroundColor = [UIColor clearColor];
        lblMeta.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblMeta.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        lblMeta.opaque = YES;
        lblMeta.numberOfLines = 1;
        
        _labelMeta = [lblMeta retain];
        [self.contentView addSubview: _labelMeta];
        [lblMeta release];
        
        
        // thumb
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:CGRectZero];
        [[ciView imageView] setContentMode:UIViewContentModeScaleToFill];
        
        _thumbImageView = [ciView retain];
        [self.contentView addSubview:_thumbImageView];
        [ciView release];
        
        
    }
    return self;
}

#pragma mark -
#pragma mark TableCell Methods


/* 
 * Sub stuff.
 */
- (void)layoutSubviews {
    GLog();
    
    // offsets
    float oxinfo = 5;
    if (iOS4) {
        oxinfo = -3;
    }
    
    // size
    [_labelInfo sizeToFit];
    [_labelMeta sizeToFit];
    
    
    // thumb
    [_thumbImageView setFrame:CGRectMake(kListingCellInset, 0, 24, 36)];
    
    // adjust labels
    float ml = self.frame.size.width-kListingGapInset-2*kListingCellInset-kListingCellThumb;
    
    // info
    CGRect finfo = _labelInfo.frame;
    finfo.origin.x = CGRectGetMinX (self.contentView.bounds) + kListingCellInset + oxinfo + kListingCellThumb;
    finfo.origin.y = CGRectGetMinY (self.contentView.bounds) + 9;
    finfo.size.width = MIN(finfo.size.width, ml);
    [_labelInfo setFrame: finfo];
    
    // meta
    CGRect fmeta = _labelMeta.frame;
    fmeta.origin.x = CGRectGetMaxX (_labelInfo.frame) + 10;
    fmeta.origin.y = CGRectGetMinY (self.contentView.bounds) + 9;
    fmeta.size.width = MIN(fmeta.size.width, ml-(finfo.size.width+10));
    [_labelMeta setFrame: fmeta];
    [_labelMeta setHidden:finfo.size.width >= ml ];
    

    
}


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
    CGRect bg = CGRectMake(kListingCellInset, 0, self.frame.size.width-2*kListingCellInset, kListingCellHeight);
    UIColor *bgc = loaded ? [UIColor colorWithWhite:0 alpha:0.05] : (self.highlighted ? [UIColor colorWithWhite:0 alpha:0.08] : [UIColor colorWithWhite:0 alpha:0.02]);
    CGContextSetFillColorWithColor(ctx, bgc.CGColor);
	CGContextFillRect(ctx, bg);
    
    // lines
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(ctx, bg.origin.x, 0);
	CGContextAddLineToPoint(ctx, bg.origin.x+bg.size.width, 0);
	CGContextStrokePath(ctx);
    
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
#pragma mark Business Methods


/**
 * Updates the cell.
 */
- (void)update {
     GLog();
    
    // layout
    [self setNeedsLayout];
}

/**
 * Loads the thumb.
 */
- (void)loadThumb:(NSString *)thumb type:(NSString *)type {
    GLog();
    
    // type
    if ([type isEqualToString:typeMovie]) {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_listing_movie.png"]];
    }
    else {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_listing_person.png"]];
    }
    [_thumbImageView loadImage:thumb];
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // self
    [_labelInfo release];
    [_labelMeta release];
    [_thumbImageView release];


	// super
    [super dealloc];
}

@end

