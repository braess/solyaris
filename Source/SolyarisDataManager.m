//
//  SolyarisDataManager.m
//  Solyaris
//
//  Created by CNPP on 03.01.13.
//
//

#import "SolyarisDataManager.h"
#import "NSData+Base64.h"
#import "SolyarisConstants.h"
#import "Tracker.h"

/**
 * CoreData.
 */
@interface SolyarisDataManager (PrivateCoreDataStack)
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

/**
 * Directory Stack.
 */
@interface SolyarisDataManager (DirectoryStack)
+ (NSString *)dirSolyaris;
@end


/**
 * SolyarisDataManager.
 */
@implementation SolyarisDataManager


#pragma mark -
#pragma mark Constants

// local
#define kSolyarisLocal              @"Solyaris"
#define kSolyarisLocalStore         @"Solyaris_data.sqlite"


#pragma mark -
#pragma mark Object

/*
 * Init.
 */
- (id)init {
    FLog();
    
    // super
    if ((self = [super init])) {
        
        // self
        [self reset];
    }
    return self;
}



#pragma mark -
#pragma mark Setup

/**
 * Setup.
 */
- (void)setup {
    FLog();
    
    // trigger core data
    [self managedObjectContext];

}

/**
 * Reset.
 */
- (void)reset {
    FLog();
    
    // context
    if (_managedObjectContext != nil) {
        [_managedObjectContext.undoManager removeAllActions];
        [_managedObjectContext reset];
        [_managedObjectContext release];
        _managedObjectContext = nil;
    }
    
    // model
    if (_managedObjectModel != nil) {
        [_managedObjectModel release];
        _managedObjectModel = nil;
    }
    
    // coordinator
    if (_persistentStoreCoordinator != nil) {
        [_persistentStoreCoordinator release];
        _persistentStoreCoordinator = nil;
    }
}


#pragma mark -
#pragma mark Core Data

/*
 * Returns the managed object context for the application.
 */
- (NSManagedObjectContext*) managedObjectContext {
	GLog();
	
	// context
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // coordinator
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        
        // init concurrent
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc performBlockAndWait:^{
            
            // observer
            [moc setPersistentStoreCoordinator: coordinator];
            
        }];
        
        // assign
        _managedObjectContext = [moc retain];
        [moc release];
        
        // merge policy
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        // undo manager
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [_managedObjectContext setUndoManager:undoManager];
        [undoManager release], undoManager = nil;
        
    }
    
    // return context
    return _managedObjectContext;
}


/*
 * Returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel {
	GLog();
	
	// model
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    // yomu model
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Solyaris" ofType:@"momd"]];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _managedObjectModel = [mom retain];
    [mom release];
    
    // return
    return _managedObjectModel;
}


/*
 * Returns the persistent store coordinator for the application.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	GLog();
	
	// existing coordinator
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // create
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
    _persistentStoreCoordinator = [psc retain];
    [psc release];
    
    // local store
    NSString *localStore = [[SolyarisDataManager dirSolyaris] stringByAppendingPathComponent:kSolyarisLocalStore];
    NSURL *localStoreURL = [NSURL fileURLWithPath:localStore];
    
    // options
    NSMutableDictionary *localOptions = [NSMutableDictionary dictionary];
    [localOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [localOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    // coordinator
    NSError *error = nil;
    if (! [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localStoreURL options:localOptions error:&error]) {
        
        // track
        [Tracker trackError:@"SolyarisDataManager" method:@"persistentStoreCoordinator" message:@"Core Data Error." error:error];
        
        // show info
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error",@"Error")
                              message:NSLocalizedString(@"Could not load data. Please try to reinstall the application... Sorry about this.",@"Could not load data. Please try to reinstall the application... Sorry about this.")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                              otherButtonTitles:nil];
        [alert setTag:AlertDataError];
        [alert show];
        [alert release];
    }
    
    // return coordinator
    return _persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Manager

/**
 * Manager favorite add.
 */
