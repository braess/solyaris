//
//  CellSearch.m
//  Solyaris
//
//  Created by Beat Raess on 3.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import "CellData.h"
#import "SolyarisConstants.h"



/**
 * CellData.
 */
@implementation CellData


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
        lblInfo.shadowOffset = CGSizeMake(0,1);
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
        
        // icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        icon.backgroundColor = [UIColor clearColor];
        
        _icon = [icon retain];
        [self.contentView addSubview:_icon];
        [icon release];
        
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

    // thumb
    if (mode_thumb) {
        
        // thumb
        int toff = self.contentView.frame.origin.x > 0 ? 4 : 0;
        [_thumbImageView setFrame:CGRectMake(toff, 0, 32, 44)];
        [_labelData setFrame:CGRectMake(44, -1, cw-44, kCellDataHeight)];
    }
    
    // icon
    else if (mode_icon) {
        
        // icon
        [_icon setFrame:CGRectMake(0, 0, 44, 44)];
        [_labelData setFrame:CGRectMake(44, -1, cw-44, kCellDataHeight)];
    }
    
    // loader
    else if (mode_more) {
        
        // label
        [_labelData setFrame:CGRectMake(10, -1, cw-44, kCellDataHeight)];
    }
    else {
        
        // label
        [_labelData setFrame:CGRectMake(10, -1, cw, kCellDataHeight)];
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
	CGContextMoveToPoint(ctx, rect.origin.x, kCellDataHeight);
	CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, kCellDataHeight);
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
    mode_icon = NO;
    
    // thumb
    [_thumbImageView reset];
    
    // hide
     _thumbImageView.hidden = YES;
    _loader.hidden = YES;
    _icon.hidden = YES;
    
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
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_thumb_movie.png"]];
    }
    else {
        [_thumbImageView placeholderImage:[UIImage imageNamed:@"placeholder_thumb_person.png"]];
    }
    [_thumbImageView loadImage:thumb];

}
- (void)dataThumb:(UIImage*)thumb type:(NSString *)type{
    
    // mode
    mode_thumb = YES;
    _thumbImageView.hidden = NO;
    
    // thumb
    if (thumb.size.width > 0 && thumb.size.height > 0) {
        [_thumbImageView dataImage:thumb];
    }
    else {
        [_thumbImageView placeholderImage:[UIImage imageNamed:[type isEqualToString:typePerson] ? @"placeholder_thumb_person.png" : @"placeholder_thumb_movie.png"]];
    }
}

/**
 * Loads the icon.
 */
- (void)dataIcon:(UIImage *)icon {
    
    // mode
    mode_icon = YES;
    _icon.hidden = NO;
    
    // icon
    _icon.image = icon;
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
    [_icon release];
    [_loader release];
    [_disclosure release];
    [_more release];
	
	// super
    [super dealloc];
}


@end
