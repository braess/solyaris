//
//  SearchResultViewController.m
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SearchResultViewController.h"
#import "IMDGConstants.h"


/**
 * SearchResultViewController.
 */
@implementation SearchResultViewController


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
    
    // button close
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self 
                                                                                          action:@selector(actionCancel:)];

    
    // data
    _type = [[NSMutableString alloc] init];
    _data = [[NSMutableArray alloc] init];
}




#pragma mark -
#pragma mark Business

/**
 * Shows the search results.
 */
- (void)searchResultShow:(Search*)search {
    
    
    // data
    [_type setString:search.type];
    for (SearchResult* s in search.data) {
        [_data addObject:s];
    }
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"data" ascending:TRUE];
	[_data sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	[sorter release];
    
    // title
    self.navigationItem.title = [NSString stringWithFormat:@"%i %@", [_data count], _type];
    
    // reload
    [self.tableView reloadData];
    
}


/**
 * Resets the search results.
 */
- (void)searchResultReset {
    
    // data
    [_data removeAllObjects];
    
    // title
    self.navigationItem.title = NSLocalizedString(@"Searching...", @"Searching...");
    
    
    // reload
    [self.tableView reloadData];

}



#pragma mark -
#pragma mark Actions

/*
 * Action cancel.
 */
- (void)actionCancel:(id)sender {
    FLog();
    
    // cancel
	if (delegate != nil && [delegate respondsToSelector:@selector(searchCancel)]) {
		[delegate searchCancel];
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
    return [_data count];
}


/*
 * Cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // identifiers
    static NSString *CellSearchResultIdentifier = @"CellSearchResult";
	
	// create cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSearchResultIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellSearchResultIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];

    
    // result 
    SearchResult *sr = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = sr.data;
    cell.detailTextLabel.text = @"";
    return cell;
}

/*
 * Selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLog();
    
    // delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(searchSelected:type:)]) {
		[delegate searchSelected:[_data objectAtIndex:indexPath.row] type:_type];
	}
}



#pragma mark -
#pragma mark Memory management


/*
 * Deallocates used memory.
 */
- (void)dealloc {
    GLog();
    
    // data
    [_type release];
    [_data release];
    
    // super
    [super dealloc];
}



@end
