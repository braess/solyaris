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
- (NSString*)retrievePreference:(NSString*)key;
@end


/**
 * Preferences Controller.
 */
@implementation PreferencesViewController

#pragma mark -
#pragma mark Constants

// constants
#define kKeyResetDefaults	@"key_reset_defaults"
#define kKeyClearCache      @"key_clear_cache"

// local vars
static int preferencesHeaderHeight = 45;
static int preferencesHeaderGap = 10;


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;




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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // background view
    self.tableView.backgroundView = [[PreferencesBackgroundView alloc] initWithFrame:self.view.frame];
    
    
    // header
    CGRect hframe = CGRectMake(0, 0, self.view.frame.size.width, preferencesHeaderHeight+preferencesHeaderGap);
    CGRect tframe = CGRectMake(0, 18, self.view.frame.size.width, 18);
    
    // header view
    UIView *hView = [[UIView alloc] initWithFrame:hframe];
    
    // title
	UILabel *lblTitle = [[UILabel alloc] initWithFrame:tframe];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
	lblTitle.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	lblTitle.shadowOffset = CGSizeMake(1,1);
	lblTitle.opaque = YES;
	lblTitle.numberOfLines = 1;
	[lblTitle setText:NSLocalizedString(@"Settings",@"Settings")];
	[hView addSubview:lblTitle];
	[lblTitle release];
    
    // set
    self.tableView.tableHeaderView = hView;
    
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
		[resetAction showFromRect:c.frame inView:self.view animated:YES];
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
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
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
	
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(resetPreferences)]) {
        [delegate resetPreferences];
    }
    
	// update
	[self.tableView reloadData];
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
    return 6;
}


/*
 * Customize the section header height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
    
    
    // hint
    if ([indexPath row] == PreferenceGraphHintDisabled) {
        
        // create cell
        CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
        if (cswitch == nil) {
            cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
        }	
        
        // prepare cell
        cswitch.delegate = self;
        cswitch.key = udGraphHintDisabled;
        cswitch.textLabel.text = NSLocalizedString(@"Hints",@"Hints");
        cswitch.switchAccessory.on = YES;
        cswitch.disabler = YES;
        
        // enabled
        NSString *graphHintDisabled = [self retrievePreference:udGraphHintDisabled];
        if (graphHintDisabled && [graphHintDisabled isEqualToString:@"1"]) {
            cswitch.switchAccessory.on = NO;
        }
        [cswitch update:YES];
        
        // set cell
        cell = cswitch;
        
    }
    
    // crew
    if ([indexPath row] == PreferenceGraphNodeCrewEnabled) {
        
        // create cell
        CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
        if (cswitch == nil) {
            cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
        }	
        
        // prepare cell
        cswitch.delegate = self;
        cswitch.key = udGraphNodeCrewEnabled;
        cswitch.textLabel.text = NSLocalizedString(@"Crew",@"Crew");
        cswitch.switchAccessory.on = NO;
        cswitch.disabler = NO;
        
        // enabled
        NSString *graphNodeCrewEnabled = [self retrievePreference:udGraphNodeCrewEnabled];
        if (graphNodeCrewEnabled && [graphNodeCrewEnabled isEqualToString:@"1"]) {
            cswitch.switchAccessory.on = YES;
        }
        [cswitch update:YES];
        
        // set cell
        cell = cswitch;
        
    }
    
    // graph
    if ([indexPath row] == PreferenceGraphNodeChildren) {
        
        // create cell
        CellSlider *cslider = (CellSlider*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSliderIndentifier];
        if (cslider == nil) {
            cslider = [[[CellSlider alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSliderIndentifier] autorelease];
        }	
        
        // prepare cell
        cslider.delegate = self;
        cslider.key = udGraphNodeChildren;
        cslider.textLabel.text = NSLocalizedString(@"Children",@"Children");
        cslider.sliderAccessory.minimumValue = 0;
        cslider.sliderAccessory.maximumValue = 30;
        cslider.sliderAccessory.value = 12;
        
        // preference
        NSString *graphNodeChildren = [self retrievePreference:udGraphNodeChildren];
        if (graphNodeChildren) {
            cslider.sliderAccessory.value = [graphNodeChildren floatValue];
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
        cslider.textLabel.text = NSLocalizedString(@"Length",@"Length");
        cslider.sliderAccessory.minimumValue = 200;
        cslider.sliderAccessory.maximumValue = 600;
        cslider.sliderAccessory.value = 400;
        
        
        // preference
        NSString *graphEdgeLength = [self retrievePreference:udGraphEdgeLength];
        if (graphEdgeLength) {
            cslider.sliderAccessory.value = [graphEdgeLength floatValue];
        }
        [cslider update:YES];
        
        // set
        cell = cslider;
        
    }
    
    
    
    // reset user defaults
    if ([indexPath row] == PreferenceDefaultsReset) {
        
        // create cell
        CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesButtonIdentifier];
        if (cbutton == nil) {
            cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPreferencesButtonIdentifier] autorelease];
        }		
        
        // prepare cell
        cbutton.delegate = self;
        cbutton.key = kKeyResetDefaults;
        cbutton.textLabel.text = NSLocalizedString(@"Defaults",@"Defaults");
        cbutton.detailTextLabel.text = NSLocalizedString(@"Reset Defaults",@"Reset Defaults");
        [cbutton.buttonAccessory setTitle:NSLocalizedString(@"Reset",@"Reset") forState:UIControlStateNormal];
        [cbutton update:YES];
        
        // set cell
        cell = cbutton;
        
    }
    
    
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
        cbutton.textLabel.text = NSLocalizedString(@"Cache",@"Cache");
        cbutton.detailTextLabel.text = NSLocalizedString(@"Clear Cached Data",@"Clear Cached Data");
        [cbutton.buttonAccessory setTitle:NSLocalizedString(@"Clear",@"Clear") forState:UIControlStateNormal];
        [cbutton update:YES];
        
        // set cell
        cell = cbutton;
        
    }

	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.detailTextLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    cell.imageView.image = [UIImage imageNamed:@"icon_preference.png"];
	
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
	CGContextMoveToPoint(context, 0, preferencesHeaderHeight-1);
	CGContextAddLineToPoint(context, w, preferencesHeaderHeight-1);
	CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
	CGContextMoveToPoint(context, 0, preferencesHeaderHeight);
	CGContextAddLineToPoint(context, w, preferencesHeaderHeight);
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