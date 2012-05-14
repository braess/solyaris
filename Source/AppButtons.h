//
//  AppButtons.h
//  Solyaris
//
//  Created by Beat Raess on 4.5.2012.
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


/**
 * Button.
 */
@interface Button : UIButton {
    
}
@end



/**
 * LinkButtonDelegate Protocol.
 */
@class LinkButton;
@protocol LinkButtonDelegate <NSObject>
- (void)linkButtonTouched:(LinkButton*)lb;
@optional
- (void)linkButtonDown:(LinkButton*)lb;
- (void)linkButtonUp:(LinkButton*)lb;
@end


/**
 * Link Button.
 */
@interface LinkButton : UIButton {
    
    // delegate
	id<LinkButtonDelegate>delegate;
    
    // link
    NSString *_link;
    
    // private
@private
    BOOL mode_transparent;
}

// Properties
@property (assign) id<LinkButtonDelegate> delegate;
@property (nonatomic, retain) NSString *link;

// Business
- (void)transparent:(BOOL)flag;

@end
