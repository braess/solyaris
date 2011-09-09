//
//  CellSegment.h
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
