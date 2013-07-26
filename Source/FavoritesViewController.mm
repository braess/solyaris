//
//  FavoritesViewController.m
//  Solyaris
//
//  Created by CNPP on 04.01.13.
//
//

#import "FavoritesViewController.h"
#import "SolyarisAppDelegate.h"
#import "SolyarisConstants.h"
#import "CellData.h"
#import "Tracker.h"


/**
 * Fetch Stack.
 */
@interface FavoritesViewController (FetchStack)
- (Favorite*)fetch_favorite:(NSIndexPath*)ip;
@end


/**
 * FavoritesViewController.
 */
@implementation FavoritesViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize type = type__;
@synthesize fetched_favorites = fetched_favorites__;
@synthesize header = _header;



#pragma mark -
#pragma mark Object 

/*
 * Init.
 */
- (id)init {
    GLog();
    
    // super
    if ((self = [super init])) {
        
        // data manager
        SolyarisDataManager *solyarisDM = [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] solyarisDataManager];
        _solyarisDataManager = [solyarisDM retain];
        
    }
    return self;
}



#pragma mark -
#pragma mark Controller

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
    
    // frames
    CGRect fHeader = CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight);
    CGRect fContent = CGRectMake(0, kHeaderHeight, self.view.frame.size.width, self.view.frame.size.height-kHeaderHeight);
    
    // header
    HeaderView *header = [[HeaderView alloc] initWithFrame:fHeader];
    header.delegate = self;
    header.edit = YES;
    
    // iphone
    if (! iPad) {
        header.action = YES;
        [header.buttonAction setImage:[UIImage imageNamed:@"btn_email.png"] forState:UIControlStateNormal];
    }
    
    // assign
    self.header = header;
    [self.view addSubview:self.header];
    [header release];
    
    // favorites
    UITableView *favorites = [[UITableView alloc] initWithFrame:fContent style:UITableViewStylePlain];
    favorites.delegate = self;
    favorites.dataSource = self;
    favorites.separatorColor = [UIColor clearColor];
    favorites.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _favorites = [favorites retain];
    [self.view addSubview:_favorites];
    [favorites release];
    
}

/*
 * View loaded.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    FLog();
    
    // fetch
    NSError *error = nil;
    [self.fetched_favorites performFetch:&error];
}

/*
 * Appear.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog();
    
    // track
    [Tracker trackView:[self.type isEqualToString:typePerson] ? @"FavoritesPerson" : @"FavoritesMovie"];
    
    // update
    [self update];
}

/*
 * Disappear.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FLog();
    
    // editing
    if (_favorites.editing) {
        [self headerEditCancel];
    }
}




#pragma mark -
#pragma mark Business


/**
 * Updates the controller.
 */
- (void)update {
    GLog();
    
    // stat
    int fcount = [[self.fetched_favorites fetchedObjects] count];
    
    // header
    [self.header head:[NSString stringWithFormat:@"%@ (%i)",NSLocalizedString(@"Favorites", @"Favorites"),fcount]];
    
    // buttons
    self.header.buttonEdit.enabled = fcount > 0 ? YES : NO;
    self.header.buttonAction.enabled = fcount > 0 ? YES : NO;
    
    // data
    [_favorites reloadData];
    
}



#pragma mark -
#pragma mark Export

/*
 * Export favorites.
 */
- (void)exportFavorites {
    FLog();
    
    // html export
    NSString *html_export = [_solyarisDataManager managerExportFavorites:self.type];
    if (html_export == nil) {
        
        // show info
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Favorites",@"Favorites")
                              message:NSLocalizedString(@"No favorites to export.",@"No favorites to export.")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                              otherButtonTitles:nil];
        [alert setTag:AlertFavoritesNone];
        [alert show];    
        [alert release];
        
        // nop
        return;
    }
    
    
    // email
    if ([MailComposeController canSendMail]) {
        
        // track
        [Tracker trackEvent:TEventFavorites action:@"Export" label:@""];
        
        // mail composer
		MailComposeController *composer = [[MailComposeController alloc] init];
		composer.mailComposeDelegate = self;
        
        // ipad
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            composer.modalPresentationStyle = UIModalPresentationFormSheet;
            composer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        }
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[%@] %@",NSLocalizedString(@"Solyaris", @"Solyaris"),[self.type isEqualToString:typePerson] ? NSLocalizedString(@"Favorite Persons", @"Favorite Persons") : NSLocalizedString(@"Favorite Movies", @"Favorite Movies")]];
        
		// message
		[composer setMessageBody:html_export isHTML:YES];
        
		// present
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composer animated:YES completion:nil];
        
		// release
		[composer release];
    }
    
}