- (void)managerFavoriteAdd:(NSDictionary *)fav {
    DLog();
    
    // object
    Favorite *favorite = [self solyarisObjectFavorite:[fav objectForKey:kFavType]];
    
    // init
    favorite.dbid = [fav objectForKey:kFavDBID];
    favorite.title = [fav objectForKey:kFavTitle];
    favorite.meta = [fav objectForKey:kFavMeta];
    favorite.link = [fav objectForKey:kFavLink];
    
    // thumb
    if ([[fav objectForKey:kFavThumb] length] > 0) {
        
        // request
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[fav objectForKey:kFavThumb]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
        
        // response
        NSError *error = nil;
        NSHTTPURLResponse *response;
        
        // download
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // import
        if (! error && [response statusCode] == 200 && data != nil) {
            favorite.thumb = [UIImage imageWithData:data];
        }
    }
    
    // save
    [self save];
}

/**
 * Manager favorite remove.
 */
- (void)managerFavoriteRemove:(NSDictionary *)fav {
    DLog();
    
    // favorite
    Favorite *favorite = [self solyarisDataFavorite:[fav objectForKey:kFavType] dbid:[fav objectForKey:kFavDBID]];
    if (favorite) {
        
        // delete
        [self cdObjectDelete:favorite];
        
        // save
        [self save];
    }
}

/**
 * Manager export favorites.
 */
