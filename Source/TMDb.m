//
//  TMDb.m
//  Solyaris
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "TMDb.h"
#import "APIKeys.h"
#import "SBJson.h"
#import "SolyarisConstants.h"


/**
 * Core Data Stack.
 */
@interface TMDb (PrivateCoreDataStack)

// Properties
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Methods
- (NSString *)applicationCachesDirectory;
@end


/**
 * Core Data Stack.
 */
@interface TMDb (ParserStack)
- (NSString*)parseString:(NSObject*)token;
- (NSNumber*)parseNumber:(NSObject*)token;
- (NSDate*)parseDate:(NSObject*)token;
- (NSString*)parseYear:(NSObject *)token;
- (NSString*)updateCharacter:(NSString*)original updated:(NSString*)updated;
- (NSString*)updateJob:(NSString*)original updated:(NSString*)updated;
- (NSString*)updateDepartment:(NSString*)original updated:(NSString*)updated;
- (NSNumber*)updateOrder:(NSNumber*)original updated:(NSNumber*)updated;
- (NSString*)updateType:(NSString*)original updated:(NSString*)updated;
- (BOOL)isEmpty:(id)thing;
- (BOOL)validSearchResult:(NSDictionary*)dresult;
- (BOOL)validMovie:(NSDictionary*)dmovie;
- (BOOL)validPerson:(NSDictionary*)dperson;
@end


/**
 * Cache Stack.
 */
@interface TMDb (CacheStack)
- (Search*)cachedSearch:(NSString*)query type:(NSString*)type;
- (Movie*)cachedMovie:(NSNumber*)mid;
- (Person*)cachedPerson:(NSNumber*)pid;
- (Movie2Person*)cachedMovie2Person:(NSNumber*)mid person:(NSNumber*)pid;
- (NSArray*)cachedMovies;
@end


/**
 * Query Stack.
 */
@interface TMDb (QueryStack)
- (Search*)querySearch:(NSString*)query type:(NSString*)type;
- (Movie*)queryMovie:(NSNumber*)mid;
- (Person*)queryPerson:(NSNumber*)pid;
@end


/**
 * API TMDb.
 */
@implementation TMDb


#pragma mark -
#pragma mark Constants

// constants
static NSString* TMDbStore = @"TMDb.sqlite";


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
            
            // handle the error
            if (delegate && [delegate respondsToSelector:@selector(apiFatal:)]) {
                [delegate apiFatal:NSLocalizedString(@"Corrupted Data", "Corrupted Data")];
            }
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
 * Cancel.
 */
- (void)cancel {
    DLog();
    
    // queue
    [queue cancelAllOperations];
    
}

/**
 * Search.
 */
- (void)search:(NSString *)q type:(NSString *)t {
    DLog();
    
    // queue
    [queue cancelAllOperations];
    [queue addOperationWithBlock:^{
        
        
        // cache
        [managedObjectContext lock];
        NSString *query = [q lowercaseString];
        Search *search = [self cachedSearch:query type:t];
        if (search == NULL) {
            search = [self querySearch:query type:t];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedSearch:)]) {
                [delegate loadedSearch:search];
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
 * Data movie.
 */
- (Movie*)dataMovie:(NSNumber *)mid {
    DLog();
    
    // cache
    [managedObjectContext lock];
    Movie *movie = [self cachedMovie:mid];
    if (movie == NULL || ! [movie.loaded boolValue]) {
        movie = [self queryMovie:mid];
    }
    [managedObjectContext unlock];
    
    // return
    return movie;
    
}


/**
 * Person.
 */
- (void)person:(NSNumber *)pid {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        Person *person = [self cachedPerson:pid];
        if (person == NULL || ! [person.loaded boolValue]) {
            person = [self queryPerson:pid];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // loaded
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedPerson:)]) {
                [delegate loadedPerson:person];
            }
            
        }];
    }];
    
}

/**
 * Data person.
 */
