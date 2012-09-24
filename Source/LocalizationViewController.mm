//
//  LocalizationViewController.m
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

#import "LocalizationViewController.h"
#import "SolyarisConstants.h"


/*
 * Helper Stack.
 */
@interface LocalizationViewController (Helpers)
- (NSString*)retrieveLocalization:(NSString*)key;
@end


/**
 * Preferences Controller.
 */
@implementation LocalizationViewController

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
        
        // localization
        _sloc = [[SolyarisLocalization alloc] init];
        
        // disable scroll
        self.tableView.scrollEnabled = NO;
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
    
    // title
    self.title = NSLocalizedString(@"Localization", @"Localization");
    
    // self
    self.view.frame = vframe;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    // modal
    if (! iPad) {
        
        // done
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] 
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self 
                                    action:@selector(actionDone:)];
        self.navigationItem.rightBarButtonItem = btnDone;
        [btnDone release];
    }
   
}


/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // size
	self.contentSizeForViewInPopover = CGSizeMake(vframe.size.width, vframe.size.height);
    
    // reload
    [self.tableView reloadData];
    
}


/*
 * Rotation.
 */
- (BOOL)shouldAutorotate {
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}




#pragma mark -
#pragma mark Actions

/*
 * Action done.
 */
- (void)actionDone:(id)sender {
    DLog();
    
    // set localization
    if (delegate && [delegate respondsToSelector:@selector(localizationDismiss)]) {
        [delegate localizationDismiss];
    }
}



#pragma mark -
#pragma mark Cell Delegates


/*
 * CellPicker.
 */
