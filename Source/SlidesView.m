//
//  SlidesView.m
//  Solyaris
//
//  Created by CNPP on 8.9.2011.
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

#import "SlidesView.h"
#import "CacheImageView.h"
#import "Tracker.h"


/*
 * Helper Stack.
 */
@interface SlidesView (Helpers)
- (void)exportSave;
@end


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
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+kSlidesFooterHeight)])) {
        
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
        
        // button save 
        UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom]; 
        btnSave.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        
        [btnSave setImage:[UIImage imageNamed:@"btn_save.png"] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(actionSave:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnSave = [btnSave retain];
        [self addSubview:_btnSave];
        [btnSave release];
        
        
        // data
        _slides = [[NSMutableArray alloc] init];
        _title = [[NSMutableString alloc] init];
        
    }
    
    // back
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
    _scrollView.frame = CGRectMake(0, 0, w, h-kSlidesFooterHeight);
    
    // scroll view
    [_scrollView setContentSize:CGSizeMake([_slides count] * w, h-kSlidesFooterHeight)];
    for (int i = 0; i < [_slides count]; i++) {
        
        // image
        CacheImageView *civ = [_slides objectAtIndex:i];
        civ.frame = CGRectMake(i*w, 0, w, h-kSlidesFooterHeight);

    }
    
    // page control
    _pageControl.frame = CGRectMake(0, h-kSlidesFooterHeight-2, w, kSlidesFooterHeight);
    [self bringSubviewToFront:_pageControl];
    [_pageControl setNeedsDisplay];
    
    
    // adjust scroll position
    if (! ([_scrollView isDragging] || [_scrollView isDecelerating])) {
        [_scrollView setContentOffset:CGPointMake(currentSlide*w, 0) animated:NO];
    }
    
    // button
    _btnSave.frame = CGRectMake(w-44, h-44, 44, 44);
    [self bringSubviewToFront:_btnSave];

}

/**
 * Resizes the slides.
 */
- (void)resize:(CGRect)rframe {
    self.frame = CGRectMake(rframe.origin.x, rframe.origin.y, rframe.size.width, rframe.size.height+kSlidesFooterHeight);
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
 * Sets the slides title.
 */
- (void)setSlidesTitle:(NSString *)title {
    [_title setString:title];
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
        
        // image
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
#pragma mark Actions


/*
 * Action Save.
 */
- (void)actionSave:(id)sender {
	DLog();
    
    // check
    CacheImageView *civ = [_slides objectAtIndex:currentSlide];
    if ([civ loaded]) {
        
        // action
        UIActionSheet *saveActions = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Save to Photos", @"Save to Photos"),nil];
        
        // offset
        float ox = -1;
        float oy = 20;
        if (self.frame.size.width >= 700) {
            ox = 10;
            oy = 5;
        }
        
        // show
        [saveActions setTag:ActionSlidesExport];
        [saveActions showFromRect:CGRectMake(_btnSave.frame.origin.x+ox,_btnSave.frame.origin.y+oy,_btnSave.frame.size.width,_btnSave.frame.size.height) inView:self animated:YES];
        [saveActions release];
    }
    
}



#pragma mark -
#pragma mark Export Actions

/*
 * Save.
 */
- (void)exportSave {
	DLog();
	
	// track
    [Tracker trackEvent:TEventSlides action:@"Export" label:@"save"];
	
	// image
    CacheImageView *civ = [_slides objectAtIndex:currentSlide];
    UIImage *cimg = [civ cachedImage];
	
	// save image
	UIImageWriteToSavedPhotosAlbum(cimg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	GLog();
    
	// red alert 
	if (error) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error")
                                           message:NSLocalizedString(@"Unable to save image to Photo Album.",@"Unable to save image to Photo Album.")
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"Ok") 
                                 otherButtonTitles:nil];
        [alert setTag:SlidesAlertExportError];
		[alert show];
		[alert release];
	}
	
}


#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // export
		case ActionSlidesExport: {
            
            // save
			if (buttonIndex == 0) {
				[self exportSave];
			} 
            
            // break it
			break;
		}
            
            
        // default
		default: {
			break;
		}
	}
	
	
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
    [_btnSave release];
    
    // data
    [_slides release];
    [_title release];
    
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
    
    // sup
    [super dealloc];
}


@end
