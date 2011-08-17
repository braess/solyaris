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


// local vars
CGRect vframe;
float informationHeaderHeight = 60;
float informationFooterHeight = 50;


// sections
int cellHeight = 30;
int cellInset = 15;
int sectionGapHeight = 50;
int sectionGapOffset = 10;
int sectionGapInset = 15;


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
    UIView *headerView = [[UIView alloc] initWithFrame:hframe];
    headerView.tag = TagInformationHeader;
	headerView.backgroundColor = [UIColor clearColor];
	headerView.opaque = YES;
    
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(sectionGapInset, sectionGapOffset, hframe.size.width-2*sectionGapInset, hframe.size.height-2*sectionGapOffset)];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
	lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblTitle.shadowOffset = CGSizeMake(1,1);
	lblTitle.opaque = YES;
	lblTitle.numberOfLines = 1;
    
    _labelTitle = [lblTitle retain];
    [headerView addSubview:_labelTitle];
    [lblTitle release];
    
    
    // drop that shadow
	CAGradientLayer *dropShadow = [[[CAGradientLayer alloc] init] autorelease];
	dropShadow.frame = CGRectMake(0, hframe.size.height, hframe.size.width, 15);
	dropShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.02].CGColor,(id)[UIColor colorWithWhite:0 alpha:0].CGColor,nil];
	[headerView.layer insertSublayer:dropShadow atIndex:0];
    
    // add header view to content
    [ctView addSubview:headerView];
    [headerView release];

    
    // table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:tframe style:UITableViewStyleGrouped];
    tableView.tag = TagInformationContent;
    tableView.delegate = self;
    tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.opaque = YES;
	tableView.backgroundView = nil;
    tableView.sectionHeaderHeight = 0; 
    tableView.sectionFooterHeight = 0;
    
    // add table view to content
    _tableView = [tableView retain];
    [ctView addSubview:_tableView];
    [ctView sendSubviewToBack:_tableView];
    [tableView release];
    
    
    // footer view
    UITableView *footerView = [[UIView alloc] initWithFrame:fframe];
    footerView.autoresizingMask = UIViewAutoresizingNone;
    footerView.tag = TagInformationFooter;
	footerView.backgroundColor = [UIColor clearColor];
	footerView.opaque = YES;
    
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
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // reload
    [_tableView reloadData];
    
    // scroll to top
    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];

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
    FLog();
    
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
 * Information title.
 */
- (void)informationTitle:(NSString *)title {
    DLog();
    
    // label
    [_labelTitle setText:title];
}




#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 3;
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
    return sectionGapHeight;
}

/*
 * Customize the section footer height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return sectionGapInset;
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
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vframe.size.width, sectionGapHeight)];
    
    // label
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(sectionGapInset, sectionGapOffset, shView.frame.size.width-2*sectionGapInset, sectionGapHeight-sectionGapOffset)];
	lblHeader.backgroundColor = [UIColor clearColor];
	lblHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
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
    UIView *sfLine = [[UIView alloc] initWithFrame:CGRectMake(sectionGapInset, -1, 570, 1)];
    sfLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1];
    
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
    
    // check
    if (! nfo.loaded) {
        
        // state
        nfo.loaded = YES;
        [_tableView reloadData];
        
        // load
        if (delegate && [delegate respondsToSelector:@selector(informationSelected:type:)]) {
            [delegate informationSelected:nfo.nid type:nfo.type];
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
	
	// duper
    [super dealloc];
}


@end



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
    NSLog(@"%f %f",w,h);
    
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




/**
 * InformationCell.
 */
@implementation InformationCell


#pragma mark -
#pragma mark Properties

// accessors
@synthesize labelInfo, labelMeta, type;
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
        self.indentationWidth = sectionGapInset;
        self.indentationLevel = 0;
        
        
        // back
        UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = backView;
        
        
        // labels
        labelInfo = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        labelInfo.backgroundColor = [UIColor clearColor];
        labelInfo.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        labelInfo.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
        labelInfo.opaque = YES;
        labelInfo.numberOfLines = 1;
        [self.contentView addSubview: labelInfo];
        
        labelMeta = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        labelMeta.backgroundColor = [UIColor clearColor];
        labelMeta.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        labelMeta.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        labelMeta.opaque = YES;
        labelMeta.numberOfLines = 1;
        [self.contentView addSubview: labelMeta];
        
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
    [labelInfo sizeToFit];
    [labelMeta sizeToFit];
    
    // position
    CGRect finfo = labelInfo.frame;
    finfo.origin.x = CGRectGetMinX (self.contentView.bounds) + 12;
    finfo.origin.y = CGRectGetMinY (self.contentView.bounds) + 6;
    [labelInfo setFrame: finfo];
    
    // meta
    CGRect fmeta = labelMeta.frame;
    fmeta.origin.x = CGRectGetMaxX (labelInfo.frame) + 10;
    fmeta.origin.y = CGRectGetMinY (self.contentView.bounds) + 6;
    [labelMeta setFrame: fmeta];
    
    // disclosure
    CGRect fdisc = CGRectMake(self.frame.size.width-50, 6, 16, 16);
    _iconMovie.hidden = YES;
    _iconActor.hidden = YES;
    _iconDirector.hidden = YES;
    if (loaded) {
        
        // movie
        if ([type isEqualToString:typeMovie]) {
            _iconMovie.frame = fdisc;
            _iconMovie.hidden = NO;
        }
        // actor
        else if ([type isEqualToString:typeActor]) {
            _iconActor.frame = fdisc;
            _iconActor.hidden = NO;
        }
        // director
        else if ([type isEqualToString:typeDirector]) {
            _iconDirector.frame = fdisc;
            _iconDirector.hidden = NO;
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

