//
//  CellPickerViewController.h
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright Beat Raess 2011. All rights reserved.
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
 * CellPickerDelegate Protocol.
 */
@class CellPicker;
@protocol CellPickerViewDelegate <NSObject>
	- (NSString*)controllerTitle;
	- (NSInteger)pickerIndex;
	- (NSMutableArray*)pickerValues;
	- (NSString*)pickerLabel:(NSInteger)index;
	- (NSString*)pickerLabel;
	- (void)pickedIndex:(NSInteger)index;
@end


/**
* CellPickerViewController.
*/
@interface CellPickerViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate> {

	// ui
	UIPickerView *picker;


}

// Properties
@property (assign) id<CellPickerViewDelegate> delegate;
@property (nonatomic, retain) UIPickerView *picker;



@end