#pragma mark -
#pragma mark Header

/*
 * Header back.
 */
- (void)headerBack {
    FLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(favoritesDismiss)]) {
        [delegate favoritesDismiss];
    }
}

/*
 * Header edit.
 */
- (void)headerEdit {
    FLog();
    
    // track
    [Tracker trackEvent:TEventFavorites action:@"Edit" label:@""];
    
    // mode
    mode_editing = YES;
    
    // transaction
    [_solyarisDataManager cdTransactionBegin:@"FAVORITES"];
    
    // editing
    [_favorites setEditing:YES animated:YES];
}
- (void)headerEditDone {
    FLog();
    
    // mode
    mode_editing = NO;
    
    // transaction
    [_solyarisDataManager cdTransactionEnd:@"FAVORITES" persist:YES];
    
    // editing
    [_favorites setEditing:NO animated:NO];
    
    // update
    [self update];
}
- (void)headerEditCancel {
    FLog();
    
    // mode
    mode_editing = NO;
    
    // transaction
    [_solyarisDataManager cdTransactionEnd:@"FAVORITES" persist:NO];
    
    // editing
    [_favorites setEditing:NO animated:NO];
    
    // update
    [self update];
}

/*
 * Header action.
 */
- (void)headerAction {
    FLog();
    
    // export
    [self exportFavorites];
}



#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Protocol

/*
 * Dismisses the email composition interface.
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	FLog();
	
	// result
	switch (result) {
		case MFMailComposeResultCancelled:
			FLog("Email: canceled");
			break;
		case MFMailComposeResultSaved:
			FLog("Email: saved");
			break;
		case MFMailComposeResultSent:
			FLog("Email: sent");
			break;
		case MFMailComposeResultFailed:
			FLog("Email: failed");
			break;
		default:
			FLog("Email: not sent");
			break;
	}
	
	// close modal
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark -
#pragma mark Fetched Sets


/*
 * Fetch controller.
 */
- (NSFetchedResultsController *)fetched_favorites {
    
    // setup
    if (fetched_favorites__ == nil) {
        
        // fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:_solyarisDataManager.managedObjectContext];
        [request setEntity:entity];
        
        // sort descriptors
        NSSortDescriptor *titleSorter = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSSortDescriptor *sortSorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortSorter,titleSorter,nil];
        [request setSortDescriptors:sortDescriptors];
        
        // predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(type = %@)", self.type];
        [request setPredicate:predicate];
        
        // controller
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_solyarisDataManager.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        
        // assign
        self.fetched_favorites = fetchedResultsController;
        
        // release
        [fetchedResultsController release];
        [request release];
        [titleSorter release];
        [sortSorter release];
        [sortDescriptors release];
    }
	
	return fetched_favorites__;
}

/*
 * Fetch favorite.
 */
- (Favorite*)fetch_favorite:(NSIndexPath*)ip {
    return [self.fetched_favorites objectAtIndexPath:ip];
}


