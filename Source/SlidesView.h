//
//  SlidesView.h
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
