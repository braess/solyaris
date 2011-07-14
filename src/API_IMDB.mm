//
//  API_IMDB.m
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "API_IMDB.h"
#import "IMDGConstants.h"
#import "SBJson.h"
#import "Search.h"
#import "SearchResult.h"


/**
 * Core Data Stack.
 */
@interface API_IMDB (PrivateCoreDataStack)
    
    // Properties
    @property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
    @property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

    // Methods
    - (NSString *)applicationDocumentsDirectory;
@end


/**
 * Cache Stack.
 */
@interface API_IMDB (CacheStack)
- (Search *)cachedSearch:(NSString*)query type:(NSString*)type;
@end


/**
 * Query Stack.
 */
@interface API_IMDB (QueryStack)
- (Search *)querySearch:(NSString*)query type:(NSString*)type;
@end


/**
 * API IMDB.
 */
@implementation API_IMDB


#pragma mark -
#pragma mark Constants

// constants
NSString* STORE = @"IMDG.sqlite";


#pragma mark -
#pragma mark Object

/**
 * Initialize.
 */
-(id)init {
    
    // super
    if ((self = [super init])) {
        
        // fields
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        
        // context
        NSManagedObjectContext *context = [self managedObjectContext];
        if (!context) {
            // Handle the error.
        }
    }
    
    // return
    return self;
}


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark Business

/**
 * Search.
 */
- (void)search:(NSString *)q type:(NSString*)t {
    
    // queue
    [queue addOperationWithBlock:^{
        
        
        // Ensure you're assigning to a local variable here.
        // Do not assign to a member variable.  You will get
        // occasional thread race condition related crashes
        // if you do.      
        
        // cache
        Search *search = [self cachedSearch:q type:t];
        if (search == NULL) {
            search = [self querySearch:q type:t];
        }

        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Modify your instance variables here on the main UI thread.
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(searchResult:)]) {
                [delegate searchResult:search];
            }

        }];
    }];
    
    
}




#pragma mark -
#pragma mark Cache

/*
 * Cached search.
 */
- (Search *)cachedSearch:(NSString*)query type:(NSString*)type {
    FLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Search" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(query = %@) AND (type = %@)", query, type];
    [request setPredicate:predicate];
    
    
    // sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"query" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Search *s = NULL;
    if (array != nil && [array count] > 0) {
        s = (Search*) [array objectAtIndex:0];
    }
    
    // return
    return s;
    
}


#pragma mark -
#pragma mark Cache


/*
 * Query search.
 */
- (Search*)querySearch:(NSString *)query type:(NSString *)type {
    FLog();

	
    // request
    NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@?key=%@&query=%@&type=%@",apiIMDBSearch,apiIMDBKey,equery,type];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											  cachePolicy:NSURLRequestReloadIgnoringCacheData
										  timeoutInterval:20.0];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
	
    // connection
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // error
    if (error) {
        // oops
    }
    
    
    // search result
    Search *search = (Search*)[NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:managedObjectContext];
    search.query = query;
    search.type = type;
    
    // parse json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    NSDictionary *djson = [json JSONValue];
    NSArray *results = [djson objectForKey:@"result"];
    for (NSDictionary *result in results)	{
        SearchResult *sresult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
        sresult.did = 0;
        sresult.data = [result objectForKey:@"data"];
        [search addDataObject:sresult];
    }
    
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"IMDB CoreData Error\n%@\n%@", error, [error userInfo]);
    }
    
    
    // return
    return search;
}



#pragma mark -
#pragma mark Core Data stack


/**
 * Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * Returns the managed object context for the application.
 * If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	FLog();
	
	// context
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
	// store
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	FLog();
	
	// model
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	FLog();
	
	// existing coordinator
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	// store path
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:STORE];
	
	// store url
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	// options
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	// init
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		
		// something bad happend
		NSLog(@"IMDB CoreData Error\n%@\n%@", error, [error userInfo]);
		
		// show info
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Corrupted Cache" 
							  message:@"Please try to clear the cache or reinstall the application... Sorry about this." 
							  delegate:self 
							  cancelButtonTitle: @"Cancel"
							  otherButtonTitles:@"Quit",nil];
		[alert setTag:API_IMDB_AlertError];
		[alert show];    
		[alert release];
    }    
	
	// return
    return persistentStoreCoordinator;
}


@end
