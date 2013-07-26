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
#pragma mark Object

/*
 * Init.
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    // init
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        // self
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.editingAccessoryType = UITableViewCellAccessoryNone;
        
        // labels
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        self.textLabel.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        self.textLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.textLabel.shadowOffset = CGSizeMake(0,1);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.opaque = YES;
        self.textLabel.numberOfLines = 2;

        
        // thumb
        CacheImageView *ciView = [[CacheImageView alloc] initWithFrame:CGRectZero];
        
        _thumb = [ciView retain];
        [self.contentView addSubview:_thumb];
        [ciView release];
        
        // icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        icon.backgroundColor = [UIColor clearColor];
        
        _icon = [icon retain];
        [self.contentView addSubview:_icon];
        [icon release];
        
        
        // disclosure
        UIImageView *mre = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        mre.backgroundColor = [UIColor clearColor];
        mre.image = [UIImage imageNamed:@"btn_more.png"];
        
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
    float cell_width = self.frame.size.width;
    float content_width = self.contentView.frame.size.width-20;

    // thumb
    if (mode_thumb) {
        
        // thumb
        int toff = self.contentView.frame.origin.x > 0 ? 4 : 0;
        [_thumb setFrame:CGRectMake(toff, 0, 32, 44)];
        [self.textLabel setFrame:CGRectMake(44, 0, content_width-44, kCellDataHeight-2)];
    }
    
    // icon
    else if (mode_icon) {
        
        // icon
        [_icon setFrame:CGRectMake(0, 0, 44, 44)];
        [self.textLabel setFrame:CGRectMake(44, 0, content_width-44, kCellDataHeight-2)];
    }
    
    // loader
    else if (mode_more) {
        
        // accessory
        [self.accessoryView setFrame:CGRectMake(cell_width-44, 0, 44, 44)];
        
        // label
        [self.textLabel setFrame:CGRectMake(10, 0, content_width-44, kCellDataHeight-2)];
    }
    else {
        
        // label
        [self.textLabel setFrame:CGRectMake(10, 0, content_width, kCellDataHeight-2)];
    }
    
}



/*
 * Draws the cell.
 */
- (void)drawRect:(CGRect)rect {
	
    // context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // background
    UIColor *bgc = self.highlighted ? [UIColor colorWithWhite:0.99 alpha:1] : [UIColor colorWithWhite:1 alpha:1];
    CGContextSetFillColorWithColor(ctx, bgc.CGColor);
	CGContextFillRect(ctx, rect);
    
    // lines
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.87 alpha:1].CGColor);
	CGContextMoveToPoint(ctx, rect.origin.x, kCellDataHeight);
	CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, kCellDataHeight);
	CGContextStrokePath(ctx);
    
}


/*
 * Selected.
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
    [_thumb reset];
    
    // hide
     _thumb.hidden = YES;
    _loader.hidden = YES;
    _icon.hidden = YES;
    
    // label
    [self.textLabel setText:@""];
    
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
    _thumb.hidden = NO;
    
    // type
    if ([type isEqualToString:typeMovie]) {
        [_thumb placeholderImage:[UIImage imageNamed:@"placeholder_thumb_movie.png"]];
    }
    else {
        [_thumb placeholderImage:[UIImage imageNamed:@"placeholder_thumb_person.png"]];
    }
    [_thumb loadImage:thumb];

}
- (void)dataThumb:(UIImage*)thumb type:(NSString *)type{
    
    // mode
    mode_thumb = YES;
    _thumb.hidden = NO;
    
    // thumb
    if (thumb.size.width > 0 && thumb.size.height > 0) {
        [_thumb dataImage:thumb];
    }
    else {
        [_thumb placeholderImage:[UIImage imageNamed:[type isEqualToString:typePerson] ? @"placeholder_thumb_person.png" : @"placeholder_thumb_movie.png"]];
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
    self.accessoryType = UITableViewCellAccessoryNone;
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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.accessoryView = nil;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // release
    [_thumb release];
    [_icon release];
    [_loader release];
    [_more release];
	
	// super
    [super dealloc];
}


@end
