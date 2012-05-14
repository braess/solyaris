//
//  PreferencesViewController.m
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

#import "PreferencesViewController.h"
#import "SolyarisConstants.h"
#import "ActionBar.h"
#import "Tracker.h"

/*
 * Helper Stack.
 */
@interface PreferencesViewController (Helpers)
- (void)resetPreferences;
- (void)clearCache;
- (void)updatePreference:(NSString*)key value:(NSObject*)value;
- (NSString*)retrievePreference:(NSString*)key;
@end


/**
 * Preferences Controller.
 */
@implementation PreferencesViewController

#pragma mark -
#pragma mark Constants

// constants
#define kKeyReset           @"key_reset"
#define kKeyLocalization	@"key_localization"


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id)init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 480)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super initWithStyle:UITableViewStylePlain])) {
        
		// view
		vframe = frame;
        
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle

/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
    
    // self
    self.view.frame = vframe;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
	
	// remove background for iPhone
    self.tableView.scrollEnabled = NO;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // background view
    self.tableView.backgroundView = [[PreferencesBackgroundView alloc] initWithFrame:CGRectMake(0, 0, vframe.size.width, vframe.size.height)];
    
    
    // header
    CGRect hframe = CGRectMake(0, 0, vframe.size.width, kPreferencesHeaderHeight+kPreferencesHeaderGap);
    CGRect tframe = CGRectMake(0, 5, vframe.size.width-44, 18);
    CGRect cframe = CGRectMake(0, 23, vframe.size.width-44, 18);
    CGRect abframe = CGRectMake(0, vframe.size.height-kPreferencesFooterHeight+(iPad?5:2), vframe.size.width, 45);
    
    // header view
    UIView *hView = [[UIView alloc] initWithFrame:hframe];
    
    // title
    if (!iPad) {
        
        // label
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        lblTitle.shadowOffset = CGSizeMake(1,1);
        lblTitle.opaque = YES;
        lblTitle.numberOfLines = 1;
        [lblTitle setText:NSLocalizedString(@"Solyaris",@"Solyaris")];
        [hView addSubview:lblTitle];
        [lblTitle release];
    }
    
    // claim
	UILabel *lblClaim = [[UILabel alloc] initWithFrame:cframe];
	lblClaim.backgroundColor = [UIColor clearColor];
	lblClaim.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblClaim.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblClaim.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblClaim.shadowOffset = CGSizeMake(1,1);
	lblClaim.opaque = YES;
	lblClaim.numberOfLines = 1;
	[lblClaim setText:NSLocalizedString(@"Settings",@"Settings")];
	[hView addSubview:lblClaim];
	[lblClaim release];
    
    // set
    self.tableView.tableHeaderView = hView;
    
    
    // localization
    LocalizationViewController *locViewController = [[LocalizationViewController alloc] initWithFrame:CGRectMake(0, 0, 320, iPad?180:480)];
    locViewController.delegate = self;
    
    UINavigationController *locNavigationController = [[UINavigationController alloc] initWithRootViewController:locViewController];
    locNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    _localizationController = [locNavigationController retain];
    
    // ipad
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        
        // popover
        UIPopoverController *locPopoverController = [[UIPopoverController alloc] initWithContentViewController:_localizationController];
        [locPopoverController setPopoverContentSize:CGSizeMake(locViewController.view.frame.size.width, locViewController.view.frame.size.height)];
        locPopoverController.contentViewController.view.alpha = 0.9f;
        
        _localizationPopoverController = [locPopoverController retain];
        [locPopoverController release];
    }

    
    [locViewController release];
    [locNavigationController release];
    
    
    // actions
    ActionBar *actionBar = [[ActionBar alloc] initWithFrame:abframe];
    
    
    // flex
	UIBarButtonItem *itemFlex = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                 target:nil 
                                 action:nil];
    
    // negative space (weird 12px offset...)
    UIBarButtonItem *nspace = [[UIBarButtonItem alloc] 
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                               target:nil 
                               action:nil];
    nspace.width = -15;
    
    // action about
    ActionBarButtonItem *actionAbout = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_about.png"] 
                                                                           title:NSLocalizedString(@"About", @"About") 
                                                                          target:self 
                                                                          action:@selector(actionAbout:)];
    
    // action help
    ActionBarButtonItem *actionHelp = [[ActionBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action_help.png"] 
                                                                               title:NSLocalizedString(@"Help", @"Help") 
                                                                              target:self 
                                                                              action:@selector(actionHelp:)];
    
    // dark
    [actionAbout dark:YES];
    [actionHelp dark:YES];
    
    
    // actions
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [actions addObject:nspace];
    [actions addObject:actionHelp];
    [actions addObject:itemFlex];
    if (!iPad) {
        [actions addObject:actionAbout];
    }
    [actions addObject:nspace];
    
    
    // add & release actions
    [actionBar setItems:actions];
    [actionHelp release];
    [actionAbout release];
    [itemFlex release];
    [nspace release];
    [actions release];
    
    // add action bar
    [self.view addSubview:actionBar];
    
}