- (Person*)dataPerson:(NSNumber *)pid {
    DLog();
    
    // cache
    [managedObjectContext lock];
    Person *person = [self cachedPerson:pid];
    if (person == NULL || ! [person.loaded boolValue]) {
        person = [self queryPerson:pid];
    }
    [managedObjectContext unlock];
    
    // return
    return person;
    
}

/**
 * Returns the loaded movies.
 */
- (NSArray*)dataMovies {
    DLog();
    
    // cache
    [managedObjectContext lock];
    NSArray *movies = [self cachedMovies];
    [managedObjectContext unlock];
    
    // return
    return movies;
}

/**
 * Clears the cache.
 */
- (void)clearCache {
    DLog();
    
    // path
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *storePath = [[self applicationCachesDirectory] stringByAppendingPathComponent:TMDbStore];
	
	// remove existing db
	if ([fileManager fileExistsAtPath:storePath]) {
		[fileManager removeItemAtPath:storePath error:NULL];
	}
    
    // context
    [managedObjectContext release];
    managedObjectContext = nil;
    
    [managedObjectModel release];
    managedObjectModel = nil;
    
    [persistentStoreCoordinator release];
    persistentStoreCoordinator = nil;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        
        // handle the error
        if (delegate && [delegate respondsToSelector:@selector(apiFatal:)]) {
            [delegate apiFatal:NSLocalizedString(@"Corrupted Data", "Corrupted Data")];
        }
    }
}




#pragma mark -
#pragma mark Cache

/*
 * Cached search.
 */
- (Search *)cachedSearch:(NSString*)query type:(NSString *)type {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Search" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(query = %@ && type = %@)", query, type];
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
- (Movie*)cachedMovie:(NSNumber*)mid {
    GLog();
    
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
 * Cached movies.
 */
- (NSArray*)cachedMovies {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // return
    return array;
}



/*
 * Cached person.
 */
- (Person*)cachedPerson:(NSNumber*)pid {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid = %@", pid];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Person *person = NULL;
    if (array != nil && [array count] > 0) {
        person = (Person*) [array objectAtIndex:0];
    }
    
    // return
    return person;
    
}




/*
 * Cached movie person.
 */
- (Movie2Person*)cachedMovie2Person:(NSNumber*)mid person:(NSNumber*)pid {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Movie2Person" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(mid = %@ && pid = %@)", mid, pid];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Movie2Person *m2p = NULL;
    if (array != nil && [array count] > 0) {
        m2p = (Movie2Person*) [array objectAtIndex:0];
    }
    
    // return
    return m2p;
}



#pragma mark -
#pragma mark Query


/*
 * Query search.
 */
