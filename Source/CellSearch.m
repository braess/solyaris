//
//  CellSearch.m
//  Solyaris
//
//  Created by Beat Raess on 3.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import "CellSearch.h"
#import "SolyarisConstants.h"



/**
 * CellSearch.
 */
@implementation CellSearch


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
        
        // disclosure
        UIImageView *discl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        discl.backgroundColor = [UIColor clearColor];
        discl.image = [UIImage imageNamed:@"icon_disclosure.png"];
        
        _disclosure = [discl retain];
        [discl release];
        
        
        // disclosure
        UIImageView *mre = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        mre.backgroundColor = [UIColor clearColor];
        mre.image = [UIImage imageNamed:@"icon_more.png"];
        
        _more = [mre retain];
        [mre release];
        
        
        // loader
		UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		loader.hidden = YES;
        
        // add
        _loader = [loader retain];
        [loader release];
        
        // reset
        [self reset];
        
    }
    return self;
}

#pragma mark -
#pragma mark TableCell Methods

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // cell width
    float cw = self.contentView.frame.size.width-20;
    
    // offset
    float ox = 0;
    if (iOS4) {
        ox = -10;
    }
    
    // thumb
    if (mode_thumb) {
        
        // thumb
        [_thumbImageView setFrame:CGRectMake(0+ox, 0, 32, 44)];
        
        // label
        [_labelData setFrame:CGRectMake(40+ox, 0, cw-40-ox, kCellSearchHeight)];
    }
    
    // loader
    else if (mode_more) {
        
        // label
        [_labelData setFrame:CGRectMake(10+ox, 0, cw-44-ox, kCellSearchHeight)];
    }
    else {
        
        // label
        [_labelData setFrame:CGRectMake(10+ox, 0, cw-ox, kCellSearchHeight)];
    }
    
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
	CGContextMoveToPoint(ctx, rect.origin.x, kCellSearchHeight);
	CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, kCellSearchHeight);
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
 * Reset.
 */
- (void)reset {
    GLog();
    
    // mode
    mode_thumb = NO;
    mode_more = NO;
    
    // thumb
    [_thumbImageView reset];
    
    // hide
     _thumbImageView.hidden = YES;
    _loader.hidden = YES;
    
    // label
    [_labelData setText:@""];
    
    // disclosure
    self.accessoryView = NULL;
    self.accessoryType = UITableViewCellAccessoryNone;
    
}

/**
 * Update
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
    
    // mode
    mode_thumb = YES;
    _thumbImageView.hidden = NO;
    
    // type
    if ([type isEqualToString:typeMovie]) {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_search_movie.png"]];
    }
    else {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_search_person.png"]];
    }
    [_thumbImageView loadImage:thumb];

}

/**
 * More.
 */
- (void)more {
    GLog();
    
    // mode
    mode_more = YES;
    mode_thumb = NO;
    
    // accessory
    self.accessoryView = _more;
    
}


/**
 * Loading.
 */
- (void)loading {
    GLog();
    
    // loader
    self.accessoryView = _loader;
    [_loader startAnimating];

}


/**
 * Disclosure
 */
- (void)disclosure {
    
    // disclosure
    self.accessoryView = _disclosure;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // release
    [_labelData release];
    [_thumbImageView release];
    [_loader release];
    [_disclosure release];
    [_more release];
	
	// super
    [super dealloc];
}


@end