/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // reload
    [self.tableView reloadData];
    
}

#pragma mark -
#pragma mark Actions


/*
 * Action Help.
 */
- (void)actionHelp:(id)sender {
	DLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(preferencesHelp)]) {
        [delegate preferencesHelp];
    }
}

/*
 * Action About.
 */
- (void)actionAbout:(id)sender{
	DLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(preferencesAbout)]) {
        [delegate preferencesAbout];
    }
}



#pragma mark -
#pragma mark Cell Delegates

/*
 * CellButton.
 */
- (void)cellButtonTouched:(CellButton *)c {
	GLog();
    
    // localization
	if ([c.key isEqualToString:kKeyLocalization]) {
        FLog();
        
        // ipad
        if (iPad) {
            
            // dismiss
            if ([_localizationPopoverController isPopoverVisible]) {
                [_localizationPopoverController dismissPopoverAnimated:YES];
            } 
            
            // show girl
            else {
                [_localizationPopoverController.contentViewController.navigationController popToRootViewControllerAnimated:NO]; 
                [_localizationPopoverController presentPopoverFromRect:c.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES]; 
            }
        }
        else {
            
            // delegate
            if (delegate && [delegate respondsToSelector:@selector(preferencesModal:)]) {
                [delegate preferencesModal:YES];
            }
            
            // present
            [self presentModalViewController:_localizationController animated:YES];

        }
        

    }
	
	// reset
	if ([c.key isEqualToString:kKeyReset]) {
        
		// action sheet
		UIActionSheet *resetAction = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Reset Settings",@"Reset Settings"),NSLocalizedString(@"Clear Cache",@"Clear Cache"),nil];
        
		// show
		[resetAction showFromRect:c.frame inView:self.view animated:YES];
		[resetAction release];
	}
    
    
}



/*
 * CellSwitch.
 */
- (void)cellSwitchChanged:(CellSwitch *)c {
	GLog();
	
    // update
    bool v = c.switchAccessory.on;
    if (c.disabler) {
        v = ! v;
    }
    [self updatePreference:c.key value:(v ? @"1" : @"0")];
    
}


/*
 * CellSlider.
 */
- (void)cellSliderChanged:(CellSlider *)c {
	GLog();
    
    // update
    [self updatePreference:c.key value:[NSString stringWithFormat:@"%f", [c.sliderAccessory value]]];
}




#pragma mark -
#pragma mark Localization Delegate

/*
 * Get/Set localization.
 */
- (void)setLocalization:(NSString *)key value:(NSObject *)value {
    GLog();
    [self updatePreference:key value:value];
}
- (NSObject*)getLocalization:(NSString *)key {
    GLog();
    return [self retrievePreference:key];
}

/*
 * Dismiss.
 */
- (void)localizationDismiss {
    FLog();
    
    // dismissed
    [self dismissModalViewControllerAnimated:YES];
    
    // reset frame (apple bug?)
    [self.view setFrame:vframe];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(preferencesModal:)]) {
        [delegate preferencesModal:NO];
    }
    
}


#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	// tag
	switch ([actionSheet tag]) {
            
        // reset
		case ActionPreferenceReset: {
            
            // preference
			if (buttonIndex == 0) {
				FLog("preference");
                
                // action
				[self resetPreferences];
			} 
            // cache
			if (buttonIndex == 1) {
				FLog("cache");
				[self clearCache];
			} 
            // cancel
			if (buttonIndex == 2) {
				FLog("cancel");
			} 
			break;
		}
            
        // default
		default: {
			break;
		}
	}
	
	
}



#pragma mark -
#pragma mark Helpers


/*
 * Resets the preferences
 */
- (void)resetPreferences {
	FLog();
    
    // track
    [Tracker trackEvent:TEventPreferences action:@"Reset Defaults" label:@""];
	
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(preferencesResetDefaults)]) {
        [delegate preferencesResetDefaults];
    }
    
	// update
	[self.tableView reloadData];
}

/*
 * Clears the cache.
 */
