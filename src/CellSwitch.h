//
//  CellSwitch.h
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellInput.h"


/**
 * CellSwitchDelegate Protocol.
 */
@class CellSwitch;
@protocol CellSwitchDelegate <NSObject>
	- (void)cellSwitchChanged:(CellSwitch*)c;
@end


/**
 * Cell Switch.
 */
@interface CellSwitch : CellInput {

	// delegate
	id<CellSwitchDelegate>delegate;
	
	// ui
	UISwitch *switchAccessory;

}

// Properties
@property (assign) id<CellSwitchDelegate> delegate;
@property (nonatomic, retain) UISwitch *switchAccessory;



@end
