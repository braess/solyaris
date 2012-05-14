//
//  TMDbView.h
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

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Person.h"
#import "Asset.h"
#import "SlidesView.h"
#import "SolyarisConstants.h"


// Constants
#define kTMDbGapOffset     10.0f
#define kTMDbGapInset      (iPad ? 15.0f : 10.0f)


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