- (Search*)querySearch:(NSString *)query type:(NSString *)type {
    FLog();
    
    // search result
    Search *search = (Search*)[NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:managedObjectContext];
    search.type = type;
    search.query = query;
    
    // error
    NSError *error = nil;
    
    
    // movie
    if ([type isEqualToString:typeAll] || [type isEqualToString:typeMovie]) {
        
            
        // request
        NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *url = [NSString stringWithFormat:@"%@/en/json/%@/%@",apiTMDbSearchMovie,apiTMDbKey,equery];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:20.0];
        
        // response
        error = nil;
        NSURLResponse *response = nil;
        
        // connection
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        if (error) {
            
            // oops
            if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
                [delegate apiError:[NSNumber numberWithInt:-1] type:typeMovie message:[error localizedDescription]];
            }
            
            // roll back tha thing
            [managedObjectContext rollback];
            
            // fluff search
            return NULL;
        }
        
        
        // parse json
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
        
        // result
        if (([json rangeOfString : @"Nothing found."].location == NSNotFound)) {
            
            // parse
            NSArray *results = [parser objectWithString:json error:nil];
            for (NSDictionary *dresult in results)	{
                SearchResult *searchResult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
                
                // validate
                if ([self validSearchResult:dresult]) {
                    
                    // dta
                    NSString *dta = [self parseString:[dresult objectForKey:@"name"]];
                    if (! [self isEmpty:[dresult objectForKey:@"released"]]) {
                        dta = [NSString stringWithFormat:@"%@ (%@)",dta,[self parseYear:[dresult objectForKey:@"released"]]];
                    }
                                     
                    
                    // data
                    searchResult.ref = [self parseNumber:[dresult objectForKey:@"id"]];
                    searchResult.data = dta;
                    searchResult.type = typeMovie;
                    
                    // thumb
                    BOOL thumb = NO;
                    NSArray *posters = [dresult objectForKey:@"posters"];
                    for (NSDictionary *dposter in posters)	{
                        
                        // first thumb
                        if (! thumb) {
                                
                            // type
                            NSDictionary *dimage = [dposter objectForKey:@"image"];
                            NSString *ptype = [self parseString:[dimage objectForKey:@"type"]];
                            NSString *psize = [self parseString:[dimage objectForKey:@"size"]];
                            
                            // compare
                            if ([ptype isEqualToString:@"poster"] && [psize isEqualToString:@"thumb"]) {
                                searchResult.thumb = [self parseString:[dimage objectForKey:@"url"]];
                                thumb = YES;
                            }
                        }
                        
                    }
                    
                    // add
                    [search addResultsObject:searchResult];
                }
            }
            [parser release];
        }
    }
    
    
    // person
    if (! [type isEqualToString:typeMovie]) {
        
        // request
        NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *url = [NSString stringWithFormat:@"%@/en/json/%@/%@",apiTMDbSearchPerson,apiTMDbKey,equery];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:20.0];
        
        // response
        error = nil;
        NSURLResponse *response = nil;
        
        
        // connection
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // error
        if (error) {
            
            // oops
            if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
                [delegate apiError:[NSNumber numberWithInt:-1] type:typePerson message:[error localizedDescription]];
            }
            
            // roll back tha thing
            [managedObjectContext rollback];
            
            // fluff search
            return NULL;
        }
        
        
        // parse json
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
        
        // result
        if (([json rangeOfString : @"Nothing found."].location == NSNotFound)) {
            
            // parse
            NSArray *results = [parser objectWithString:json error:nil];
            for (NSDictionary *dresult in results)	{
                SearchResult *searchResult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
                
                // validate
                if ([self validSearchResult:dresult]) {
                
                    // data
                    searchResult.ref = [self parseNumber:[dresult objectForKey:@"id"]];
                    searchResult.data = [self parseString:[dresult objectForKey:@"name"]];
                    searchResult.type = typePerson;
                    
                    // thumb
                    BOOL thumb = NO;
                    NSArray *profiles = [dresult objectForKey:@"profile"];
                    for (NSDictionary *dprofile in profiles)	{
                        
                        // first thumb
                        if (! thumb) {
                            
                            // type
                            NSDictionary *dimage = [dprofile objectForKey:@"image"];
                            NSString *ptype = [self parseString:[dimage objectForKey:@"type"]];
                            NSString *psize = [self parseString:[dimage objectForKey:@"size"]];
                            
                            // compare
                            if ([ptype isEqualToString:@"profile"] && [psize isEqualToString:@"thumb"]) {
                                searchResult.thumb = [self parseString:[dimage objectForKey:@"url"]];
                                thumb = YES;
                            }
                        }
                        
                    }
                    
                    // add
                    [search addResultsObject:searchResult];
                }
            }
            [parser release];
        }
    }
    
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // notify
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:[NSNumber numberWithInt:-1] type:typeSearch message:[error localizedDescription]];
        }
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
    NSString *url = [NSString stringWithFormat:@"%@/en/json/%@/%i",apiTMDbMovie,apiTMDbKey,[mid intValue]];
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
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:mid type:typeMovie message:[error localizedDescription]];
        }
        
        // fluff back
        return NULL;
    }
    
    
    // movie
    Movie *movie = [self cachedMovie:mid];
    if (movie == NULL) {
        movie = (Movie*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
    }
    
    
    // parse json
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // result
    if (([json rangeOfString : @"Nothing found."].location != NSNotFound)) {
        
        // oops
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:mid type:typeMovie message:NSLocalizedString(@"Nothing found.", @"Nothing found.")];
        }
        
        // nothing
        return NULL;
    }
    
    // movie
    NSDictionary *djson = [[parser objectWithString:json error:nil] objectAtIndex:0];
    
    
    // validate
    if ([self validMovie:djson]) {
        
        
        // set data
        movie.mid = [self parseNumber:[djson objectForKey:@"id"]];
        movie.name = [self parseString:[djson objectForKey:@"name"]];
        movie.released = [self parseDate:[djson objectForKey:@"released"]];
        movie.tagline = [self parseString:[djson objectForKey:@"tagline"]];
        movie.overview = [self parseString:[djson objectForKey:@"overview"]];
        movie.runtime = [self parseNumber:[djson objectForKey:@"runtime"]];
        movie.homepage = [self parseString:[djson objectForKey:@"homepage"]];
        movie.trailer = [self parseString:[djson objectForKey:@"trailer"]];
        movie.imdb_id = [self parseString:[djson objectForKey:@"imdb_id"]];
        
        
        // persons
        NSArray *persons = [djson objectForKey:@"cast"];
        NSMutableDictionary *parsedPersons = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *parsedMovie2Persons = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dperson in persons)	{
            
            // validate
            if ([self validPerson:dperson]) {
            
                // Person
                NSNumber *pid = [self parseNumber:[dperson objectForKey:@"id"]];
                Person *person = [parsedPersons objectForKey:pid];
                if (person == NULL) {
                    person = [self cachedPerson:pid];
                }
                if (person == NULL) {
                    
                    // create object
                    person = (Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    person.pid = pid;
                    person.name = [self parseString:[dperson objectForKey:@"name"]];
                    person.type = typePerson;
                    
                    
                    // profile
                    Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    asset.type = assetProfile;
                    asset.size = assetSizeThumb;
                    asset.url = [self parseString:[dperson objectForKey:@"profile"]];
                    asset.sort = [NSNumber numberWithInt:-1];
                    
                    // relation
                    asset.person = person;
                    [person addAssetsObject:asset];
                    
                    // defaults
                    person.loaded = NO;
                    
                }
                
                // Movie2Person
                Movie2Person *m2p = [parsedMovie2Persons objectForKey:pid];
                if (m2p == NULL) {
                    m2p = [self cachedMovie2Person:mid person:pid];
                }
                if (m2p == NULL) {
                    
                    // create object
                    m2p = (Movie2Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie2Person" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    m2p.mid = mid;
                    m2p.pid = pid;
                    m2p.year = movie.released;
                    
                    // reference
                    m2p.movie = movie;
                    m2p.person = person;

                }
                
                // update data
                m2p.type = [self updateType:m2p.type updated:[self parseString:[dperson objectForKey:@"department"]]];
                m2p.department = [self updateDepartment:m2p.department updated:[self parseString:[dperson objectForKey:@"department"]]];
                m2p.job = [self updateJob:m2p.job updated:[self parseString:[dperson objectForKey:@"job"]]];
                m2p.character = [self updateCharacter:m2p.character updated:[self parseString:[dperson objectForKey:@"character"]]];
                m2p.order = [self updateOrder:m2p.order updated:[dperson objectForKey:@"order"]];
                
                // type
                if (! person.loaded) {
                    person.type = [self updateType:person.type updated:m2p.department];
                }

                
                // add
                [movie addPersonsObject:m2p];
                [parsedPersons setObject:person forKey:pid];
                [parsedMovie2Persons setObject:m2p forKey:pid];
                
            }
            
        }
        
        // release
        [parsedPersons release];
        [parsedMovie2Persons release];

        
        // assets
        BOOL asset_thumb = NO;
        BOOL asset_mid = NO;
        BOOL asset_original = NO;
        NSArray *posters = [djson objectForKey:@"posters"];
        for (NSDictionary *dposter in posters)	{
            
            // type
            NSDictionary *dimage = [dposter objectForKey:@"image"];
            NSString *ptype = [self parseString:[dimage objectForKey:@"type"]];
            NSString *psize = [self parseString:[dimage objectForKey:@"size"]];
            
            // poster original
            if (! asset_original && [ptype isEqualToString:@"poster"] && [psize isEqualToString:@"mid"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetPoster;
                asset.size = assetSizeOriginal;
                asset.url = [self parseString:[dimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:-1];
                
                // relation
                asset.movie = movie;
                [movie addAssetsObject:asset];
                
                // done
                asset_original = YES;
                
            }
            
            // poster mid
            if (! asset_mid && [ptype isEqualToString:@"poster"] && [psize isEqualToString:@"cover"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetPoster;
                asset.size = assetSizeMid;
                asset.url = [self parseString:[dimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:-1];
                
                // relation
                asset.movie = movie;
                [movie addAssetsObject:asset];
                
                // done
                asset_mid = YES;
                
            }
            
            // poster thumb
            if (! asset_thumb && [ptype isEqualToString:@"poster"] && [psize isEqualToString:@"thumb"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetPoster;
                asset.size = assetSizeThumb;
                asset.url = [self parseString:[dimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:-1];
                
                // relation
                asset.movie = movie;
                [movie addAssetsObject:asset];
                
                // done
                asset_thumb = YES;
                
            }
            
        }

        
        // backdrops
        int bdcount = 0;
        NSArray *backdrops = [djson objectForKey:@"backdrops"];
        for (NSDictionary *dbackdrop in backdrops)	{
            
            // type
            NSDictionary *bimage = [dbackdrop objectForKey:@"image"];
            NSString *btype = [self parseString:[bimage objectForKey:@"type"]];
            NSString *bsize = [self parseString:[bimage objectForKey:@"size"]];
            
            // backdrop
            if ([btype isEqualToString:@"backdrop"] && [bsize isEqualToString:@"original"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetBackdrop;
                asset.size = assetSizeOriginal;
                asset.url = [self parseString:[bimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:bdcount++];
                
                // relation
                asset.movie = movie;
                [movie addAssetsObject:asset];
                
            }
        }
    }
    
    
    // loaded
    movie.loaded = [NSNumber numberWithBool:YES];
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // notify
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:mid type:typeMovie message:[error localizedDescription]];
        }
    }
    
    
    // return
    return movie;
}


/*
 * Query person.
 */
- (Person*)queryPerson:(NSNumber*)pid {
    FLog();
    
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@/en/json/%@/%i",apiTMDbPerson,apiTMDbKey,[pid intValue]];
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
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:pid type:typePerson message:[error localizedDescription]];
        }
        
        
        // fluff back
        return NULL;
    }
    
    
    // Person
    Person *person = [self cachedPerson:pid];
    if (person == NULL) {
        
        // create object
        person = (Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
    }
    
    
    // parse json
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    //NSLog(@"%@",json);
    
    
    // result
    if (([json rangeOfString : @"Nothing found."].location != NSNotFound)) {
        
        // oops
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:pid type:typePerson message:NSLocalizedString(@"Nothing found.", @"Nothing found.")];
        }
        
        // nothing
        return NULL;
    }
    
    
    // person
    NSDictionary *djson = [[parser objectWithString:json error:nil] objectAtIndex:0];
    
    // validate
    if ([self validPerson:djson]) {
            
        
        // movie
        person.pid = [self parseNumber:[djson objectForKey:@"id"]];
        person.name = [self parseString:[djson objectForKey:@"name"]];
        person.biography = [self parseString:[djson objectForKey:@"biography"]];
        person.birthday = [self parseDate:[djson objectForKey:@"birthday"]];
        person.birthplace = [self parseString:[djson objectForKey:@"birthplace"]];
        person.known_movies = [self parseNumber:[djson objectForKey:@"known_movies"]];
        
        
        // estimate if director, crew or actor...
        int dcount = 0;
        int ccount = 0;
        int acount = 0;
        
        // movies
        NSArray *movies = [djson objectForKey:@"filmography"];
        NSMutableDictionary *parsedMovies = [[NSMutableDictionary alloc] init];
         NSMutableDictionary *parsedMovie2Persons = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dmovie in movies)	{
            
            // validate
            if ([self validMovie:dmovie]) {
            
                // Movie
                NSNumber *mid = [self parseNumber:[dmovie objectForKey:@"id"]];
                Movie *movie = [parsedMovies objectForKey:mid];
                if (movie == NULL) {
                    movie = [self cachedMovie:mid];
                }
                if (movie == NULL) {
                    
                    // object
                    movie = (Movie*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
                    
                    // data
                    movie.mid = mid;
                    movie.name = [self parseString:[dmovie objectForKey:@"name"]];
                    movie.released = [self parseDate:[dmovie objectForKey:@"release"]];
                    
                    // profile
                    Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    asset.type = assetPoster;
                    asset.size = assetSizeThumb;
                    asset.url = [self parseString:[dmovie objectForKey:@"poster"]];
                    asset.sort = [NSNumber numberWithInt:-1];
                    
                    // relation
                    asset.movie = movie;
                    [movie addAssetsObject:asset];
                    
                    // defaults
                    movie.loaded = NO;
                }
                NSLog(@"movie = %@ id = %i",movie.name,[movie.mid intValue]);
                
                // Movie2Person
                Movie2Person *m2p = [parsedMovie2Persons objectForKey:mid];
                if (m2p == NULL) {
                    m2p = [self cachedMovie2Person:mid person:pid];
                }
                if (m2p == NULL) {
                    
                    // create object
                    m2p = (Movie2Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie2Person" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    m2p.mid = mid;
                    m2p.pid = pid;
                    m2p.year = movie.released;
                    
                    // reference
                    m2p.movie = movie;
                    m2p.person = person;
                }
                               
                // update data
                m2p.type = [self updateType:m2p.type updated:[self parseString:[dmovie objectForKey:@"department"]]];
                m2p.department = [self updateDepartment:m2p.department updated:[self parseString:[dmovie objectForKey:@"department"]]];
                m2p.job = [self updateJob:m2p.job updated:[self parseString:[dmovie objectForKey:@"job"]]];
                m2p.character = [self updateCharacter:m2p.character updated:[self parseString:[dmovie objectForKey:@"character"]]];
                m2p.order = [self updateOrder:m2p.order updated:[dmovie objectForKey:@"order"]];
                
                // count
                if ([m2p.type isEqualToString:typePersonDirector]) {
                    
                    // director
                    dcount++;
                }
                else if ([m2p.type isEqualToString:typePersonCrew]) {
                    
                    // crew
                    ccount++;
                }
                else {
                    
                    // actor
                    acount++;
                }
                
                // add
                [person addMoviesObject:m2p];
                [parsedMovies setObject:movie forKey:mid];
                [parsedMovie2Persons setObject:m2p forKey:mid];
            }
        }
        
        // release
        [parsedMovies release];
        [parsedMovie2Persons release];
        
        // type crew
        if (ccount > acount) {
            person.type = typePersonCrew;
        }
        
        // type actor
        else {
            person.type = typePersonActor;
        }
        
        // director
        if (dcount > acount && dcount > ccount) {
            person.type = typePersonDirector;
        }
        
        
        
        // assets
        BOOL asset_thumb = NO;
        BOOL asset_mid = NO;
        BOOL asset_original = NO;
        NSArray *profiles = [djson objectForKey:@"profile"];
        for (NSDictionary *dprofile in profiles)	{
            
            // type
            NSDictionary *dimage = [dprofile objectForKey:@"image"];
            NSString *ptype = [self parseString:[dimage objectForKey:@"type"]];
            NSString *psize = [self parseString:[dimage objectForKey:@"size"]];
            
            // profile original
            if (! asset_original && [ptype isEqualToString:@"profile"] && [psize isEqualToString:@"original"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetProfile;
                asset.size = assetSizeOriginal;
                asset.url = [self parseString:[dimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:-1];
                
                // relation
                asset.person = person;
                [person addAssetsObject:asset];
                
                // done
                asset_original = YES;
                
            }
            
            // profile mid
            if (! asset_mid && [ptype isEqualToString:@"profile"] && [psize isEqualToString:@"profile"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetProfile;
                asset.size = assetSizeMid;
                asset.url = [self parseString:[dimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:-1];
                
                // relation
                asset.person = person;
                [person addAssetsObject:asset];
                
                // done
                asset_mid = YES;
                
            }
            
            // profile thumb
            if (! asset_thumb && [ptype isEqualToString:@"profile"] && [psize isEqualToString:@"thumb"]) {
                
                // create object
                Asset *asset = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                
                // set data
                asset.type = assetProfile;
                asset.size = assetSizeThumb;
                asset.url = [self parseString:[dimage objectForKey:@"url"]];
                asset.sort = [NSNumber numberWithInt:-1];
                
                // relation
                asset.person = person;
                [person addAssetsObject:asset];
                
                // done
                asset_thumb = YES;
                
            }
        }
    }
        
    // loaded
    person.loaded = [NSNumber numberWithBool:YES];
    
    // save
    if (![managedObjectContext save:&error]) {
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // notify
        if (delegate && [delegate respondsToSelector:@selector(apiError:type:message:)]) {
            [delegate apiError:pid type:typePerson message:[error localizedDescription]];
        }
    }
    

    
    // return
    return person;
}



#pragma mark -
#pragma mark Parser

/*
 * Parse.
 */
- (NSString*)parseString:(NSObject *)token {
    return (! [self isEmpty:token]) ? (NSString*)token : @"";
}
- (NSNumber*)parseNumber:(NSObject *)token {
    
    // formatter
    static NSNumberFormatter *numberFormatter;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle]; // crucial
    }
    
    // return
    NSString *nb = [NSString stringWithFormat:@"%@",(NSString*)token];
    return (! [self isEmpty:token]) ? [numberFormatter numberFromString:nb] : [NSNumber numberWithInt:-1];
}
- (NSDate*)parseDate:(NSObject *)token {
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    // return
    return (! [self isEmpty:token]) ? [dateFormatter dateFromString:(NSString*)token] : NULL;
    
}
- (NSString*)parseYear:(NSObject *)token {
    
    // formatter
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    static NSDateFormatter *yearFormatter;
    if (yearFormatter == nil) {
        yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yyyy"];
    }
    
    // return
    return (! [self isEmpty:token]) ? [yearFormatter stringFromDate:[dateFormatter dateFromString:(NSString*)token]] : @"";
    
}

/*
 * Update data.
 */
- (NSString*)updateDepartment:(NSString *)original updated:(NSString *)updated {
    
    // initial
    if ([self isEmpty:original]) {
        return updated;
    }
    
    // update
    else if (! [self isEmpty:updated] && [original rangeOfString:updated].location == NSNotFound) {
        
        // separator
        NSString *sep = ([self isEmpty:original]) ? @"" : @", ";
        
        // append
        return [NSString stringWithFormat:@"%@%@%@",original,sep,updated];
    }
    
    // original
    return original;
}
- (NSString*)updateCharacter:(NSString *)original updated:(NSString *)updated {
    
    // initial
    if ([self isEmpty:original]) {
        return updated;
    }
    
    // update
    else if (! [self isEmpty:updated] && [original rangeOfString:updated].location == NSNotFound) {
        
        // separator
        NSString *sep = ([self isEmpty:original]) ? @"" : @", ";
        
        // append
        return [NSString stringWithFormat:@"%@%@%@",original,sep,updated];
    }
    
    // original
    return original;
}
- (NSString*)updateJob:(NSString *)original updated:(NSString *)updated {
    
    // initial
    if ([self isEmpty:original]) {
        
        // exclude
        if ([updated rangeOfString:@"Actor"].location == NSNotFound) {
            return updated;
        }
        return @"";
    }
    
    // update
    else if (! [self isEmpty:updated] && [original rangeOfString:updated].location == NSNotFound && [updated rangeOfString:@"Actor"].location == NSNotFound) {
        
        // separator
        NSString *sep = ([self isEmpty:original]) ? @"" : @", ";
        
        // append
        return [NSString stringWithFormat:@"%@%@%@",original,sep,updated];
    }
    
    // original
    return original;
}
- (NSNumber*)updateOrder:(NSNumber *)original updated:(NSNumber *)updated {
    
    // updated
    if ([updated intValue] != 0) {
        return updated;
    }
    
    // original
    return original;
}
- (NSString*)updateType:(NSString *)original updated:(NSString *)updated {
    
    // director
    if ((! [self isEmpty:original] && [original rangeOfString:typePersonDirector].location != NSNotFound) || [updated rangeOfString:@"Directing"].location != NSNotFound) {
        return typePersonDirector;
    }
    // actor
    else if (! [self isEmpty:original] && [original rangeOfString:typePersonActor].location != NSNotFound) {
        return typePersonActor;
    }
    // determine type
    else {
        
        // director
        if ([updated rangeOfString:@"Directing"].location != NSNotFound) {
            return typePersonDirector;
        }
        // actor
        else if ([updated rangeOfString:@"Actors"].location != NSNotFound) {
            return typePersonActor;
        }
        // actor
        else {
            return typePersonCrew;
        }
    }
}

/*
 * Checks if empty.
 */
- (BOOL)isEmpty:(id)thing {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

/*
 * Validate SearchResult.
 */
- (BOOL)validSearchResult:(NSDictionary *)dresult {
    
    // exclude adult
    if ([[dresult objectForKey:@"adult"] boolValue]) {
        return NO;
    }
    
    // valid
    return YES;
}

/*
 * Validate Movie.
 */
- (BOOL)validMovie:(NSDictionary *)dmovie {
    
    // kosher
    if ([[self parseNumber:[dmovie objectForKey:@"id"]] intValue] <= 0) {
        return NO;
    }
    
    // exclude adult
    if ([[dmovie objectForKey:@"adult"] boolValue]) {
        return NO;
    }
    
    // exclude by title
    NSString *name = [[self parseString:[dmovie objectForKey:@"name"]] lowercaseString];
    if ([name rangeOfString:@"obsolete"].location != NSNotFound) {
        return NO; 
    }
    
    // valid
    return YES;
}

/*
 * Validate Person.
 */
- (BOOL)validPerson:(NSDictionary *)dperson {
    
    // kosher
    if ([[self parseNumber:[dperson objectForKey:@"id"]] intValue] <= 0) {
        return NO;
    }
    
    // exclude adult
    if ([[dperson objectForKey:@"adult"] boolValue]) {
        return NO;
    }
    
    // valid
    return YES;
}




#pragma mark -
#pragma mark Core Data stack


/**
 * Returns the path to the application's Cache directory.
 */
- (NSString *)applicationCachesDirectory {
    GLog();
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
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
	NSString *storePath = [[self applicationCachesDirectory] stringByAppendingPathComponent:TMDbStore];
	
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
		NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
		
		// show info
        if (delegate && [delegate respondsToSelector:@selector(apiFatal:)]) {
            [delegate apiFatal:@"Corrupted Cache. Please try to clear the cache or reinstall the application... Sorry about this."];
        }
    
    }    
	
	// return
    return persistentStoreCoordinator;
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
