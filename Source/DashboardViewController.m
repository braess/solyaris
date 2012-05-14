//
//  DashboardViewController.m
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

#import "DashboardViewController.h"
#import "CellSearch.h"
#import "SolyarisConstants.h"




/**
 * DashboardViewController.
 */
@implementation DashboardViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

/*
 * Load.
 */
- (void)loadView {
    [super loadView];
    FLog();
    
    // self
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews = YES;
    
    
    // vars
    NSMutableString *strType = [[NSMutableString alloc] init];
    _type = [strType retain];
    [strType release];
    
    
    // dashboard
    UITableView *dashboard = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width,  self.view.frame.size.height-44) style:UITableViewStylePlain];
    dashboard.delegate = self;
    dashboard.dataSource = self;
    dashboard.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _dashboard = [dashboard retain];
    [self.view addSubview:_dashboard];
    [dashboard release];
    
    
    // tab
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tabView.backgroundColor = [UIColor clearColor];
    
    _tabView = [tabView retain];
    [self.view addSubview:tabView];
    [tabView release];
    
    // segment
    SegmentedControl *segments = [[SegmentedControl alloc] initWithTitles:[NSArray arrayWithObjects:NSLocalizedString(@"Movie", @"Movie"),NSLocalizedString(@"People", @"People"), nil]];
    segments.delegate = self;
    segments.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    CGRect segFrame = segments.frame;
    segFrame.origin.x = (_tabView.frame.size.width-segFrame.size.width)/2.0;
    segFrame.origin.y = 6;
    segments.frame = segFrame;
    
    
    // reset
    [self reset];
    
    // select
    [segments select:mode_movie ? 0 : 1];
    
    // add
    [_tabView addSubview:segments];
    [segments release];

    
}


#pragma mark -
#pragma mark Business



/**
 * Resets the controller.
 */
- (void)reset {
    GLog();
    
    // defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // current
    NSString *currentType = (NSString*) [defaults objectForKey:udSearchType];
    currentType = currentType ? currentType : typeMovie;
    
    // reset mode
    mode_movie = [currentType isEqualToString:typeMovie];
    
    // reset type
    [_type setString:currentType];
    
}

/**
 * Updates the controller.
 */
- (void)update {
    GLog();
    
    // reload
    [_dashboard reloadData];
}



#pragma mark -
#pragma mark SegmentedControl Delegate

/*
 * Segment selected.
 */
- (void)segmentedControlTouched:(NSUInteger)segmentIndex {
    FLog();
    
    // defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    // current
    NSString *currentType = (NSString*) [defaults objectForKey:udSearchType];
    currentType = currentType ? currentType : typeMovie;
    
    // switch
    BOOL changed = NO;
    switch (segmentIndex) {
            
        // movie
        case DashboardTabMovie: {
            
            // check
            if (! [currentType isEqualToString:typeMovie]) {
                
                // update
                [defaults setObject:typeMovie forKey:udSearchType];
                changed = YES;
            }
            break;
        }
            
        // person
        case DashboardTabPerson: {
            
            // check
            if (! [currentType isEqualToString:typePerson]) {
                
                // update
                [defaults setObject:typePerson forKey:udSearchType];
                changed = YES;
            }
            break;
        }
            
        default:
            break;
    }
    
    // changed
    if (changed) {
        
        // sync
        [defaults synchronize];
        
        // reset
        [self reset];
        [self update];
    }
    
    
}




#pragma mark -
#pragma mark Table View


/*
 * Sections.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


/*
 * Rows.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return mode_movie ? 3 : 1;
}

/*
 * Customize the cell height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellSearchHeight;
}


/*
 * Cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLog();
    
    // identifiers
    static NSString *CellSearchDashboardIdentifier = @"CellSearchDashboard";
	
	// create cell
	CellSearch *cell = (CellSearch*) [tableView dequeueReusableCellWithIdentifier:CellSearchDashboardIdentifier];
	if (cell == nil) {
		cell = [[[CellSearch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellSearchDashboardIdentifier] autorelease];
	}
	
    // reset
    [cell reset];
    
    //  section 
    NSUInteger section = [indexPath section];
    switch (section) {
            
        // dashboard
        case SectionDashboard: {
            
            // adjust index
            int indx = mode_movie ? [indexPath row] : [indexPath row]+2;
            
            // now
            if (indx == DashboardNowPlaying) {
                
                // title
                [cell.labelData setText:NSLocalizedString(@"Now Playing", @"Now Playing")];
            }
            
            // popular
            if (indx == DashboardPopular) {
                
                // title
                [cell.labelData setText:[NSString stringWithFormat:@"%@",mode_movie ? NSLocalizedString(@"Popular Movies", @"Popular Movies") : NSLocalizedString(@"Popular People", @"Popular People") ]];
            }
            
            // history
            if (indx == DashboardHistory) {
                
                // title
                [cell.labelData setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Browse History", @"Browse History")]];
            }
            
			
			// have a break
			break;            
        }
    }
    
    // prepare
    [cell disclosure];
    [cell update];
    
    
    // return
    return cell;
}


/*
 * Selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLog();
    
    //  section 
    NSUInteger section = [indexPath section];
    switch (section) {
            
        // dashboard
        case SectionDashboard: {
            
            // adjust index
            int indx = mode_movie ? [indexPath row] : [indexPath row]+2;
            
            // now
            if (indx == DashboardNowPlaying) {
                
                // delegate
                if (delegate && [delegate respondsToSelector:@selector(dashboardNowPlaying:)]) {
                    [delegate dashboardNowPlaying:_type];
                }
            }
            
            // popular
            if (indx == DashboardPopular) {
                
                // delegate
                if (delegate && [delegate respondsToSelector:@selector(dashboardPopular:)]) {
                    [delegate dashboardPopular:_type];
                }
            }
            
            // history
            if (indx == DashboardHistory) {
                
                // delegate
                if (delegate && [delegate respondsToSelector:@selector(dashboardHistory:)]) {
                    [delegate dashboardHistory:_type];
                }
            }

			
			// have a break
			break;            
        }
    }

}



#pragma mark -
#pragma mark Memory management


/*
 * Deallocates used memory.
 */
- (void)dealloc {
    GLog();
    
    // ui
    [_tabView release];
    [_dashboard release];
    
    // vars
    [_type release];
    
    // super
    [super dealloc];
}


@end