//
//  HeaderView.h
//  Solyaris
//
//  Created by Beat Raess on 3.5.2012.
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

// Constants
#define kHeaderHeight    44.0f


/**
 * HeaderDelegate Protocol.
 */
@protocol HeaderDelegate <NSObject>
@optional
- (void)headerBack;
@end


/**
 * HeaderView.
 */
@interface HeaderView : UIView {
    
    // delegate
	id<HeaderDelegate>delegate;
    
    
    // private
    @private
    
    // ui
    UIButton *_buttonBack;
    UILabel *_labelTitle;
    
    // modes
    BOOL mode_back;
}

// Properties
@property (assign) id<HeaderDelegate> delegate;

// Actions
- (void)actionBack:(id)sender;

// Business
- (void)head:(NSString*)title;

@end
