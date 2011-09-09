//
//  TMDbView.h
//  IMDG
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Person.h"
#import "Asset.h"
#import "SlidesView.h"

/**
 * TMDbView.
 */
@interface TMDbView : UIScrollView {
    
    // ui
    SlidesView *_slidesView;
    UITextView *_textView;
    
    // props
    bool mode_slides;
    float sprop;
    
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Methods
- (void)resetMovie:(Movie*)movie;
- (void)resetPerson:(Person*)person;
- (void)load;
- (void)scrollTop:(bool)animated;
- (void)resize;

@end
