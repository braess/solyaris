//
//  CellButton.h
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellInput.h"


/**
 * CellButtonDelegate Protocol.
 */
@class CellButton;
@protocol CellButtonDelegate <NSObject>
	- (void)cellButtonTouched:(CellButton*)c;
    @optional
    - (void)cellButtonDown:(CellButton*)c;
    - (void)cellButtonUp:(CellButton*)c;
@end


/**
 * CellButton.
 */
@interface CellButton : CellInput {

	// delegate
	id<CellButtonDelegate>delegate;
	
	// ui
	UIButton *buttonAccessory;

}

// Properties
@property (assign) id<CellButtonDelegate> delegate;
@property (nonatomic, retain) UIButton *buttonAccessory;



@end
