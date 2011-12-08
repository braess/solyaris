//
//  CellButton.h
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
