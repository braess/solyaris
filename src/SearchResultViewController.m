//
//  SearchResultViewController.m
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SearchResultViewController.h"


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
- (void)showResults:(Search*)search {
    
    
    // data
    [_type setString:search.type];
    for (SearchResult* s in search.data) {
        [_data addObject:s];
    }
    
    // sort
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"data" ascending:YES];
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
- (void)resetResults {
    
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
	if (delegate != nil && [delegate respondsToSelector:@selector(cancelSearch)]) {
		[delegate cancelSearch];
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
    
    
    // Identifier
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure 
    SearchResult *sr = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = sr.data;
    return cell;
}

/*
 * Selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLog();
    
    // delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(selectedResult:type:)]) {
		[delegate selectedResult:[_data objectAtIndex:indexPath.row] type:_type];
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
