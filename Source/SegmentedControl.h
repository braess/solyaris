//
//  SegmentedControl.h
//  Solyaris
//
//  Created by Beat Raess on 27.4.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
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


// caps
typedef enum {
    SegmentCapLeft          = 0,
    SegmentCapMiddle        = 1,
    SegmentCapRight         = 2,
    SegmentCapLeftAndRight  = 3
} SegmentCapLocation;


/**
 * SegmentedControlDelegate Protocol.
 */
@protocol SegmentedControlDelegate <NSObject>
- (void)segmentedControlTouched:(NSUInteger)segmentIndex;
@optional
- (void)segmentedControlDown:(NSUInteger)segmentIndex;
@end

/**
 * Custom SegmentedControl.
 */
@interface SegmentedControl : UIView {
    
    // delegate
	id<SegmentedControlDelegate>delegate;
    
    // private
    @private
    
    // data
    NSMutableArray* _buttons;
}

// Properties
@property (assign) id<SegmentedControlDelegate> delegate;


// Object
- (id)initWithTitles:(NSArray*)titles;
- (id)initWithTitles:(NSArray*)titles size:(CGSize)size gap:(int)gap cap:(int)cap image:(NSString*)image selected:(NSString*)selected divider:(NSString*)divider;

// Business
- (void)select:(int)ndx;
- (NSArray*)segmentButtons;

@end


/**
 * SegmentedControlItem.
 */
@interface SegmentedControlItem : UIButton {
    
}

// Object
- (id)initSegmentedControlItem:(CGSize)size capLocation:(SegmentCapLocation)capLocation capWidth:(NSUInteger)capWidth title:(NSString*)title image:(NSString*)image selected:(NSString*)selected;

@end
