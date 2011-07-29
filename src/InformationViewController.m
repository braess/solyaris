//
//  InformationViewController.m
//  IMDG
//
//  Created by CNPP on 28.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "InformationViewController.h"



/**
 * Section Stack.
 */
@interface InformationViewController (SectionStack)
- (UIView *)sectionHeader:(NSString*)label;
@end

/**
 * InformationViewController.
 */
@implementation InformationViewController

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize movies = _movies;
@synthesize actors = _actors;
@synthesize directors = _directors;


#pragma mark -
#pragma mark View lifecycle


/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();

	
	// navigation bar: done button
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] 
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self 
                                action:@selector(actionDone:)];
	self.navigationItem.rightBarButtonItem = btnDone;
	[btnDone release];
	

	// remove background 
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;
    
    // sections
    _sectionGapHeight = 50;
    _sectionGapOffset = 10;
    _sectionGapInset = 40;
    self.tableView.sectionHeaderHeight = 0; 
    self.tableView.sectionFooterHeight = 0;
	    
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();


}


#pragma mark -
#pragma mark Actions

/*
 * Processing reset.
 */
- (void)actionDone:(id)sender {
	DLog();
	
	// dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(informationDismiss)]) {
		[delegate informationDismiss];
	}
}





#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 3;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // section
    switch (section) {
		case SectionInformationMovies: {
			return [_movies count];
            break;
		}
		case SectionInformationActors: {
			return [_actors count];
            break;
		}
        case SectionInformationDirectors: {
			return [_directors count];
            break;
		}
    }
    
    return 0;
}


/*
 * Customize the section header height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section]==0) {
        return 0.0000000000000000000000000001; // null is ignored...
    }
    return _sectionGapHeight;
}

/*
 * Customize the section footer height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

/*
 * Customize the section header.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // filler
    if ([self tableView:tableView numberOfRowsInSection:section]==0) {
        return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    // header
    else {
        return [self sectionHeader:[self tableView:tableView titleForHeaderInSection:section]];
    }
}
- (UIView *)sectionHeader:(NSString*)label {
    
    // view
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _sectionGapHeight)];
    
    // label
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(_sectionGapInset, _sectionGapOffset, shView.frame.size.width-2*_sectionGapInset, _sectionGapHeight-_sectionGapOffset)];
	lblHeader.backgroundColor = [UIColor clearColor];
	lblHeader.font = [UIFont fontWithName:@"HelveticaBold" size:15.0];
	lblHeader.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	lblHeader.shadowColor = [UIColor whiteColor];
	lblHeader.shadowOffset = CGSizeMake(1,1);
	lblHeader.opaque = YES;
	lblHeader.numberOfLines = 1;
    
    // text
    lblHeader.text = label;
    
    // add & release
    [shView addSubview:lblHeader];
    [lblHeader release];
    
    // and back
    return shView;
}

/*
 * Customize the footer view.
 */
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}




#pragma mark -
#pragma mark UITableViewDelegate Protocol

/*
 * Section titles.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// section
    switch (section) {
		case SectionInformationMovies: {
			if ([_movies count] > 0)  return NSLocalizedString(@"Movies",@"Movies");
            break;
		}
		case SectionInformationActors: {
			if ([_actors count] > 0)  return NSLocalizedString(@"Actors",@"Actors");
            break;
		}
        case SectionInformationDirectors: {
			if ([_directors count] > 0)  return NSLocalizedString(@"Directors",@"Directors");
            break;
		}
    }
    return nil;
    
}


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellInformationIdentifier = @"CellInformation";
	
	// create cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellInformationIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellInformationIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	
	// credits
	Information *nfo;
	if ([indexPath section] == SectionInformationMovies) {
		nfo = [_movies objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionInformationActors) {
		nfo = [_actors objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionInformationDirectors) {
		nfo = [_directors objectAtIndex:[indexPath row]];
	}
    
    // label
	cell.textLabel.text = nfo.value;
	cell.detailTextLabel.text = nfo.meta;

	// return
    return cell;
    
}


/*
 * Called when a table cell is selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FLog();

}


#pragma mark -
#pragma mark Memory management

/**
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // data
	[_movies release];
	[_actors release];
	[_directors release];
	
	// duper
    [super dealloc];
}


@end



/**
 * Information.
 */
@implementation Information

#pragma mark -
#pragma mark Properties

// accessors
@synthesize value;
@synthesize meta;
@synthesize type;
@synthesize nid;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initWithValue:(NSString *)v meta:(NSString *)m type:(NSString *)t nid:(NSNumber *)n {
    GLog();
    if ((self = [super init])) {
		self.value = v;
		self.meta = m;
		self.type = t;
        self.nid = n;
		return self;
	}
	return nil;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[value release];
	[meta release];
	[type release];
    [nid release];
	
	// super
    [super dealloc];
}

@end
