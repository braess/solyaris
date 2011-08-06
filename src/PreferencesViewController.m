//
//  PreferencesViewController.m
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "PreferencesViewController.h"
#import "IMDGConstants.h"

/*
 * Helper Stack.
 */
@interface PreferencesViewController (Helpers)
- (void)resetPreferences;
- (void)updatePreference:(NSString*)key value:(NSObject*)value;
- (void)updatePreferenceBool:(NSString*)key value:(BOOL)b;
@end


/**
 * Preferences Controller.
 */
@implementation PreferencesViewController

// constants
#define kKeyResetDefaults	@"key_reset_defaults"
#define kKeyClearCache      @"key_clear_cache"



#pragma mark -
#pragma mark View lifecycle

/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
    
	
	// remove background for iPhone
    self.tableView.scrollEnabled = NO;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;
    
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
#pragma mark Cell Delegates

/*
 * CellButton.
 */
- (void)cellButtonTouched:(CellButton *)c {
	GLog();
	
	// reset
	if ([c.key isEqualToString:kKeyResetDefaults]) {
		// action sheet
		UIActionSheet *resetAction = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"Reset all defaults?",@"Reset all defaults?")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                      destructiveButtonTitle:NSLocalizedString(@"Reset",@"Reset")
                                      otherButtonTitles:nil];
        
		// show
		[resetAction setTag:ActionPreferenceResetDefaults];
		[resetAction showInView:self.view];
		[resetAction release];
	}
    
    // clear
	if ([c.key isEqualToString:kKeyClearCache]) {
		// action sheet
		UIActionSheet *resetAction = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"Clear Cache?",@"Clear Cache?")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                      destructiveButtonTitle:NSLocalizedString(@"Clear",@"Clear")
                                      otherButtonTitles:nil];
        
		// show
		[resetAction setTag:ActionPreferenceClearCache];
		[resetAction showInView:self.view];
		[resetAction release];
	}
    
}

/*
 * CellSwitch.
 */
- (void)cellSwitchChanged:(CellSwitch *)c {
	GLog();
	
    
}


/*
 * CellSlider.
 */
- (void)cellSliderChanged:(CellSlider *)c {
	GLog();

}


#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog();
	
	// tag
	switch ([actionSheet tag]) {
            
        // reset
		case ActionPreferenceResetDefaults: {
            
			// reset
			if (buttonIndex == 0) {
				FLog("reset");
				[self resetPreferences];
			} 
			break;
		}
            
        // reset
		case ActionPreferenceClearCache: {
            
			// reset
			if (buttonIndex == 0) {
				FLog("clear");

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
	
    
	// update
	[self.tableView reloadData];
}

/*
 * Updates a preference.
 */
- (void)updatePreference:(NSString*)key value:(NSObject*)value {
	FLog();
    
	// update
	[self.tableView reloadData];
}
- (void)updatePreferenceBool:(NSString*)key value:(BOOL)b {
	FLog();
    
	// update
	[self.tableView reloadData];
}




#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	// count it
    return 4;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // section
    switch (section) {
		case SectionPreferencesGeneral: {
			return 1;
		}
        case SectionPreferencesGraph: {
			return 1;
		}
        case SectionPreferencesReset: {
			return 1;
		}
		case SectionPreferencesCache: {
			return 1;
		}
    }
    
    return 0;
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Section titles.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// section
    switch (section) {
		case SectionPreferencesGeneral: {
			return NSLocalizedString(@"General",@"General");
		}
        case SectionPreferencesGraph: {
			return NSLocalizedString(@"Graph",@"Graph");
		}
    }
    
    return nil;
}


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
	
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {
            
            // general
		case SectionPreferencesGeneral: {
            FLog("SectionPreferencesGeneral");
            
            
            // sound
            if ([indexPath row] == PreferenceGeneralSound) {
				
				// create cell
				CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
				if (cswitch == nil) {
					cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
				}	
				
				// enabled
				//BOOL disabled = [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udPreferenceSoundDisabled];
				BOOL disabled = NO;
                
				// prepare cell
				cswitch.delegate = self;
				cswitch.key = udPreferenceGeneralSound;
				cswitch.textLabel.text = NSLocalizedString(@"Sound",@"Sound");
				cswitch.switchAccessory.on = !(disabled);
				[cswitch update:YES];
				
				// set cell
				cell = cswitch;
                
			}
			
			
			// break it
			break; 
		}
            
            
        // graph
		case SectionPreferencesGraph: {
            FLog("SectionPreferencesGraph");
			
			// perimeter
            if ([indexPath row] == PreferenceGraphPerimeter) {
				
				// create cell
				CellSlider *cslider = (CellSlider*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSliderIndentifier];
				if (cslider == nil) {
					cslider = [[[CellSlider alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSliderIndentifier] autorelease];
				}	
				
				// prepare cell
                cslider.delegate = self;
                cslider.key = udPreferenceGraphPerimeter;
                cslider.textLabel.text = NSLocalizedString(@"Perimeter",@"Perimeter");
                cslider.sliderAccessory.minimumValue = 100;
                cslider.sliderAccessory.maximumValue = 600;
                cslider.sliderAccessory.value = 390;
                [cslider update:YES];
                
                // set
                cell = cslider;
                
			}
			
			
			// break it
			break; 
		}
            

            
        // reset
		case SectionPreferencesReset: {
            FLog("SectionPreferencesReset");
			
			// reset user defaults
            if ([indexPath row] == PreferenceResetDefaults) {
				
				// create cell
                CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPreferencesButtonIdentifier] autorelease];
				}		
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.key = kKeyResetDefaults;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Reset Defaults",@"Reset Defaults") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;
                
			}
            
            // no break till brooklin
			break; 
        }
            
        // cache
		case SectionPreferencesCache: {
            FLog("SectionPreferencesCache");
			
			// clear cache
            if ([indexPath row] == PreferenceCacheClear) {
				
				// create cell
                CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPreferencesButtonIdentifier] autorelease];
				}
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.key = kKeyClearCache;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Clear Cache",@"Clear Cache") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;
                
			}
			
			// break it
			break; 
		}
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
	
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
    
	
	// duper
    [super dealloc];
}


@end