- (void)clearCache {
    FLog();
    
    // track
    [Tracker trackEvent:TEventPreferences action:@"Clear Cache" label:@""];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(preferencesClearCache)]) {
        [delegate preferencesClearCache];
    }
}

/*
 * Updates a preference.
 */
- (void)updatePreference:(NSString*)key value:(NSObject*)value {
	GLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(setPreference:value:)]) {
        [delegate setPreference:key value:value];
    }
    


}

/*
 * Retrieves a preference.
 */
- (NSString*)retrievePreference:(NSString *)key {
    GLog();
    
    // preference
    NSString *pref = NULL;
    if (delegate && [delegate respondsToSelector:@selector(getPreference:)]) {
        pref = (NSString*) [delegate getPreference:key];
    }
    return pref;
}




#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


/*
 * Customize the section header height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellPreferencesIdentifier = @"CellPreferences";
	static NSString *CellPreferencesButtonIdentifier = @"CellPreferencesButton";
	static NSString *CellPreferencesSwitchIdentifier = @"CellPreferencesSwitch";
    static NSString *CellPreferencesSliderIndentifier = @"CellPreferencesSlider";
	
	// cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellPreferencesIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    // layout nodes
    if ([indexPath row] == PreferenceGraphLayoutNodes) {
        
        // create cell
        CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
        if (cswitch == nil) {
            cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
        }	
        
        // prepare cell
        cswitch.delegate = self;
        cswitch.key = udGraphLayoutNodesDisabled;
        cswitch.textLabel.text = NSLocalizedString(@"Graph Layout",@"Graph Layout");
        cswitch.help =  NSLocalizedString(@"Arrange nodes",@"Arrange nodes");
        cswitch.switchAccessory.on = YES;
        cswitch.disabler = YES;
        
        // enabled
        NSString *graphLayoutNodesDisabled = [self retrievePreference:udGraphLayoutNodesDisabled];
        if (graphLayoutNodesDisabled && [graphLayoutNodesDisabled isEqualToString:@"1"]) {
            cswitch.switchAccessory.on = NO;
        }
        [cswitch update:YES];
        
        // set cell
        cell = cswitch;
        
    }
    
    // layout subnodes
    if ([indexPath row] == PreferenceGraphLayoutSubnodes) {
        
        // create cell
        CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
        if (cswitch == nil) {
            cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
        }	
        
        // prepare cell
        cswitch.delegate = self;
        cswitch.key = udGraphLayoutSubnodesDisabled;
        cswitch.textLabel.text = NSLocalizedString(@"Node Layout",@"Node Layout");
        cswitch.help =  NSLocalizedString(@"Arrange children",@"Arrange children");
        cswitch.switchAccessory.on = YES;
        cswitch.disabler = YES;
        
        // enabled
        NSString *graphLayoutSubnodesDisabled = [self retrievePreference:udGraphLayoutSubnodesDisabled];
        if (graphLayoutSubnodesDisabled && [graphLayoutSubnodesDisabled isEqualToString:@"1"]) {
            cswitch.switchAccessory.on = NO;
        }
        [cswitch update:YES];
        
        // set cell
        cell = cswitch;
        
    }
    
    
    // crew
    if ([indexPath row] == PreferenceGraphCrewEnabled) {
        
        // create cell
        CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
        if (cswitch == nil) {
            cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
        }	
        
        // prepare cell
        cswitch.delegate = self;
        cswitch.key = udGraphCrewEnabled;
        cswitch.textLabel.text = NSLocalizedString(@"Crew",@"Crew");
        cswitch.help =  NSLocalizedString(@"Include Staff",@"Include Staff");
        cswitch.switchAccessory.on = NO;
        cswitch.disabler = NO;
        
        // enabled
        NSString *graphCrewEnabled = [self retrievePreference:udGraphCrewEnabled];
        if (graphCrewEnabled && [graphCrewEnabled isEqualToString:@"1"]) {
            cswitch.switchAccessory.on = YES;
        }
        [cswitch update:YES];
        
        // set cell
        cell = cswitch;
        
    }
    
    // graph children
    if ([indexPath row] == PreferenceGraphNodeInitial) {
        
        // create cell
        CellSlider *cslider = (CellSlider*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSliderIndentifier];
        if (cslider == nil) {
            cslider = [[[CellSlider alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSliderIndentifier] autorelease];
        }	
        
        // prepare cell
        cslider.delegate = self;
        cslider.key = udGraphNodeInitial;
        cslider.textLabel.text = NSLocalizedString(@"Node",@"Node");
        cslider.help =  NSLocalizedString(@"Initial",@"Initial");
        cslider.sliderAccessory.minimumValue = 0;
        cslider.sliderAccessory.maximumValue = 30;
        cslider.sliderAccessory.value = iPad ? 8 : 5;
        
        // preference
        NSString *graphNodeInitial = [self retrievePreference:udGraphNodeInitial];
        if (graphNodeInitial) {
            cslider.sliderAccessory.value = [graphNodeInitial floatValue];
        }
        [cslider update:YES];
        
        // set
        cell = cslider;
        
    }
    
    
    // edge length
    if ([indexPath row] == PreferenceGraphEdgeLength) {
        
        // create cell
        CellSlider *cslider = (CellSlider*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSliderIndentifier];
        if (cslider == nil) {
            cslider = [[[CellSlider alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSliderIndentifier] autorelease];
        }	
        
        // prepare cell
        cslider.delegate = self;
        cslider.key = udGraphEdgeLength;
        cslider.textLabel.text = NSLocalizedString(@"Edge",@"Edge");
        cslider.help =  NSLocalizedString(@"Length",@"Length");
        cslider.sliderAccessory.minimumValue = 180;
        cslider.sliderAccessory.maximumValue = 600;
        cslider.sliderAccessory.value = iPad ? 480 : 300;
        
        
        // preference
        NSString *graphEdgeLength = [self retrievePreference:udGraphEdgeLength];
        if (graphEdgeLength) {
            cslider.sliderAccessory.value = [graphEdgeLength floatValue];
        }
        [cslider update:YES];
        
        // set
        cell = cslider;
        
    }
    
    // localication
    if ([indexPath row] == PreferenceLocalization) {
        
        // create cell
        CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesButtonIdentifier];
        if (cbutton == nil) {
            cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesButtonIdentifier] autorelease];
        }		
        
        // prepare cell
        cbutton.delegate = self;
        cbutton.key = kKeyLocalization;
        cbutton.textLabel.text = NSLocalizedString(@"Localization",@"Localization");
        cbutton.help = NSLocalizedString(@"IMDb, Wikipedia, Amazon",@"IMDb, Wikipedia, Amazon");
        [cbutton.buttonAccessory setTitle:NSLocalizedString(@"Change",@"Change") forState:UIControlStateNormal];
        [cbutton update:YES];
        
        // set cell
        cell = cbutton;
        
    }
    
    
    // reset user defaults
    if ([indexPath row] == PreferenceReset) {
        
        // create cell
        CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesButtonIdentifier];
        if (cbutton == nil) {
            cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesButtonIdentifier] autorelease];
        }		
        
        // prepare cell
        cbutton.delegate = self;
        cbutton.key = kKeyReset;
        cbutton.help = NSLocalizedString(@"Settings, Cache",@"Settings, Cache");
        cbutton.textLabel.text = NSLocalizedString(@"Reset",@"Reset");
        [cbutton.buttonAccessory setTitle:NSLocalizedString(@"Reset",@"Reset") forState:UIControlStateNormal];
        [cbutton update:YES];
        
        // set cell
        cell = cbutton;
        
    }
    
	
	// return
    return cell;
}



#pragma mark -
#pragma mark Memory management


/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // self
	[_localizationPopoverController release];
	
	// duper
    [super dealloc];
}


@end



/**
 * PreferencesBackgroundView.
 */
@implementation PreferencesBackgroundView


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
    
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        
		// return
		return self;
	}
	
	// nop
	return nil;
}


/*
 * Draw that thing.
 */
- (void)drawRect:(CGRect)rect {
    
	// vars
	float w = self.frame.size.width;
	float h = self.frame.size.height;
    
    // rects
    CGRect mrect = CGRectMake(0, 0, w, h);
    
    
	// context
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
    CGContextSetShouldAntialias(context, NO);
	
	// background
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, mrect);
	
	// header lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.42 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, kPreferencesHeaderHeight-1);
	CGContextAddLineToPoint(context, w, kPreferencesHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, kPreferencesHeaderHeight);
	CGContextAddLineToPoint(context, w, kPreferencesHeaderHeight);
	CGContextStrokePath(context);
    
    // footer lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.42 alpha:1].CGColor);
	CGContextMoveToPoint(context, 0, h-kPreferencesFooterHeight);
	CGContextAddLineToPoint(context, w, h-kPreferencesFooterHeight);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, h-kPreferencesFooterHeight+1);
	CGContextAddLineToPoint(context, w, h-kPreferencesFooterHeight+1);
	CGContextStrokePath(context);
    
    
}


#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}

/*
 * Touches.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}



@end