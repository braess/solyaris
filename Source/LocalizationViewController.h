//
//  LocalizationViewController.h
//  Solyaris
//
//  Created by Beat Raess on 16.12.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
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
#import "CellPicker.h"
#import "SolyarisLocalization.h"


/*
 * LocalizationDelegate.
 */
@protocol LocalizationDelegate <NSObject>
- (void)setLocalization:(NSString*)key value:(NSObject*)value;
- (NSObject*)getLocalization:(NSString*)key;
- (void)localizationDismiss;
@end


//  Fields
enum {
    LocalizationWikipedia,
    LocalizationAmazon
};

/**
 * Preferences Controller.
 */
@interface LocalizationViewController : UITableViewController <CellPickerDelegate> {
    
    // delegate
	id<LocalizationDelegate> delegate;
    
    // private
    @private
    CGRect vframe;
    SolyarisLocalization *_sloc;

}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Properties
@property (assign) id<LocalizationDelegate> delegate;


// Actions
- (void)actionDone:(id)sender;

@end