- (void)cellPickerChanged:(CellPicker *)c {
	FLog();
	
    // set localization
    if (delegate && [delegate respondsToSelector:@selector(setLocalization:value:)]) {
        [delegate setLocalization:c.key value:c.pvalue];
    }
     
	// back
	//[self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Helpers

/*
 * Retrieves a localization.
 */
- (NSString*)retrieveLocalization:(NSString *)key {
    GLog();
    
    // preference
    NSString *loc = NULL;
    if (delegate && [delegate respondsToSelector:@selector(getLocalization:)]) {
        loc = (NSString*) [delegate getLocalization:key];
    }
    return loc;
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
    return 3;
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellLocalizationPickerIdentifier = @"CellLocalizationPicker";
	
	// cell
	UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellLocalizationPickerIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellLocalizationPickerIdentifier] autorelease];
	}
    
    // imdb
    if ([indexPath row] == LocalizationIMDb) {
        
        // create cell
		CellPicker *cpicker = (CellPicker*) [tableView dequeueReusableCellWithIdentifier:CellLocalizationPickerIdentifier];
		if (cpicker == nil) {
			cpicker = [[[CellPicker alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellLocalizationPickerIdentifier] autorelease];
		}
        
        // current
        NSString *locIMDb = [self retrieveLocalization:udLocalizationIMDb];
        locIMDb = locIMDb ? locIMDb : kLocalizedDefaultIMDb;
		

		// picker values
        int index = 0;
        NSArray *properties = [_sloc propertiesIMDb];
		NSMutableArray *pdata = [[NSMutableArray alloc] init];
        for (LocalizationProperty *lp in properties) {
            
            // picker data
            PickerData *pd = [[PickerData alloc] initWithIndex:index label:lp.label value:lp.key];
            [pdata addObject:pd];
            [pd release];
            
            // set cell
			if ([lp.key isEqualToString:locIMDb]) {
                cpicker.pindex = index;
				cpicker.pvalue = lp.key;
				cpicker.plabel = lp.label;
			}
            
            // index
            index++;

        }

		
		// prepare cell
		cpicker.delegate = self;
        cpicker.clear = NO;
		cpicker.key = udLocalizationIMDb;
		cpicker.label = NSLocalizedString(@"IMDb Site", @"IMDb Site");
		cpicker.values = pdata;
        cpicker.textLabel.text = NSLocalizedString(@"IMDb", @"IMDb");
		[cpicker update:YES];
		
		// release
		[pdata release];
		
		// set
		cell = cpicker;
        
    }
    
    // wikipedia
    if ([indexPath row] == LocalizationWikipedia) {
        
        // create cell
		CellPicker *cpicker = (CellPicker*) [tableView dequeueReusableCellWithIdentifier:CellLocalizationPickerIdentifier];
		if (cpicker == nil) {
			cpicker = [[[CellPicker alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellLocalizationPickerIdentifier] autorelease];
		}
        
        // current
        NSString *locWikipedia = [self retrieveLocalization:udLocalizationWikipedia];
        locWikipedia = locWikipedia ? locWikipedia : kLocalizedDefaultWikipedia;
		
        
		// picker values
        int index = 0;
        NSArray *properties = [_sloc propertiesWikipedia];
		NSMutableArray *pdata = [[NSMutableArray alloc] init];
        for (LocalizationProperty *lp in properties) {
            
            // picker data
            PickerData *pd = [[PickerData alloc] initWithIndex:index label:lp.label value:lp.key];
            [pdata addObject:pd];
            [pd release];
            
            // set cell
			if ([lp.key isEqualToString:locWikipedia]) {
                cpicker.pindex = index;
				cpicker.pvalue = lp.key;
				cpicker.plabel = lp.label;
			}
            
            // index
            index++;
            
        }
        
		
		// prepare cell
		cpicker.delegate = self;
        cpicker.clear = NO;
		cpicker.key = udLocalizationWikipedia;
		cpicker.label = NSLocalizedString(@"Wikipedia Site", @"Wikipedia Site");
		cpicker.values = pdata;
        cpicker.textLabel.text = NSLocalizedString(@"Wikipedia", @"Wikipedia");
		[cpicker update:YES];
		
		// release
		[pdata release];
		
		// set
		cell = cpicker;

    }
    
    // amazon
    if ([indexPath row] == LocalizationAmazon) {
        
        // create cell
		CellPicker *cpicker = (CellPicker*) [tableView dequeueReusableCellWithIdentifier:CellLocalizationPickerIdentifier];
		if (cpicker == nil) {
			cpicker = [[[CellPicker alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellLocalizationPickerIdentifier] autorelease];
		}
        
        // current
        NSString *locAmazon = [self retrieveLocalization:udLocalizationAmazon];
        locAmazon = locAmazon ? locAmazon : kLocalizedDefaultAmazon;
		
        
		// picker values
        int index = 0;
        NSArray *properties = [_sloc propertiesAmazon];
		NSMutableArray *pdata = [[NSMutableArray alloc] init];
        for (LocalizationProperty *lp in properties) {
            
            // picker data
            PickerData *pd = [[PickerData alloc] initWithIndex:index label:lp.label value:lp.key];
            [pdata addObject:pd];
            [pd release];
            
            // set cell
			if ([lp.key isEqualToString:locAmazon]) {
                cpicker.pindex = index;
				cpicker.pvalue = lp.key;
				cpicker.plabel = lp.label;
			}
            
            // index
            index++;
            
        }
        
		
		// prepare cell
		cpicker.delegate = self;
        cpicker.clear = NO;
		cpicker.key = udLocalizationAmazon;
		cpicker.label = NSLocalizedString(@"Amazon Site", @"Amazon Site");
		cpicker.values = pdata;
        cpicker.textLabel.text = NSLocalizedString(@"Amazon", @"Amazon");
		[cpicker update:YES];
		
		// release
		[pdata release];
		
		// set
		cell = cpicker;
        
    }    
	
	// return
    return cell;
}




/*
 * Called when a table cell is selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FLog();
	
	// cell
    CellPicker *cpicker = (CellPicker*) [tableView cellForRowAtIndexPath:indexPath];
    
    // push controller
    [self.navigationController pushViewController:[cpicker pickerViewController] animated:YES];
	
}


#pragma mark -
#pragma mark Memory management


/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // alf
    [_sloc release];
	
	// duper
    [super dealloc];
}





@end
