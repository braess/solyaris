//
//  IMDB.m
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "IMDB.h"
#import "APIKeys.h"
#import "SBJson.h"
#import "SearchResult.h"
#import "MovieActor.h"
#import "MovieDirector.h"


/**
 * Core Data Stack.
 */
@interface IMDB (PrivateCoreDataStack)
    
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
@interface IMDB (CacheStack)
- (Search*)cachedSearch:(NSString*)query type:(NSString*)type;
- (Movie*)cachedMovie:(NSNumber*)mid;
- (Actor*)cachedActor:(NSNumber*)aid;
- (Director*)cachedDirector:(NSNumber*)did;
- (MovieActor*)cachedMovieActor:(NSNumber*)mid actor:(NSNumber*)aid;
- (MovieDirector*)cachedMovieDirector:(NSNumber*)mid director:(NSNumber*)did;
@end


/**
 * Query Stack.
 */
@interface IMDB (QueryStack)
- (Search*)querySearch:(NSString*)query type:(NSString*)type;
- (Movie*)queryMovie:(NSNumber*)mid;
- (Actor*)queryActor:(NSNumber*)aid;
- (Director*)queryDirector:(NSNumber*)did;
@end


/**
 * API IMDB.
 */
@implementation IMDB


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
    GLog();
    
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
    DLog();
    
    // queue
    [queue cancelAllOperations];
    [queue addOperationWithBlock:^{
        
        
        // cache
        [managedObjectContext lock];
        Search *search = [self cachedSearch:q type:t];
        if (search == NULL) {
            search = [self querySearch:q type:t];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(searchResult:)]) {
                [delegate searchResult:search];
            }

        }];
    }];
    
    
}

/**
 * Movie.
 */
- (void)movie:(NSNumber *)mid {
    DLog();
    
    // queue
    [queue cancelAllOperations];
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        Movie *movie = [self cachedMovie:mid];
        if (movie == NULL || ! [movie.loaded boolValue]) {
            movie = [self queryMovie:mid];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // loaded
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedMovie:)]) {
                [delegate loadedMovie:movie];
            }
            
        }];
    }];
    
}

/**
 * Actor.
 */
- (void)actor:(NSNumber *)aid {
    DLog();
    
    // queue
    [queue cancelAllOperations];
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        Actor *actor = [self cachedActor:aid];
        if (actor == NULL || ! [actor.loaded boolValue]) {
            actor = [self queryActor:aid];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // loaded
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedActor:)]) {
                [delegate loadedActor:actor];
            }
            
        }];
    }];
    
}

/**
 * Director.
 */
- (void)director:(NSNumber *)did {
    DLog();
    
    // queue
    [queue cancelAllOperations];
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        Director *director = [self cachedDirector:did];
        if (director == NULL || ! [director.loaded boolValue]) {
            director = [self queryDirector:did];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // loaded
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedDirector:)]) {
                [delegate loadedDirector:director];
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
    
    // limit
    [request setFetchLimit:1];
    
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

/*
 * Cached movie.
 */
- (Movie*)cachedMovie:(NSNumber *)mid {
    FLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid = %@", mid];
    [request setPredicate:predicate];

    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Movie *movie = NULL;
    if (array != nil && [array count] > 0) {
        movie = (Movie*) [array objectAtIndex:0];
    }
    
    // return
    return movie;
    
}



/*
 * Cached actor.
 */
- (Actor*)cachedActor:(NSNumber*)aid {
    FLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Actor" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aid = %@", aid];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Actor *actor = NULL;
    if (array != nil && [array count] > 0) {
        actor = (Actor*) [array objectAtIndex:0];
    }
    
    // return
    return actor;
    
}

/*
 * Cached director.
 */
- (Director*)cachedDirector:(NSNumber*)did {
    FLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Director" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"did = %@", did];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Director *actor = NULL;
    if (array != nil && [array count] > 0) {
        actor = (Director*) [array objectAtIndex:0];
    }
    
    // return
    return actor;
    
}



/*
 * Cached movie actor.
 */
- (MovieActor*)cachedMovieActor:(NSNumber*)mid actor:(NSNumber*)aid {
    FLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieActor" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(mid = %@ && aid = %@)", mid, aid];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    MovieActor *mactor = NULL;
    if (array != nil && [array count] > 0) {
        mactor = (MovieActor*) [array objectAtIndex:0];
    }
    
    // return
    return mactor;
}


