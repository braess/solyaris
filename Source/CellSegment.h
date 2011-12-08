//
//  CellSegment.h
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
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
#import "CellInput.h"


/**
 * CellSegmentDelegate Protocol.
 */
@class CellSegment;
@protocol CellSegmentDelegate <NSObject>
- (void)cellSegmentChanged:(CellSegment*)c;
@end


/**
 * CellSegment.
 */
@interface CellSegment : CellInput {
    
	// delegate
	id<CellSegmentDelegate>delegate;
	
	// ui
	UISegmentedControl *_segmentAccessory;
    
}

// Properties
@property (assign) id<CellSegmentDelegate> delegate;
@property (nonatomic, retain) UISegmentedControl *segmentAccessory;

// Business
- (void)removeSegments;
- (void)addSegment:(NSString*)s;
- (void)selectSegment:(NSInteger)i;



@end
