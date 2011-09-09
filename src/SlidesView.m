//
//  SlidesView.m
//  IMDG
//
//  Created by CNPP on 8.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SlidesView.h"


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
        
        
        // scroll view
        UIScrollView *sView = [[UIScrollView alloc] initWithFrame:self.frame];
        sView.delegate = self;
        sView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        sView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        sView.clipsToBounds = YES;
        sView.scrollEnabled = YES;
        sView.pagingEnabled = YES;
        _scrollView = [sView retain];
        [self addSubview:_scrollView];
        [sView release];
        
        // page control
        ColorPageControl *pControl = [[ColorPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
        pControl.backgroundColor = [UIColor clearColor];
        pControl.inactivePageColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
        pControl.activePageColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
        pControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _pageControl = [pControl retain];
        [self addSubview:_pageControl];
        [pControl release];
        
    }
    return self;
    
}


/*
 * Layout subviews.
 */
- (void)layoutSubviews {
    
    // scroll view
    [_scrollView setContentSize:CGSizeMake(nbOfPages * self.frame.size.width, self.frame.size.height)];
}


#pragma mark -
#pragma mark UIScrollViewDelegate stuff

/*
 * Scrolling.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	// safety check
    if (pageControlIsChangingPage) {
        return;
    }
    
	// switch page at 50% across
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// flag
    pageControlIsChangingPage = NO;
}


#pragma mark -
#pragma mark PageControl stuff

/*
 * Paging.
 */
- (IBAction)changePage:(id)sender {
	
	// scroll into view
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
	// flag
    pageControlIsChangingPage = YES;
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