/*
 * Controller begins processing of changes.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	FLog("<FETCH_FAVORITE>");
    
    // prepare
	[_favorites beginUpdates];
}


/*
 * Content changed.
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    // update table view
	switch(type) {
            
        // insert
		case NSFetchedResultsChangeInsert:
            FLog("NSFetchedResultsChangeInsert");
			[_favorites insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
        // delete
		case NSFetchedResultsChangeDelete:
            FLog("NSFetchedResultsChangeDelete");
			[_favorites deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
        // update
		case NSFetchedResultsChangeUpdate:
            FLog("NSFetchedResultsChangeUpdate");
			break;
            
        // move
		case NSFetchedResultsChangeMove:
            FLog("NSFetchedResultsChangeMove");
            break;
	}
}

/*
 * Controller completed processing of changes.
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    FLog("</FETCH_FAVORITE>");
    
	// process updates
	[_favorites endUpdates];
}



#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return fetched_favorites__ == nil ? 0 : [[self.fetched_favorites sections] count];
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // rows
    if ([[self.fetched_favorites sections] count] > 0) {
        return [[[self.fetched_favorites sections] objectAtIndex:section] numberOfObjects];
    }
    return 0;
}


/*
 * Header view.
 */
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // header
    if (! mode_editing && [[self.fetched_favorites fetchedObjects] count] <= 0) {
        
        // vars
        float inset = 10;
        float head = 70;
        float margin = 10;
        
        // frames
        CGRect cframe = self.view.frame;
        CGRect fHeader = CGRectMake(0,0,cframe.size.width,head);
        CGRect fInfo = CGRectMake(inset,margin,fHeader.size.width-2*inset-10,head-2*margin);
        
        // header
        UIView *header = [[[UIView alloc] initWithFrame:fHeader] autorelease];
        header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        header.autoresizesSubviews = YES;
        header.backgroundColor = [UIColor clearColor];
        
        // description
        UILabel *lblInfo = [[UILabel alloc] initWithFrame:fInfo];
        lblInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lblInfo.backgroundColor = [UIColor clearColor];
        lblInfo.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblInfo.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        lblInfo.shadowOffset = CGSizeMake(0,1);
        lblInfo.opaque = YES;
        lblInfo.numberOfLines = 2;
        [lblInfo setText:NSLocalizedString(@"No favorites yet. Tap the heart icon to add a movie or person to your favorites.", @"No favorites yet. Tap the heart icon to add a movie or person to your favorites.")];
        [header addSubview:lblInfo];
        [lblInfo release];
        
        // return
        return header;
    }
    return nil;
}

/*
 * Header height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (! mode_editing && [[self.fetched_favorites fetchedObjects] count] <= 0) {
        return 30;
    }
    return 0;
}


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLog()
    
    // identifier
	static NSString *CellIdentifier = @"CellSearchFavorite";
	
	// create cell
	CellData *cell = (CellData*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CellData alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
    // favorite
    Favorite *favorite = [self fetch_favorite:indexPath];
    
    // reset
    [cell reset];
    
    // label
    [cell.textLabel setText:[favorite.type isEqualToString:typeMovie] ? [NSString stringWithFormat:@"%@ (%@)",favorite.title,favorite.meta] : favorite.title];
    
    // thumb
    [cell dataThumb:favorite.thumb type:favorite.type];
    
	// return
	return cell;
}


/*
 * Editing.
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/*
 * Movable.
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return _favorites.editing;
}


/*
 * Delete.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog();
	
	// check if delete
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // favorite
        Favorite *favorite = [self fetch_favorite:indexPath];
        
        // delete
        [_solyarisDataManager cdObjectDelete:favorite];
        
        // save
        if (! mode_editing) {
            [_solyarisDataManager save];
            [self update];
        }
        
	}
}


/*
 * Move entry.
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    DLog();
    
    // favorites
    NSMutableArray *favorites = [[self.fetched_favorites fetchedObjects] mutableCopy];
    
    // grab favorite
    NSManagedObject *favorite = [self.fetched_favorites objectAtIndexPath:sourceIndexPath];
    
    // resort
    [favorites removeObject:favorite];
    [favorites insertObject:favorite atIndex:[destinationIndexPath row]];
    
    // update
    int i = 1;
    for (NSManagedObject *s in favorites) {
        [s setValue:[NSNumber numberWithInt:i++] forKey:@"sort"];
    }
    
    // release
    [favorites release];
    favorites = nil;
}


/*
 * Selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLog();
    
    // non editing
    if (! _favorites.editing) {
        
        // favorite
        Favorite *favorite = [self fetch_favorite:indexPath];
        
        // delegate
        if (delegate && [delegate respondsToSelector:@selector(favoriteSelected:)]) {
            [delegate favoriteSelected:favorite];
        }
    }
    
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
    FLog();
    
    // manager
    [_solyarisDataManager release];
    
    // fetch
    [fetched_favorites__ release];
    [type__ release];
    
    // ui
    [_header release];
    [_favorites release];
	
	// super
    [super dealloc];
}

@end
