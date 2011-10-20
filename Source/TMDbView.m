//
//  TMDbView.m
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "TMDbView.h"
#import "SolyarisConstants.h"
#import "CacheImageView.h"

/**
 * Helper Stack.
 */
@interface TMDbView (HelperStack)
- (void)reset:(NSString*)title content:(NSString*)content slides:(NSArray*)slides;
@end


/**
 * TMDbView.
 */
@implementation TMDbView


#pragma mark -
#pragma mark Constants


// local vars
static int tmdbGapOffset = 10;
static int tmdbGapInset = 15;




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
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        self.scrollEnabled = YES;
        
        // mode
        mode_slides = NO;
        
        // proportion
        sprop = 0.5625;
        
        // slides
        SlidesView *slidesView = [[SlidesView alloc] initWithFrame:CGRectZero];
        
        // add slides to content
        _slidesView = [slidesView retain];
        [self addSubview:_slidesView];
        [slidesView release];

        // text
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
        textView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        textView.textAlignment = UITextAlignmentLeft;
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        textView.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
        textView.opaque = YES;
        textView.userInteractionEnabled = YES;
        textView.editable = NO;
        textView.scrollEnabled = NO;
        
        // add text to content
        _textView = [textView retain];
        [self addSubview:_textView];
        [textView release];
        
        
        
    }
    return self; 
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // slides
    _slidesView.frame = CGRectMake(tmdbGapInset, tmdbGapOffset, self.frame.size.width-2*tmdbGapInset, (self.frame.size.width-2*tmdbGapInset)*sprop);
    
    // text
    float hslides = mode_slides ? (_slidesView.frame.size.height+2*tmdbGapOffset) : 0;
    float htext = _textView.contentSize.height;
    _textView.frame = CGRectMake(tmdbGapOffset, hslides+8, self.frame.size.width-30, htext);
    
    // content size
    self.contentSize = CGSizeMake(self.frame.size.width, hslides+3*tmdbGapOffset+htext);
}


#pragma mark -
#pragma mark Helper

/*
 * Resets the component.
 */
- (void)reset:(NSString*)title content:(NSString*)text slides:(NSArray*)slides {
	FLog();
    
    // slides
    [_slidesView setSlides:slides];
    [_slidesView setSlidesTitle:title];
    _slidesView.hidden = ! mode_slides;

    
    // text
    [_textView setText:text];
    
    // layout
    [self layoutSubviews];
    
}



#pragma mark -
#pragma mark Interface

/*
 * Resets the component.
 */
- (void)resetMovie:(Movie *)movie {
	FLog();
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:TRUE];
	NSArray *assets = [[movie.assets allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    
    // backdrops
    NSMutableArray *backdrops = [[NSMutableArray alloc] init];
    for (Asset *a in assets) {
        
        // backdrop
        if ([a.type isEqualToString:assetBackdrop] && [a.size isEqualToString:assetSizeOriginal]) {
            
            // image
            CacheImageView *civ = [[[CacheImageView alloc] init] autorelease];
            [civ lazyloadImage:a.url];
            
            // add 
            [backdrops addObject:civ];
        }
    }
    
    
    // mode
    mode_slides = NO; 
    if ([backdrops count] > 0) {
        mode_slides = YES;
        [self bringSubviewToFront:_slidesView];
    }
    
    // reset
    [self reset:movie.name content:movie.overview slides:backdrops];
    [backdrops release];
    
}
- (void)resetPerson:(Person *)person {
    FLog();
    
    // mode
    mode_slides = NO; 
    
    // reset
    [self reset:person.name content:person.biography slides:nil];
}

/**
 * Loads the component.
 */
- (void)load {
    FLog();
    
    // slides
    [_slidesView load];
}


/**
 * Scroll to top.
 */
- (void)scrollTop:(bool)animated {
    FLog();
    
    // scroll to top
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
}

/*
 * Resize.
 */
- (void)resize {
    // nothing to do today
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
    [_textView release];
	
	// superduper
	[super dealloc];
}



@end
