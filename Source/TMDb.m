//
//  TMDb.m
//  Solyaris
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
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

#import "TMDb.h"
#import "APIKeys.h"
#import "SBJson.h"
#import "SolyarisConstants.h"
#import "Tracker.h"


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
- (BOOL)validSearch:(NSDictionary*)dresult;
- (BOOL)validMovie:(NSDictionary*)dmovie;
- (BOOL)validPerson:(NSDictionary*)dperson;
- (BOOL)validResponse:(NSString*)response;
- (BOOL)validResult:(NSString*)result;
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
- (Search*)querySearchMovie:(NSString*)query retry:(BOOL)retry;
- (Search*)querySearchPerson:(NSString*)query retry:(BOOL)retry;
- (Movie*)queryMovie:(NSNumber*)mid retry:(BOOL)retry;
- (Person*)queryPerson:(NSNumber*)pid retry:(BOOL)retry;
@end


/**
 * API TMDb.
 */
@implementation TMDb


#pragma mark -
#pragma mark Constants


// constants
#define kTMDbStore              @"TMDb.sqlite"
#define kTMDbTimeRetryBase      2.5f
#define kTMDbTimeRetryRandom	2.5f
#define kTMDbTimeQueueBase      0.5f
#define kTMDbTimeQueueRandom	1.0f


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
            NSLog(@"TMDb CoreData Corrupted Cache");
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
 * Reset.
 */
- (void)reset {
    DLog();
    
    // queue
    [queue cancelAllOperations];
    
    // unlock
    [managedObjectContext unlock];
    
}

/**
 * Search.
 */
- (void)searchMovie:(NSString*)q {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        NSString *query = [q lowercaseString];
        Search *search = [self cachedSearch:query type:typeMovie];
        if (search == NULL) {
            search = [self querySearchMovie:query retry:YES];
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
- (void)searchPerson:(NSString*)q {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        NSString *query = [q lowercaseString];
        Search *search = [self cachedSearch:query type:typePerson];
        if (search == NULL) {
            search = [self querySearchPerson:query retry:YES];
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
            movie = [self queryMovie:mid retry:YES];
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
        movie = [self queryMovie:mid retry:YES];
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
            person = [self queryPerson:pid retry:YES];
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
        person = [self queryPerson:pid retry:YES];
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
	NSString *storePath = [[self applicationCachesDirectory] stringByAppendingPathComponent:kTMDbStore];
	
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
    
    // managed context
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        
        // handle the error
        if (delegate && [delegate respondsToSelector:@selector(apiFatal:message:)]) {
            [delegate apiFatal:NSLocalizedString(@"Data Error", "Data Error")
                       message:NSLocalizedString(@"Corrupted Data. Please try to reinstall the application. Sorry about this.", "Corrupted Data. Please try to reinstall the application. Sorry about this.")];
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
- (Search*)querySearchMovie:(NSString*)query retry:(BOOL)retry {
    FLog();
        
    // queue time
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
    // request
    NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@/en/json/%@/%@",apiTMDbSearchMovie,apiTMDbKey,equery];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    // connection
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    // connection error
    if (error) {
        
        // roll back tha thing
        [managedObjectContext rollback];
        
        // oops
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            
            // error
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // fluff search
        return NULL;
    }
    
    // json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    
    // invalid response 
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid movie search: %@", query);
        NSLog(@"%@",json);
        #endif
        
        // back
        [managedObjectContext rollback];
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self querySearchMovie:query retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable")
                                                      message:NSLocalizedString(@"Could not search movie. \nPlease try again later.", @"Could not search movie. \nPlease try again later.")] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // damn it
        return NULL;
        
    }
    
    // search result
    Search *search = (Search*)[NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:managedObjectContext];
    search.type = typeMovie;
    search.query = query;
    
    
    // parse result
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *results = [parser objectWithString:json error:nil];
        [parser release];
        for (NSDictionary *dresult in results)	{
            SearchResult *searchResult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validSearch:dresult]) {
                
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
  
    }
    
    
    // save
    if (! [managedObjectContext save:&error]) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Data Error", @"TMDb Service Unavailable") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // fluff
        return NULL;
        
    }
    
    // at last...
    return search;
    
}

- (Search*)querySearchPerson:(NSString*)query retry:(BOOL)retry {
    FLog();
        
    // still waiting
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
    // request
    NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@/en/json/%@/%@",apiTMDbSearchPerson,apiTMDbKey,equery];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    
    // connection
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    // connection error
    if (error) {
        
        // rolling
        [managedObjectContext rollback];
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // niet
        return NULL;
    }
    
    
    // json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
    
    // invalid response
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid person search: %@",query);
        NSLog(@"%@",json);
        #endif
        
        // rollin back
        [managedObjectContext rollback];
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self querySearchPerson:query retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable")
                                                      message:NSLocalizedString(@"Could not search person. \nPlease try again later.", @"Could not search person. \nPlease try again later.")] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // null
        return NULL;
    }
    
    // search result
    Search *search = (Search*)[NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:managedObjectContext];
    search.type = typePerson;
    search.query = query;
    
    // parse result
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *results = [parser objectWithString:json error:nil];
        [parser release];
        for (NSDictionary *dresult in results)	{
            SearchResult *searchResult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validSearch:dresult]) {
                
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

    }
    
    // save
    if (! [managedObjectContext save:&error]) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // niet
        return NULL;
        
    }
    
    // here it is
    return search;
}



