//
//  CellSlider.h
//  Solyaris
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellInput.h"


/**
 * CellSliderDelegate Protocol.
 */
@class CellSlider;
@protocol CellSliderDelegate <NSObject>
	- (void)cellSliderChanged:(CellSlider*)c;
@end


/**
 * CellSlider.
 */
@interface CellSlider : CellInput {

	// delegate
	id<CellSliderDelegate>delegate;
	
	// ui
	UISlider *sliderAccessory;

}

// Properties
@property (assign) id<CellSliderDelegate> delegate;
@property (nonatomic, retain) UISlider *sliderAccessory;


@end