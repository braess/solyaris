//
//  SearchResultViewController.m
//  Solyaris
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SolyarisConstants.h"



#pragma mark -
#pragma mark SearchResultViewController
#pragma mark -

/**
 * SearchResultViewController.
 */
@implementation SearchResultViewController




#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

/*
 * Load.
 */
- (void)loadView {
    [super loadView];
    FLog();
   
    // data
    _data = [[NSMutableArray alloc] init];
    
    // resize
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
}




#pragma mark -
#pragma mark Business

/**
 * Shows the search results.
 */
- (void)searchResultShow:(Search*)search {
    
    
    // data
    for (SearchResult* s in search.results) {
        [_data addObject:s];
    }
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"data" ascending:TRUE];
	[_data sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    // title
    self.navigationItem.title = [NSString stringWithFormat:@"%i %@",[_data count], NSLocalizedString(@"Results", @"Results")];
    
    // reload
    [self.tableView reloadData];
    
    // size
    float height = MAX(self.tableView.rowHeight,self.tableView.rowHeight * [self.tableView numberOfRowsInSection:0]);
    self.contentSizeForViewInPopover = CGSizeMake(320,MIN(height, 480));
    
}


/**
 * Resets the search results.
 */
- (void)searchResultReset {
    
    // data
    [_data removeAllObjects];
    
    // title
    self.navigationItem.title = NSLocalizedString(@"Searching...", @"Searching...");
    
    // reload
    [self.tableView reloadData];
    
    // size
    self.contentSizeForViewInPopover = CGSizeMake(320,self.tableView.rowHeight);

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
    return kSearchCellHeight;
}


/*
 * Cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLog();
    
    // identifiers
    static NSString *CellSearchResultIdentifier = @"CellSearchResult";
	
	// create cell
	SearchResultCell *cell = (SearchResultCell*) [tableView dequeueReusableCellWithIdentifier:CellSearchResultIdentifier];
	if (cell == nil) {
		cell = [[[SearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellSearchResultIdentifier] autorelease];
	}
	
    
    // result 
    SearchResult *sr = [_data objectAtIndex:indexPath.row];
    
    // cell
    [cell.labelData setText:sr.data];
    [cell loadThumb:sr.thumb type:sr.type];
    
    // return
    return cell;
}

/*
 * Selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLog();
    
    // delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(searchSelected:)]) {
		[delegate searchSelected:[_data objectAtIndex:indexPath.row]];
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
    
    // super
    [super dealloc];
}



@end




#pragma mark -
#pragma mark InformationCell
#pragma mark -

/**
 * SearchResultCell.
 */
@implementation SearchResultCell


#pragma mark -
#pragma mark Properties

// accessors
@synthesize labelData=_labelData;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    // init
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        // cell
        self.accessoryType = UITableViewCellAccessoryNone;
        
        // labels
        UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        lblInfo.backgroundColor = [UIColor clearColor];
        lblInfo.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        lblInfo.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblInfo.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblInfo.shadowOffset = CGSizeMake(1,1);
        lblInfo.opaque = YES;
        lblInfo.numberOfLines = 2;
        
        
        _labelData = [lblInfo retain];
        [self.contentView addSubview: _labelData];
        [lblInfo release];
        
        // thumb
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:CGRectZero];
        
        _thumbImageView = [ciView retain];
        [self.contentView addSubview:_thumbImageView];
        [ciView release];
        
    }
    return self;
}

#pragma mark -
#pragma mark TableCell Methods

/*
 * Layout.
 */
- (void)layoutSubviews {
    
    // offset
    float ox = 0;
    if (iOS4) {
        ox = -10;
    }
    
    // thumb
    [_thumbImageView setFrame:CGRectMake(0+ox, 0, 32, 44)];
    
    // label
    [_labelData setFrame:CGRectMake(40+ox, 0, 270, kSearchCellHeight)];
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
    UIColor *bgc = self.highlighted ? [UIColor colorWithWhite:0.96 alpha:1] : [UIColor colorWithWhite:1 alpha:1];
    CGContextSetFillColorWithColor(ctx, bgc.CGColor);
	CGContextFillRect(ctx, rect);
    
    // lines
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.82 alpha:1].CGColor);
	CGContextMoveToPoint(ctx, rect.origin.x, kSearchCellHeight);
	CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, kSearchCellHeight);
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
 * Loads the thumb.
 */
- (void)loadThumb:(NSString *)thumb type:(NSString *)type {
    GLog();
    
    if ([type isEqualToString:typeMovie]) {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_search_movie.png"]];
    }
    else {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_search_person.png"]];
    }
    [_thumbImageView loadImage:thumb];
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

