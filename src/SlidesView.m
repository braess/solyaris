//
//  SlidesView.m
//  IMDG
//
//  Created by CNPP on 8.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SlidesView.h"
#import "CacheImageView.h"

/**
 * SlidesView.
 */
@implementation SlidesView

#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // self
    if ((self = [super initWithFrame:frame])) {
        
        // view
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.backgroundColor = [UIColor clearColor];
        
        // scroll view
        UIScrollView *sView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        sView.delegate = self;
        sView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        sView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        sView.clipsToBounds = YES;
        sView.scrollEnabled = YES;
        sView.pagingEnabled = YES;
        sView.backgroundColor = [UIColor clearColor];
        _scrollView = [sView retain];
        [self addSubview:_scrollView];
        [sView release];
        
        // page control
        ColorPageControl *pControl = [[ColorPageControl alloc] initWithFrame:CGRectZero];
        pControl.backgroundColor = [UIColor clearColor];
        pControl.inactivePageColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.9];
        pControl.activePageColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.9];
        pControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _pageControl = [pControl retain];
        [self addSubview:_pageControl];
        [pControl release];
        
        // data
        _slides = [[NSMutableArray alloc] init];
        
    }
    return self;
    
}


/*
 * Layout subviews.
 */
- (void)layoutSubviews {
    
    // size
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    // self
    _scrollView.frame = CGRectMake(0, 0, w, h);
    
    // scroll view
    [_scrollView setContentSize:CGSizeMake([_slides count] * w, h)];
    for (int i = 0; i < [_slides count]; i++) {
        
        // image
        CacheImageView *civ = [_slides objectAtIndex:i];
        civ.frame = CGRectMake(i*w, 0, w, h);

    }
    
    // page control
    _pageControl.frame = CGRectMake(0, self.frame.size.height-3, self.frame.size.width, 30);
    [self bringSubviewToFront:_pageControl];
    [_pageControl setNeedsDisplay];
    
    
    // adjust scroll position
    if (! ([_scrollView isDragging] || [_scrollView isDecelerating])) {
        [_scrollView setContentOffset:CGPointMake(currentSlide*self.frame.size.width, 0) animated:NO];
    }

}


#pragma mark -
#pragma mark Business

/**
 * Sets the slides.
 */
- (void)setSlides:(NSArray *)slides {
    FLog();
    
    // remove & add
    [_slides removeAllObjects];
    [_slides addObjectsFromArray:slides];
    
    // remove subviews
	for(UIView *subview in [_scrollView subviews]) {
		[subview removeFromSuperview];
	}
    
    // add slides
    for (int i = 0; i < [_slides count]; i++) {
        
        // image
        [_scrollView addSubview:[_slides objectAtIndex:i]];
        
    }
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    // pages
    _pageControl.numberOfPages = [_slides count];
    _pageControl.currentPage = 0;
    currentSlide = 0;
    [self bringSubviewToFront:_pageControl];
    [_pageControl setNeedsDisplay];
    
    // layout
    [self layoutSubviews];
}



/**
 * Loads the initial slide.
 */
- (void)load {
    FLog();

    // slide
    if ([_slides count] > 0) {
        CacheImageView *civ = [_slides objectAtIndex:0];
        [civ load];
    }

}




#pragma mark -
#pragma mark UIScrollViewDelegate stuff

/*
 * Scrolling.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	// safety check
    if (pageControlIsChangingPage || ! [_scrollView isDragging]) {
        return;
    }
    
	// switch page at 50% across
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    currentSlide = page;
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
	// flag
    pageControlIsChangingPage = NO;
    
    // load
    if (currentSlide < [_slides count]) {
        CacheImageView *civ = [_slides objectAtIndex:currentSlide];
        [civ load];
    }
}


#pragma mark -
#pragma mark PageControl stuff

/*
 * Paging.
 */
- (IBAction)changePage:(id)sender {
	
	// scroll into view
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * currentSlide;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
	// flag
    pageControlIsChangingPage = YES;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    
    // ui
    [_scrollView release];
    [_pageControl release];
    
    // data
    [_slides release];
    
    // view
    [super dealloc];
}

@end


/**
 * Color page control.
 */
@implementation ColorPageControl


#pragma mark -
#pragma mark Properties

// accessors
@synthesize numberOfPages, hidesForSinglePage, inactivePageColor, activePageColor;
@dynamic currentPage;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        // self
        self.contentMode = UIViewContentModeRedraw;
        
        // fields
        hidesForSinglePage = NO;
    }
    return self;
}

/*
 * Draw.
 */
- (void)drawRect:(CGRect)rect {
	
	// decide
	if (hidesForSinglePage == NO || [self numberOfPages] > 1){
        
		// defaults
		if (activePageColor == nil){
			activePageColor = [UIColor blackColor];
		}
		
		if (inactivePageColor == nil){
			inactivePageColor = [UIColor grayColor];
		}
		
		// vars
		CGContextRef context = UIGraphicsGetCurrentContext();
		float dotSize = self.frame.size.height / 6;		
		float dotsWidth = (dotSize * [self numberOfPages]) + (([self numberOfPages] - 1) * 10);
		float offset = (self.frame.size.width - dotsWidth) / 2;
		
		// draw dots
		for (NSInteger i = 0; i < [self numberOfPages]; i++){
			if (i == [self currentPage]){
				CGContextSetFillColorWithColor(context, [activePageColor CGColor]);
			} 
			else {
				CGContextSetFillColorWithColor(context, [inactivePageColor CGColor]);
			}
			
			CGContextFillEllipseInRect(context, CGRectMake(offset + (dotSize + 10) * i, (self.frame.size.height / 2) - (dotSize / 2), dotSize, dotSize));
		}
	}
}

#pragma mark -
#pragma mark Business Methods

/*
 * Current.
 */
- (NSInteger) currentPage{
	return currentPage;
}

- (void) setCurrentPage:(NSInteger)page {
	currentPage = page;
	[self setNeedsDisplay];
}


#pragma mark -
#pragma mark Memory Management

/*
 * Dealloc.
 */
- (void)dealloc {
    [super dealloc];
}


@end