/*
 * Cached movie director.
 */
- (MovieDirector*)cachedMovieDirector:(NSNumber*)mid director:(NSNumber*)did {
    FLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MovieDirector" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(mid = %@ && did = %@)", mid, did];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    MovieDirector *mdirector = NULL;
    if (array != nil && [array count] > 0) {
        mdirector = (MovieDirector*) [array objectAtIndex:0];
    }
    
    // return
    return mdirector;
}


#pragma mark -
#pragma mark Query



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
    
    // formatter
    static NSNumberFormatter *nf;
    if (nf == nil) {
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
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
        sresult.rid = [nf numberFromString:[result objectForKey:@"rid"]];
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

/*
 * Query movie.
 */
- (Movie*)queryMovie:(NSNumber*)mid {
    FLog();
    
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@?key=%@&id=%i",apiIMDBMovie,apiIMDBKey,[mid intValue]];
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
    
    // formatter
    static NSNumberFormatter *nf;
    if (nf == nil) {
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    
    // movie
    Movie *movie = [self cachedMovie:mid];
    if (movie == NULL) {
        movie = (Movie*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
    }

    
    // parse json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    NSDictionary *djson = [json JSONValue];
    
    // movie
    movie.mid = [nf numberFromString:[djson objectForKey:@"mid"]];
    movie.title = [djson objectForKey:@"title"];
    movie.year = [djson objectForKey:@"year"];
    
    // directors
    NSArray *directors = [djson objectForKey:@"directors"];
    for (NSDictionary *ddirector in directors)	{
        
        // Director
        NSNumber *did = [nf numberFromString:[ddirector objectForKey:@"did"]];
        Director *director = [self cachedDirector:did];
        if (director == NULL) {
            director = (Director*)[NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:managedObjectContext];
            director.did = did;
            director.name = [ddirector objectForKey:@"name"];;
        }

        
        // MovieDirector
        MovieDirector *mdirector = [self cachedMovieDirector:mid director:did];
        if (mdirector == NULL) {
            mdirector = (MovieDirector*)[NSEntityDescription insertNewObjectForEntityForName:@"MovieDirector" inManagedObjectContext:managedObjectContext];
            mdirector.mid = mid;
            mdirector.did = did;
            mdirector.addition = [ddirector objectForKey:@"addition"];
            mdirector.year = movie.year;
        }
        mdirector.director = director;
        
        // add
        [movie addDirectorsObject:mdirector];
    }
    
    // actors
    NSArray *actors = [djson objectForKey:@"actors"];
    for (NSDictionary *dactor in actors)	{
        
        // Director
        NSNumber *aid = [nf numberFromString:[dactor objectForKey:@"aid"]];
        Actor *actor = [self cachedActor:aid];
        if (actor == NULL) {
            actor = (Actor*)[NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:managedObjectContext];
            actor.aid = aid;
            actor.name = [dactor objectForKey:@"name"];
        }
        
        // MovieActor
        MovieActor *mactor = [self cachedMovieActor:mid actor:aid];
        if (mactor == NULL) {
            mactor = (MovieActor*)[NSEntityDescription insertNewObjectForEntityForName:@"MovieActor" inManagedObjectContext:managedObjectContext];
            mactor.mid = mid;
            mactor.aid = aid;
            mactor.character = [dactor objectForKey:@"character"];
            mactor.order = [nf numberFromString:[dactor objectForKey:@"order"]];
            mactor.year = movie.year;
            FLog("set");
        }
        mactor.actor = actor;
        
        // add
        [movie addActorsObject:mactor];

    }
    
    // loaded
    movie.loaded = [NSNumber numberWithBool:YES];
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"IMDB CoreData Error\n%@\n%@", error, [error userInfo]);
    }
    
    
    // return
    return movie;
}


/*
 * Query actor.
 */
- (Actor*)queryActor:(NSNumber*)aid {
    FLog();
    
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@?key=%@&id=%i",apiIMDBActor,apiIMDBKey,[aid intValue]];
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
    
    // formatter
    static NSNumberFormatter *nf;
    if (nf == nil) {
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    
    // Actor
    Actor *actor = [self cachedActor:aid];
    if (actor == NULL) {
        actor = (Actor*)[NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:managedObjectContext];
    }
    
    
    // parse json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    NSDictionary *djson = [json JSONValue];
    
    // movie
    actor.aid = [nf numberFromString:[djson objectForKey:@"aid"]];
    actor.name = [djson objectForKey:@"name"];
    
    
    // movies
    NSArray *movies = [djson objectForKey:@"movies"];
    for (NSDictionary *dmovie in movies)	{
        
        // Movie
        NSNumber *mid = [nf numberFromString:[dmovie objectForKey:@"mid"]];
        Movie *movie = [self cachedMovie:mid];
        if (movie == NULL) {
            movie = (Movie*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
            movie.mid = mid;
            movie.title = [dmovie objectForKey:@"title"];
            movie.year = [dmovie objectForKey:@"year"];
        }
        
        // MovieActor
        MovieActor *mactor = [self cachedMovieActor:mid actor:aid];
        if (mactor == NULL) {
            mactor = (MovieActor*)[NSEntityDescription insertNewObjectForEntityForName:@"MovieActor" inManagedObjectContext:managedObjectContext];
            mactor.mid = mid;
            mactor.aid = aid;
            mactor.character = [dmovie objectForKey:@"character"];
            mactor.order = [nf numberFromString:[dmovie objectForKey:@"order"]];
            mactor.year = movie.year;
        }
        mactor.movie = movie;
        
        
        // add
        [actor addMoviesObject:mactor];
    }
    
    // loaded
    actor.loaded = [NSNumber numberWithBool:YES];
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"IMDB CoreData Error\n%@\n%@", error, [error userInfo]);
    }
    
    // return
    return actor;
}


/*
 * Query director.
 */
- (Director*)queryDirector:(NSNumber*)did {
    FLog();
    
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@?key=%@&id=%i",apiIMDBDirector,apiIMDBKey,[did intValue]];
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
    
    // formatter
    static NSNumberFormatter *nf;
    if (nf == nil) {
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    
    // director
    Director *director = [self cachedDirector:did];
    if (director == NULL) {
        director = (Director*)[NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:managedObjectContext];
    }
    
    
    // parse json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    NSDictionary *djson = [json JSONValue];
    
    // movie
    director.did = [nf numberFromString:[djson objectForKey:@"did"]];
    director.name = [djson objectForKey:@"name"];

    
    // movies
    NSArray *movies = [djson objectForKey:@"movies"];
    for (NSDictionary *dmovie in movies)	{
        
        // Movie
        NSNumber *mid = [nf numberFromString:[dmovie objectForKey:@"mid"]];
        Movie *movie = [self cachedMovie:mid];
        if (movie == NULL) {
            movie = (Movie*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
            movie.mid = mid;
            movie.title = [dmovie objectForKey:@"title"];
            movie.year = [dmovie objectForKey:@"year"];
        }
        
        // MovieDirector
        MovieDirector *mdirector = [self cachedMovieDirector:mid director:did];
        if (mdirector == NULL) {
            mdirector = (MovieDirector*)[NSEntityDescription insertNewObjectForEntityForName:@"MovieDirector" inManagedObjectContext:managedObjectContext];
            mdirector.mid = mid;
            mdirector.did = did;
            mdirector.addition = [dmovie objectForKey:@"addition"];
            mdirector.year = movie.year;
        }
        mdirector.movie = movie;
        
        // add
        [director addMoviesObject:mdirector];
    }
    
    // loaded
    director.loaded = [NSNumber numberWithBool:YES];
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"IMDB CoreData Error\n%@\n%@", error, [error userInfo]);
    }
    
    // return
    return director;
}



#pragma mark -
#pragma mark Core Data stack


/**
 * Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    GLog();
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * Returns the managed object context for the application.
 * If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	GLog();
	
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
	GLog();
	
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
	GLog();
	
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
		[alert setTag:IMDB_AlertFatal];
		[alert show];    
		[alert release];
    }    
	
	// return
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// determine alert
	switch ([actionSheet tag]) {
        // fatal
		case IMDB_AlertFatal: {
			// cancel
			if (buttonIndex == 0) {
			}
			// quit
			else {
				if (delegate && [delegate respondsToSelector:@selector(quit)]) {
                    [delegate quit];
                }
			}
			
			break;
		}
        // error
		case IMDB_AlertError: {
			break;
		}
			
		default:
			break;
	}
	
	
}



#pragma mark -
#pragma mark Memory management


/*
 * Deallocates used memory.
 */
- (void)dealloc {
    GLog();
    
    // super
    [super dealloc];
}


@end
