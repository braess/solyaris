    //
//  CellPickerViewController.m
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

#import "CellPickerViewController.h"
#import "SolyarisConstants.h"


/**
* CellPickerViewController.
*/
@implementation CellPickerViewController


#pragma mark -
#pragma mark Properties

// accessors 
@synthesize delegate;
@synthesize picker;



#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
    DLog();
    
    // init
	if ((self = [super init])) {
        
        // view
        UIView *sview = [[UIView alloc] initWithFrame:iPad ? CGRectMake(0,0,320,180) : CGRectMake(0,0,320,436)];
        sview.backgroundColor = [UIColor lightGrayColor];
        
		// self
		self.view = sview;
        self.contentSizeForViewInPopover = CGSizeMake(320, 180);
        [sview release];
        
		// position the picker at the bottom
		UIPickerView *p = [[UIPickerView alloc] initWithFrame: iPad ? CGRectMake(0,0,320,180) : CGRectMake(0,0,320,216.0)];
		p.showsSelectionIndicator = YES;	// note this is default to NO
	
		// data source and delegate
		p.delegate = self;
		p.dataSource = self;
	
		// add to view
		self.picker = p;
		[self.view addSubview:picker];
		[p release];

	}
	return self;
}



#pragma mark -
#pragma mark View lifecycle


/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // size
	self.contentSizeForViewInPopover = CGSizeMake(320, 180);
	
	// title
	self.title = [delegate controllerTitle];
	
	
	// picker
	[picker selectRow:[delegate pickerIndex] inComponent:0 animated:NO];

}

/*
 * View will disappear.
 */
- (void)viewWillDisappear:(BOOL)animated {
    
    // delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(pickedIndex:)]) {
		[delegate pickedIndex:[picker selectedRowInComponent:0]];
	}
}




#pragma mark -
#pragma mark UIPickerViewDataSource

/*
* Number of components.
*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

/*
* Number of rows.
*/
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(pickerValues)]) {
		return [[delegate pickerValues] count];
	}
	return 0;
}

/*
* Titles.
*/
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(pickerLabel:)]) {
		return [delegate pickerLabel:row];
	}
	return nil;
}


#pragma mark -
#pragma mark UIPickerViewDelegate


/*
* Selected picker.
*/
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	FLog();
	// bugged (not called)
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[picker release];
    [super dealloc];
}



@end
