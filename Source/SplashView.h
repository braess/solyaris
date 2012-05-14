//
//  SplashView.h
//  Solyaris
//
//  Created by CNPP on 30.9.2011.
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

/**
 * HeaderDelegate Protocol.
 */
@protocol SplashDelegate<NSObject>
@optional
- (void)splashDismiss;
@end

/**
 * SplashView.
 */
@interface SplashView : UIView {
    
    // delegate
	id<SplashDelegate>delegate;
    
    // ui
    UIImageView *_splash;
}

// Properties
@property (assign) id<SplashDelegate> delegate;

// Business
- (void)dismissSplash;

@end
