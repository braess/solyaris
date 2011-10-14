//
//  SlidesView.h
//  Solyaris
//
//  Created by CNPP on 8.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 * Color page control.
 */
@interface ColorPageControl : UIPageControl {
	NSInteger currentPage;
	NSInteger numberOfPages;
	BOOL hidesForSinglePage;
	
	UIColor *inactivePageColor;
	UIColor *activePageColor;
}

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) BOOL hidesForSinglePage;

@property (nonatomic, retain) UIColor *inactivePageColor;
@property (nonatomic, retain) UIColor *activePageColor;

@end

/**
 * SlidesView.
 */
@interface SlidesView : UIView <UIScrollViewDelegate> {
    
    // ui
	UIScrollView *_scrollView;
	ColorPageControl *_pageControl;
    
	// data
	NSMutableArray *_slides;
    NSMutableString *_title;
	
	// private
    @private
	BOOL pageControlIsChangingPage;
    int currentSlide;
    
}

// Business
- (void)setSlides:(NSArray*)slides;
- (void)setSlidesTitle:(NSString*)title;
- (void)load;

@end