/*
 * Query movie.
 */
- (Movie*)queryMovie:(NSNumber*)mid retry:(BOOL)retry {
    FLog();
    
    // play nice with tmdb...
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
	
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
    FLog("received data.");
    
    // connection error
    if (error) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error")
                                                      message:[error localizedDescription]] autorelease];
            [apiError setDataId:mid];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // fluff back
        return NULL;
    }
    
    
    // json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // invalid response
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid response %i",[mid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryMovie:mid retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable") 
                                                      message:NSLocalizedString(@"Could not load movie. \nPlease try again later.", @"Could not load movie. \nPlease try again later.")] autorelease];
            [apiError setDataId:mid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    // parse result
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *djson = [[parser objectWithString:json error:nil] objectAtIndex:0];
    [parser release];
    if (! [self validResult:json] || ! [self validMovie:djson]) {
        #ifdef DEBUG
        NSLog(@"Movie not found %i",[mid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service", @"TMDb Service") 
                                                      message:NSLocalizedString(@"Movie not found.", @"Movie not found.")] autorelease];
            [apiError setDataId:mid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    
    // movie
    Movie *movie = [self cachedMovie:mid];
    if (movie == NULL) {
        movie = (Movie*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
    }
    
    
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
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error") 
                                                      message:[error localizedDescription]] autorelease];
            [apiError setDataId:mid];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // fluff
        return NULL;
        
    }
    
    
    
    // return
    return movie;
}


/*
 * Query person.
 */
- (Person*)queryPerson:(NSNumber*)pid retry:(BOOL)retry {
    FLog();
    
    // play nice with tmdb...
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
	
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
    FLog("received data.");
    
    // connection error
    if (error) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error") 
                                                      message:[error localizedDescription]] autorelease];
            [apiError setDataId:pid];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // fluff back
        return NULL;
    }
    
    
    // json
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    
    
    // invalid response
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid response %i",[pid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryPerson:pid retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable") 
                                                      message:NSLocalizedString(@"Could not load person. \nPlease try again later.", @"Could not load person. \nPlease try again later.")] autorelease];
            [apiError setDataId:pid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    
    // parse result
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *djson = [[parser objectWithString:json error:nil] objectAtIndex:0];
    [parser release];
    if (! [self validResult:json] || ! [self validPerson:djson]) {
        #ifdef DEBUG
        NSLog(@"Person not found %i",[pid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"TMDb Service", @"TMDb Service") 
                                                      message:NSLocalizedString(@"Person not found.", @"Person not found.")] autorelease];
            [apiError setDataId:pid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    
    // Person
    Person *person = [self cachedPerson:pid];
    if (person == NULL) {
        
        // create object
        person = (Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
    }

    
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
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error")
                                                      message:[error localizedDescription]] autorelease];
            [apiError setDataId:pid];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // fluff
        return NULL;
        
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
- (BOOL)validSearch:(NSDictionary *)dresult {
    
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

/*
 * Validate server response.
 */
- (BOOL)validResponse:(NSString *)response {
    
    // service down
    if ([response length] <= 0) {
        
        // track
        [Tracker trackEvent:TEventAPI action:@"Error" label:@"down"];
        
        // shit
        return NO;
    }
    
    // service unavailable
    if ([response rangeOfString : @"503 Service Unavailable"].location != NSNotFound) {
        
        // track
        [Tracker trackEvent:TEventAPI action:@"Error" label:@"unavailable"];
        
        // not again...
        return NO;
    }
    
    // suppose that's ok
    return YES;
}

/*
 * Validate result.
 */
- (BOOL)validResult:(NSString *)result {
    
    // nothing found
    if ([result rangeOfString : @"Nothing found."].location != NSNotFound) {
        return NO;
    }
    
    // yup
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
	NSString *storePath = [[self applicationCachesDirectory] stringByAppendingPathComponent:kTMDbStore];
	
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
        if (delegate && [delegate respondsToSelector:@selector(apiFatal:message:)]) {
            [delegate apiFatal:NSLocalizedString(@"Data Error", "Data Error")
                       message:NSLocalizedString(@"Corrupted Cache. Please try to clear the cache or reinstall the application... Sorry about this.",@"Corrupted Cache. Please try to clear the cache or reinstall the application... Sorry about this.")];
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
    
    // queue
    [queue release];
    
    // super
    [super dealloc];
}


@end



/**
 * APIError.
 */
@implementation APIError

#pragma mark -
#pragma mark Properties

// accessors
@synthesize dataId;
@synthesize dataType;
@synthesize errorTitle;
@synthesize errorMessage;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initError:(NSString*)type title:(NSString*)title message:(NSString*)message {
    GLog();
    
    // self
    if ((self = [super init])) {
        self.dataId = [NSNumber numberWithInt:-1];
        self.dataType = type;
		self.errorTitle = title;
        self.errorMessage = message;
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
    [dataId release];
    [dataType release];
	[errorMessage release];
    [errorTitle release];
	
	// super
    [super dealloc];
}


@end
