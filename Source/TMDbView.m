//
//  TMDbView.m
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

#import "TMDbView.h"
#import "CacheImageView.h"
#import "Utils.h"

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
        
        // reorder
        [self bringSubviewToFront:_slidesView];
        
        
    }
    return self; 
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // slides
    float sw = self.frame.size.width-2*kTMDbGapInset;
    float sh = (self.frame.size.width-2*kTMDbGapInset)*sprop;
    [_slidesView resize:CGRectMake(kTMDbGapInset, kTMDbGapInset, sw, sh)];
    
    // text
    float hslides = mode_slides ? (sh+2*kTMDbGapOffset) : 0;
    float htext = _textView.contentSize.height;
    _textView.frame = iPad ? CGRectMake(10, hslides+13, self.frame.size.width-30, htext) : CGRectMake(2, hslides+8, self.frame.size.width-4, htext);
    
    // content size
    self.contentSize = CGSizeMake(self.frame.size.width, hslides+3*kTMDbGapOffset+htext);
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
    
    // flags
    BOOL wifi = [Utils isWiFi];
    
    // backdrops
    NSMutableArray *backdrops = [[NSMutableArray alloc] init];
    NSString *asize = [NSString stringWithFormat:@"%@",iPad ? (wifi ? assetSizeOriginal : assetSizeMed) : (wifi ? assetSizeMed : assetSizeMid)];
    for (Asset *a in assets) {
        
        // backdrop
        if ([a.type isEqualToString:assetBackdrop] && [a.size isEqualToString:asize]) {
            
            // image
            CacheImageView *civ = [[CacheImageView alloc] init];
            civ.imageView.backgroundColor = [UIColor whiteColor];
            [civ lazyloadImage:a.value];
            
            // add 
            [backdrops addObject:civ];
            [civ release];
        }
    }
    
    
    // mode
    mode_slides = NO; 
    if ([backdrops count] > 0) {
        mode_slides = YES;
        [self bringSubviewToFront:_slidesView];
    }
    
    // reset
    [self reset:movie.title content:movie.overview slides:backdrops];
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
	FLog();
	
	// release
    [_textView release];
	
	// superduper
	[super dealloc];
}



@end
