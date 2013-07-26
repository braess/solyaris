//
//  DashboardViewController.h
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
#import "Appearance.h"


// Sections
enum {
    SectionDashboard
};

// Dashboard
enum {
	DashboardNowPlaying,
    DashboardPopular,
    DashboardFavorites,
    DashboardHistory
};

// Tabs
enum {
    DashboardTabMovie,
    DashboardTabPerson
};


/*
 * Delegate.
 */
@protocol DashboardDelegate <NSObject>
- (void)dashboardNowPlaying:(NSString*)type;
- (void)dashboardPopular:(NSString*)type;
- (void)dashboardHistory:(NSString*)type;
- (void)dashboardFavorites:(NSString*)type;
@end


/**
 * DashboardViewController.
 */
@interface DashboardViewController : UIViewController <SegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    // delegate
	id<DashboardDelegate>delegate;
    
    
    // private
    @private
    
    // ui
    UIView *_tabView;
    UITableView *_dashboard;
    
    // vars
    NSMutableString *_type;
    
    // modes
    BOOL mode_movie;

}

// Properties
@property (assign) id<DashboardDelegate> delegate;

// Business
- (void)reset;
- (void)update;

@end