- (NSString*)managerExportFavorites:(NSString *)type {
    DLog();
    
    // favorites
    NSArray *favorites = [self solyarisDataFavorites:type];
    if ([favorites count] <= 0) {
        return nil;
    }
    
    // html
    NSString *html =
    @"<div style='max-width:480px;'>"
    "<table border='0' cellpadding='0' cellspacing='0' width='100%' style='font-family:Helvetica, Arial, sans-serif; color:#4C4C4C; font-size:14px; line-height:18px; margin:0px; padding:0px; border-top:1px solid #EEEEEE;'>"
    "<tbody>"
    "$EXPORT$"
    "</tbody>"
    "<tfoot>"
    "<tr><td colspan='2' style='padding:25px 0 0 0;'>$FOOTER$</td></tr>"
    "</tfoot>"
    "</table>"
    "</div>";
    
    // placeholder
    UIImage *placeholder = [UIImage imageNamed:[type isEqualToString:typePerson] ? @"placeholder_thumb_person.png" : @"placeholder_thumb_movie.png"];
    
    // export
    NSString *html_export = @"";
    for (Favorite *favorite in favorites) {
        html_export = [html_export stringByAppendingFormat:@"<tr><td width='40px' style='border-bottom:1px solid #EEEEEE;'><img src='data:image/png;base64,%@' width='30' height='auto' style='display:block;'/></td><td style='border-bottom:1px solid #EEEEEE;'><a href='%@' style='color:#4C4C4C; text-decoration:none'><strong>%@</strong>&nbsp;%@</a></td></tr>",
                       favorite.thumb ? [UIImagePNGRepresentation(favorite.thumb) base64EncodingWithLineLength:0] : [UIImagePNGRepresentation(placeholder) base64EncodingWithLineLength:0],
                       favorite.link,
                       favorite.title,
                       (favorite.meta && favorite.meta.length > 1) ? [NSString stringWithFormat:@"(%@)",favorite.meta] : @""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"$EXPORT$" withString:html_export];
    
    // footer
    NSData *icon = UIImagePNGRepresentation([UIImage imageNamed:@"app_icon.png"]);
    NSString *html_footer = [NSString stringWithFormat:@"<p style='padding:0; margin:0;'><a href='%@' style='color:#4C4C4C; text-decoration:none'><img src='data:image/png;base64,%@' width='45' height='45' style='display:block; float:left; margin:0 8px 0 0;'/><div style='padding:5px 0 0 0;'><span style='font-weight:bold'>%@</span><br/><span>%@</span></div></a></p>",vAppSite,[icon base64EncodingWithLineLength:0],NSLocalizedString(@"Solyaris", @"Solyaris"),NSLocalizedString(@"Visual Movie Browser", @"Visual Movie Browser")];
    html = [html stringByReplacingOccurrencesOfString:@"$FOOTER$" withString:html_footer];
    
    // return
    return html;
}



#pragma mark -
#pragma mark CoreData

/**
 * Saves the context.
 */
- (void)save {
    
    // context
    if (_managedObjectContext != nil) {
        
        // pending changes
        if ([_managedObjectContext hasChanges]) {
            DLog("== SAVE ==");
            
            // save
            NSError *error = nil;
            [_managedObjectContext save:&error];
        }
        
    }
}


/**
 * Core Transaction.
 */
- (void)cdTransactionBegin:(NSString *)trx  {
    DLog("<TRANSACTION>");
    
    // undo manager
    [self.managedObjectContext.undoManager beginUndoGrouping];
    [self.managedObjectContext.undoManager setActionName:trx];
    
}
- (void)cdTransactionEnd:(NSString *)trx persist:(BOOL)persist  {
    DLog("</TRANSACTION>");
    
    // undo manager
    [self.managedObjectContext.undoManager endUndoGrouping];
    
    // persist
    if (persist) {
        [self save];
    }
    // undo
    else {
        [self.managedObjectContext.undoManager undoNestedGroup];
    }
}

/**
 * Core delete.
 */
- (void)cdObjectDelete:(NSManagedObject *)object {
    DLog("-- DELETE Object --");
    
    // delete
    [self.managedObjectContext deleteObject:object];
}



#pragma mark -
#pragma mark Yomu Objects

/**
 * Creates a Favorite object.
 */
- (Favorite*)solyarisObjectFavorite:(NSString*)type {
    DLog("++ CREATE Favorite ++");
    
    // managed entity
	Favorite *favorite = (Favorite *)[NSEntityDescription
                                      insertNewObjectForEntityForName:@"Favorite"
                                      inManagedObjectContext:self.managedObjectContext];
    
    // init
    favorite.dbid = [NSNumber numberWithInt:-1];
    favorite.type = type;
    favorite.created = [NSDate date];
    
    favorite.title = @"";
    favorite.meta = @"";
    favorite.link = @"";
    
    
    // sorting
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(type == %@)", type]];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:nil];
    favorite.sort = [NSNumber numberWithInteger:count];
    [request release];
    
    // return
    return favorite;
}
  



#pragma mark -
#pragma mark Yomu Data


/**
 * Loads the favorites.
 */
- (NSMutableArray*)solyarisDataFavorites:(NSString *)type {
    FLog();
    
    // context
    NSManagedObjectContext *moc = self.managedObjectContext;
    
    // fetch data request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:moc];
    [request setEntity:entity];
    
    // predicate
    [request setPredicate:[NSPredicate predicateWithFormat:@"(type == %@)", type]];
    
    // sort descriptor
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sorter, nil]];
    [sorter release];
    
    // execute request
    NSError *error = nil;
    NSMutableArray *results = [[[moc executeFetchRequest:request error:&error] mutableCopy] autorelease];
    [request release];
    
    // return
    return results;
}


/**
 * Loads a favorite.
 */
- (Favorite*)solyarisDataFavorite:(NSString *)type dbid:(NSNumber *)dbid {
    FLog();
    
    // moc
    NSManagedObjectContext *moc = self.managedObjectContext;
    
    // entity
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    [request setPredicate:[NSPredicate predicateWithFormat:@"(type == %@)", type]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(dbid == %@)", dbid]];
    
    // limit
    [request setFetchLimit:1];
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Favorite *favorite = NULL;
    if (array != nil && [array count] > 0) {
        
        // document
        favorite = (Favorite*) [array objectAtIndex:0];
    }
    
    // return
    return favorite;
}



#pragma mark -
#pragma mark Directories

/**
 * Directory Solyaris.
 */
+ (NSString *)dirSolyaris {
    
    // yomu
    NSString *pathSolyaris = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kSolyarisLocal];
    
    // create
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(! [fileManager fileExistsAtPath:pathSolyaris]) {
        NSLog(@"Create Solyaris directory.");
        
        // directory
        [fileManager createDirectoryAtPath:pathSolyaris withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // return
	return pathSolyaris;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	FLog();
    
	// core data
	[_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
	
	// super
	[super dealloc];
}


@end
