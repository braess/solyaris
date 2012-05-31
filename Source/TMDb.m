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
#import "DataCounter.h"
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
+ (NSString *)applicationCachesDirectory;
@end


/**
 * Core Data Stack.
 */
@interface TMDb (ParserStack)
- (NSString*)parseString:(NSObject*)token;
- (NSNumber*)parseNumber:(NSObject*)token;
- (NSString*)parseImage:(NSObject*)token type:(NSString*)type;
- (NSDate*)parseDate:(NSObject*)token;
- (NSString*)parseYear:(NSObject *)token;
- (NSString*)updateCharacter:(NSString*)original updated:(NSString*)updated;
- (NSString*)updateJob:(NSString*)original updated:(NSString*)updated;
- (NSString*)updateDepartment:(NSString*)original updated:(NSString*)updated;
- (NSNumber*)updateOrder:(NSNumber*)original updated:(NSNumber*)updated;
- (NSString*)updateType:(NSString*)original updated:(NSString*)updated;
- (NSString*)updateCategory:(NSSet*)genres;
- (BOOL)isEmpty:(id)thing;
- (BOOL)validSearch:(NSDictionary*)dresult;
- (BOOL)validPopular:(NSDictionary*)dresult;
- (BOOL)validNowPlaying:(NSDictionary*)dresult;
- (BOOL)validMovie:(NSDictionary*)dmovie;
- (BOOL)validSimilar:(NSDictionary*)dresult;
- (BOOL)validPerson:(NSDictionary*)dperson;
- (BOOL)validResponse:(NSString*)response;
- (BOOL)validResult:(NSString*)result;
@end


/**
 * Cache Stack.
 */
@interface TMDb (CacheStack)
- (Search*)cachedSearch:(NSString*)query type:(NSString*)type;
- (Popular*)cachedPopular:(NSString*)ident type:(NSString*)type;
- (NowPlaying*)cachedNowPlaying:(NSString*)ident type:(NSString*)type;
- (NSArray*)cachedHistory:(NSString *)type;
- (Movie*)cachedMovie:(NSNumber*)mid;
- (Genre*)cachedGenre:(NSNumber*)gid;
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
- (Popular*)queryPopularMovies:(NSString*)ident retry:(BOOL)retry;
- (NowPlaying*)queryNowPlaying:(NSString*)ident retry:(BOOL)retry;
- (Movie*)queryMovie:(NSNumber*)mid retry:(BOOL)retry;
- (Movie*)queryMovieDetails:(Movie*)movie retry:(BOOL)retry;
- (Movie*)queryMovieRelated:(Movie*)movie retry:(BOOL)retry;
- (Movie*)queryMovieCasts:(Movie*)movie retry:(BOOL)retry;
- (Movie*)queryMovieImages:(Movie*)movie retry:(BOOL)retry;
- (Movie*)queryMovieTrailers:(Movie *)movie retry:(BOOL)retry;
- (Person*)queryPerson:(NSNumber*)pid retry:(BOOL)retry;
- (Person*)queryPersonCredits:(Person*)person retry:(BOOL)retry;
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
#define kTMDbTimeQueueDetail    0.6f
#define kTMDbTimeout            15.0f
#define kTMDbTimeoutQuery       10.0f
#define kTMDbTimeoutDetail      5.0f

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
        Search *search = [self cachedSearch:q type:typeMovie];
        if (search == NULL) {
            search = [self querySearchMovie:q retry:YES];
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
        Search *search = [self cachedSearch:q type:typePerson];
        if (search == NULL) {
            search = [self querySearchPerson:q retry:YES];
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
 * Popular.
 */
- (void)popularMovies:(BOOL)more {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // formatter
        static NSDateFormatter *pmFormatter;
        if (pmFormatter == nil) {
            pmFormatter = [[NSDateFormatter alloc] init];
            [pmFormatter setDateFormat:@"yyyy_ww"];
        }
        
        // ident
        NSString *ident = [pmFormatter stringFromDate:[NSDate date]];
        
        // context
        [managedObjectContext lock];
        
        // cached
        Popular *popular = [self cachedPopular:ident type:typeMovie];
        
        // query
        if (popular == NULL || (popular && more)) {
            popular = [self queryPopularMovies:ident retry:YES];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedPopular:more:)]) {
                [delegate loadedPopular:popular more:more];
            }
            
        }];
        
    }];
    
}


/**
 * Now Playing.
 */
- (void)nowPlaying:(BOOL)more {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // formatter
        static NSDateFormatter *npFormatter;
        if (npFormatter == nil) {
            npFormatter = [[NSDateFormatter alloc] init];
            [npFormatter setDateFormat:@"yyyy_ww"];
        }
        
        // ident
        NSString *ident = [npFormatter stringFromDate:[NSDate date]];
        
        // context
        [managedObjectContext lock];
        
        // cached
        NowPlaying *nowplaying = [self cachedNowPlaying:ident type:typeMovie];
        
        // query
        if (nowplaying == NULL || (nowplaying && more)) {
            nowplaying = [self queryNowPlaying:ident retry:YES];
        }
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedNowPlaying:more:)]) {
                [delegate loadedNowPlaying:nowplaying more:more];
            }
            
        }];
        
    }];
    
}

/**
 * History movie.
 */
- (void)historyMovie {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // context
        [managedObjectContext lock];
        
        // cached
        NSArray *history = [self cachedHistory:typeMovie];
        
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedHistory:type:)]) {
                [delegate loadedHistory:history type:typeMovie];
            }
            
        }];
        
    }];
    
}
- (void)historyPerson {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // context
        [managedObjectContext lock];
        
        // cached
        NSArray *history = [self cachedHistory:typePerson];
        
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // delegate
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedHistory:type:)]) {
                [delegate loadedHistory:history type:typePerson];
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
 * Movie data.
 */
- (void)movieData:(NSNumber *)mid {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
    
        // cache
        [managedObjectContext lock];
    
        // movie    
        Movie *movie = [self cachedMovie:mid];
        if (movie == NULL || ! [movie.loaded boolValue]) {
            movie = [self queryMovie:mid retry:YES];
        }
    
        // details
        if (! [movie.details boolValue]) {
            movie = [self queryMovieDetails:movie retry:YES];
        }
        
        // unlock
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // loaded
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedMovieData:)]) {
                [delegate loadedMovieData:movie];
            }
            
        }];

        
    }];
    
}


/**
 * Movie related.
 */
- (void)movieRelated:(NSNumber *)mid more:(BOOL)more {
    DLog();
    
    // queue
    [queue addOperationWithBlock:^{
        
        // cache
        [managedObjectContext lock];
        
        // movie    
        Movie *movie = [self cachedMovie:mid];
        if (movie == NULL) {
            movie = [self queryMovie:mid retry:YES];
        }
        
        // related
        if (! [movie.related boolValue] || more) {
            movie = [self queryMovieRelated:movie retry:YES];
        }
        
        // unlock
        [managedObjectContext unlock];
        
        // delegate
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // loaded
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedMovieRelated:more:)]) {
                [delegate loadedMovieRelated:movie more:more];
            }
            
        }];
        
        
    }];
    
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
 * Person Data.
 */
- (void)personData:(NSNumber *)pid {
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
            if (delegate != nil && [delegate respondsToSelector:@selector(loadedPersonData:)]) {
                [delegate loadedPersonData:person];
            }
            
        }];
        
    }];
    
    
}


/**
 * Movie thumb.
 */
- (NSString*)movieThumb:(NSNumber *)mid {
    GLog();
    
    // thumb
    NSString *thumb = [NSString stringWithString:@""];
    
    // cache
    [managedObjectContext lock];
    Movie *movie = [self cachedMovie:mid];
    if (movie != NULL) {
        
        // assets
        for (Asset *asset in movie.assets) {
            if ([asset.type isEqualToString:assetPoster] && [asset.size isEqualToString:assetSizeThumb]) {
                thumb = [NSString stringWithString:(asset.value ? [NSString stringWithString:asset.value] : @"")];
                break;
            }
        }
    }
    [managedObjectContext unlock];
    
    // return thumb
    return thumb;
}


/**
 * Person thumb.
 */
- (NSString*)personThumb:(NSNumber *)pid {
    GLog();
    
    // thumb
    NSString *thumb = [NSString stringWithString:@""];
    
    // cache
    [managedObjectContext lock];
    Person *person = [self cachedPerson:pid];
    if (person != NULL) {
        
        // assets
        for (Asset *asset in person.assets) {
            if ([asset.type isEqualToString:assetProfile] && [asset.size isEqualToString:assetSizeThumb]) {
                thumb = [NSString stringWithString:(asset.value ? [NSString stringWithString:asset.value] : @"")];
                break;
            }
        }
    }
    [managedObjectContext unlock];
    
    // return thumb
    return thumb;
}



/**
 * Returns the cached movies.
 */
- (NSArray*)movies {
    DLog();
    
    // cache
    [managedObjectContext lock];
    NSArray *movies = [self cachedMovies];
    [managedObjectContext unlock];
    
    // return
    return movies;
}



#pragma mark -
#pragma mark Class

/**
 * Clears the cache.
 */
+ (void)clearCache {
    DLog();
    
    // path
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *storePath = [[TMDb applicationCachesDirectory] stringByAppendingPathComponent:kTMDbStore];
	
	// remove existing db
	if ([fileManager fileExistsAtPath:storePath]) {
		[fileManager removeItemAtPath:storePath error:NULL];
	}
}
- (void)resetCache {
    DLog();
    
    // remove
    [TMDb clearCache];
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(query ==[c] %@ && type == %@)", query, type];
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
 * Cached popular.
 */
- (Popular*)cachedPopular:(NSString *)ident type:(NSString *)type {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Popular" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ident == %@ && type == %@)", ident, type];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Popular *p = NULL;
    if (array != nil && [array count] > 0) {
        p = (Popular*) [array objectAtIndex:0];
    }
    
    // return
    return p;
    
}


/*
 * Cached now playing.
 */
- (NowPlaying*)cachedNowPlaying:(NSString *)ident type:(NSString *)type {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"NowPlaying" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ident == %@ && type == %@)", ident, type];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    NowPlaying *np = NULL;
    if (array != nil && [array count] > 0) {
        np = (NowPlaying*) [array objectAtIndex:0];
    }
    
    // return
    return np;
}

/*
 * Cached history.
 */
- (NSArray*)cachedHistory:(NSString *)type {
    GLog();
    
    // type
    NSString *ent = [NSString stringWithString:[type isEqualToString:typeMovie] ? @"Movie" : @"Person" ];
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:ent inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(loaded == %@)",[NSNumber numberWithBool:YES]];
    [request setPredicate:predicate];
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // return
    return array;
    
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
 * Cached genre.
 */
- (Genre*)cachedGenre:(NSNumber *)gid {
    GLog();
    
    // context
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gid = %@", gid];
    [request setPredicate:predicate];
    
    // limit
    [request setFetchLimit:1];
    
    
    // fetch
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // result
    Genre *genre = NULL;
    if (array != nil && [array count] > 0) {
        genre = (Genre*) [array objectAtIndex:0];
    }
    
    // return
    return genre;
    
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
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"querySearchMovie"];
        
    // queue time
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
    // request
    NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@?api_key=%@&query=%@",apiTMDbSearchMovie,apiTMDbKey,equery];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeout];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
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
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];  
    
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
    
    // search data
    Search *search = (Search*)[NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:managedObjectContext];
    search.type = typeMovie;
    search.query = query;
    
    
    // parse result
    int count = 0;
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *djson = [parser objectWithString:json error:nil];
        [parser release];
        
        // results
        NSArray *results = [djson objectForKey:@"results"];
        for (NSDictionary *dresult in results)	{
            
            // result data
            SearchResult *searchResult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validSearch:dresult]) {
                
                // dta
                NSString *dta = [self parseString:[dresult objectForKey:@"original_title"]];
                if (! [self isEmpty:[dresult objectForKey:@"release_date"]]) {
                    dta = [NSString stringWithFormat:@"%@ (%@)",dta,[self parseYear:[dresult objectForKey:@"release_date"]]];
                }
                
                // data
                searchResult.ref = [self parseNumber:[dresult objectForKey:@"id"]];
                searchResult.data = dta;
                searchResult.type = typeMovie;
                searchResult.thumb = [self parseImage:[dresult objectForKey:@"poster_path"] type:apiTMDbPosterThumb];
                
                
                // add
                count++;
                [search addResultsObject:searchResult];
            }
        }
  
    }
    
    // count
    search.count = [NSNumber numberWithInt:count];
    
    
    // save
    if (! [managedObjectContext save:&error]) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error") 
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
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"querySearchPerson"];
        
    // still waiting
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
    // request
    NSString *equery = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@?api_key=%@&query=%@",apiTMDbSearchPerson,apiTMDbKey,equery];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeout];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
    
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
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
    
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
    int count = 0;
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *djson = [parser objectWithString:json error:nil];
        [parser release];
        
        // results
        NSArray *results = [djson objectForKey:@"results"];
        for (NSDictionary *dresult in results)	{
            SearchResult *searchResult = (SearchResult*)[NSEntityDescription insertNewObjectForEntityForName:@"SearchResult" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validSearch:dresult]) {
                
                // data
                searchResult.ref = [self parseNumber:[dresult objectForKey:@"id"]];
                searchResult.data = [self parseString:[dresult objectForKey:@"name"]];
                searchResult.type = typePerson;
                searchResult.thumb = [self parseImage:[dresult objectForKey:@"profile_path"] type:apiTMDbProfileThumb];
                
                // add
                count++;
                [search addResultsObject:searchResult];
            }
        }

    }
    
    // count
    search.count = [NSNumber numberWithInt:count];
    
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
 * Query popular.
 */
- (Popular*)queryPopularMovies:(NSString *)ident retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryPopularMovies"];
    
    // popular data
    Popular *popular = [self cachedPopular:ident type:typeMovie];
    if (popular == NULL) {
        
        // create
        popular = (Popular*)[NSEntityDescription insertNewObjectForEntityForName:@"Popular" inManagedObjectContext:managedObjectContext];
        popular.type = typeMovie;
        popular.ident = ident;
        popular.page = [NSNumber numberWithInt:0];
        popular.count = [NSNumber numberWithInt:0];
        popular.total = [NSNumber numberWithInt:0];
    }
    
    
    // queue time
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
    // request
    NSString *url = [NSString stringWithFormat:@"%@?api_key=%@&page=%i",apiTMDbPopularMovies,apiTMDbKey,[popular.page intValue]+1];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeout];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
    // connection
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    // connection error
    if (error) {
        
        // rollback
        [managedObjectContext rollback];
        
        // delegate
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            
            // error
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
    
    // invalid response 
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid popular query: %@", ident);
        NSLog(@"%@",json);
        #endif
        
        // back
        [managedObjectContext rollback];
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryPopularMovies:ident retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable")
                                                      message:NSLocalizedString(@"Could not load movies. \nPlease try again later.", @"Could not load movies. \nPlease try again later.")] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nuff
        return NULL;
        
    }
    
    
    
    // parse result
    int count = 0;
    int sort = [popular.count intValue];
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *djson = [parser objectWithString:json error:nil];
        [parser release];
        
        // results
        NSArray *results = [djson objectForKey:@"results"];
        for (NSDictionary *dresult in results)	{
            
            // result data
            PopularResult *popularResult = (PopularResult*)[NSEntityDescription insertNewObjectForEntityForName:@"PopularResult" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validPopular:dresult]) {
                
                // dta
                NSString *dta = [self parseString:[dresult objectForKey:@"original_title"]];
                if (! [self isEmpty:[dresult objectForKey:@"release_date"]]) {
                    dta = [NSString stringWithFormat:@"%@ (%@)",dta,[self parseYear:[dresult objectForKey:@"release_date"]]];
                }
                
                // data
                popularResult.ref = [self parseNumber:[dresult objectForKey:@"id"]];
                popularResult.data = dta;
                popularResult.type = typeMovie;
                popularResult.thumb = [self parseImage:[dresult objectForKey:@"poster_path"] type:apiTMDbPosterThumb];
                popularResult.sort = [NSNumber numberWithInt:sort];
                
                // add
                count++;
                sort++;
                [popular addResultsObject:popularResult];
            }
        }
        
        // total
        popular.total = [self parseNumber:[djson objectForKey:@"total_results"]];
        
    }
    
    // count
    popular.count = [NSNumber numberWithInt:[popular.count intValue] +count ];
    
    // page
    popular.page = [NSNumber numberWithInt:[popular.page intValue] + 1];
    
    
    // save
    if (! [managedObjectContext save:&error]) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // null
        return NULL;
        
    }
    
    // you are so popular
    return popular;
    
}


/*
 * Query now playing.
 */
- (NowPlaying*)queryNowPlaying:(NSString *)ident retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryNowPlaying"];
    
    // now playing data
    NowPlaying *nowplaying = [self cachedNowPlaying:ident type:typeMovie];
    if (nowplaying == NULL) {
        
        // create
        nowplaying = (NowPlaying*)[NSEntityDescription insertNewObjectForEntityForName:@"NowPlaying" inManagedObjectContext:managedObjectContext];
        nowplaying.type = typeMovie;
        nowplaying.ident = ident;
        nowplaying.page = [NSNumber numberWithInt:0];
        nowplaying.count = [NSNumber numberWithInt:0];
        nowplaying.total = [NSNumber numberWithInt:0];
    }
    
    
    // queue time
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
    // request
    NSString *url = [NSString stringWithFormat:@"%@?api_key=%@&page=%i",apiTMDbNowPlaying,apiTMDbKey,[nowplaying.page intValue]+1];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeout];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
    // connection
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    // connection error
    if (error) {
        
        // rollback
        [managedObjectContext rollback];
        
        // delegate
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            
            // error
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
    
    // invalid response 
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid now playing query: %@", ident);
        NSLog(@"%@",json);
        #endif
        
        // back
        [managedObjectContext rollback];
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryNowPlaying:ident retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable")
                                                      message:NSLocalizedString(@"Could not load movies. \nPlease try again later.", @"Could not load movies. \nPlease try again later.")] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nuff
        return NULL;
        
    }
    
    
    
    // parse result
    int count = 0;
    int sort = [nowplaying.count intValue];
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *djson = [parser objectWithString:json error:nil];
        [parser release];
        
        // results
        NSArray *results = [djson objectForKey:@"results"];
        for (NSDictionary *dresult in results)	{
            
            // result data
            NowPlayingResult *nowPlayingResult = (NowPlayingResult*)[NSEntityDescription insertNewObjectForEntityForName:@"NowPlayingResult" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validNowPlaying:dresult]) {
                
                // dta
                NSString *dta = [self parseString:[dresult objectForKey:@"original_title"]];
                if (! [self isEmpty:[dresult objectForKey:@"release_date"]]) {
                    dta = [NSString stringWithFormat:@"%@ (%@)",dta,[self parseYear:[dresult objectForKey:@"release_date"]]];
                }
                
                // data
                nowPlayingResult.type = typeMovie;
                nowPlayingResult.ref = [self parseNumber:[dresult objectForKey:@"id"]];
                nowPlayingResult.data = dta;
                nowPlayingResult.thumb = [self parseImage:[dresult objectForKey:@"poster_path"] type:apiTMDbPosterThumb];
                nowPlayingResult.sort = [NSNumber numberWithInt:sort];
                
                // add
                count++;
                sort++;
                [nowplaying addResultsObject:nowPlayingResult];
            }
        }
        
        // total
        nowplaying.total = [self parseNumber:[djson objectForKey:@"total_results"]];
        
    }
    
    // count
    nowplaying.count = [NSNumber numberWithInt:[nowplaying.count intValue] +count ];
    
    // page
    nowplaying.page = [NSNumber numberWithInt:[nowplaying.page intValue] + 1];
    
    
    // save
    if (! [managedObjectContext save:&error]) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // null
        return NULL;
        
    }
    
    // play it again, sam
    return nowplaying;
}



/*
 * Query movie.
 */
- (Movie*)queryMovie:(NSNumber*)mid retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryMovie"];
    
    // play nice with tmdb...
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i?api_key=%@",apiTMDbMovie,[mid intValue],apiTMDbKey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeout];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
	
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
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
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
    NSDictionary *djson = [parser objectWithString:json error:nil];
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
        movie.title = [self parseString:[djson objectForKey:@"original_title"]];
        movie.released = [self parseDate:[djson objectForKey:@"release_date"]];
        movie.tagline = [self parseString:[djson objectForKey:@"tagline"]];
        movie.overview = [self parseString:[djson objectForKey:@"overview"]];
        movie.runtime = [self parseNumber:[djson objectForKey:@"runtime"]];
        movie.homepage = [self parseString:[djson objectForKey:@"homepage"]];
        movie.imdb = [self parseString:[djson objectForKey:@"imdb_id"]];
        
        // nfo
        #ifdef DEBUG
        NSLog(@"%@",movie.title);
        #endif
        
        
        // poster thumb
        Asset *poster_thumb = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        poster_thumb.name = movie.title;
        poster_thumb.type = assetPoster;
        poster_thumb.size = assetSizeThumb;
        poster_thumb.value = [self parseImage:[djson objectForKey:@"poster_path"] type:apiTMDbPosterThumb];
        poster_thumb.sort = [NSNumber numberWithInt:-1];
        poster_thumb.movie = movie;
        [movie addAssetsObject:poster_thumb];
        
        // poster mid
        Asset *poster_mid = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        poster_mid.name = movie.title;
        poster_mid.type = assetPoster;
        poster_mid.size = assetSizeMid;
        poster_mid.value = [self parseImage:[djson objectForKey:@"poster_path"] type:apiTMDbPosterMid];
        poster_mid.sort = [NSNumber numberWithInt:-1];
        poster_mid.movie = movie;
        [movie addAssetsObject:poster_mid];
        
        // poster original
        Asset *poster_original = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        poster_original.name = movie.title;
        poster_original.type = assetPoster;
        poster_original.size = assetSizeOriginal;
        poster_original.value = [self parseImage:[djson objectForKey:@"poster_path"] type:apiTMDbPosterOriginal];
        poster_original.sort = [NSNumber numberWithInt:-1];
        poster_original.movie = movie;
        [movie addAssetsObject:poster_original];
        
        
        // genres
        NSArray *genres = [djson objectForKey:@"genres"];
        for (NSDictionary *dgenre in genres) {
            
            // genre
            NSNumber *gid = [self parseNumber:[dgenre objectForKey:@"id"]];
            NSString *gname = [self parseString:[dgenre objectForKey:@"name"]];
            #ifdef DEBUG
            NSLog(@"Genre: gid = %i name = %@",[gid intValue],gname);
            #endif
            
            // cached
            Genre *genre = [self cachedGenre:gid];
            if (genre == NULL) {
                
                // init
                genre = (Genre*)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:managedObjectContext];
                genre.gid = gid;
                genre.name = gname;
            }
            
            // relation
            [genre addMoviesObject:movie];
            [movie addGenresObject:genre];
            
        }
        
        // category
        movie.category = [self updateCategory:movie.genres];
        
        
        // casts
        movie = [self queryMovieCasts:movie retry:YES];
    }
    
    // not good
    if (movie == NULL) {
        
        // rollin back
        [managedObjectContext rollback];
        
        // too bad
        return NULL;
    }
    
    // loaded
    movie.loaded = [NSNumber numberWithBool:YES];
    movie.details = [NSNumber numberWithBool:NO];
    movie.related = [NSNumber numberWithBool:NO];
    movie.timestamp = [NSDate date];
    
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
 * Query movie casts.
 */
- (Movie*)queryMovieCasts:(Movie*)movie retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryMovieCasts"];
    
    // play nice with tmdb...
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i%@?api_key=%@",apiTMDbMovie,[movie.mid intValue],apiTMDbMovieCast,apiTMDbKey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeoutQuery];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
	
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
            [apiError setDataId:movie.mid];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // fluff back
        return NULL;
    }
    
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    // invalid response
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid response %i",[movie.mid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryMovieCasts:movie retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable") 
                                                      message:NSLocalizedString(@"Could not load movie. \nPlease try again later.", @"Could not load movie. \nPlease try again later.")] autorelease];
            [apiError setDataId:movie.mid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    // parse result
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *djson = [parser objectWithString:json error:nil];
    [parser release];
    if (! [self validResult:json]) {
        #ifdef DEBUG
        NSLog(@"Movie casts not found %i",[movie.mid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service", @"TMDb Service") 
                                                      message:NSLocalizedString(@"Movie not found.", @"Movie not found.")] autorelease];
            [apiError setDataId:movie.mid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }
    
    
    // persons
    int counter_cast = 0;
    int counter_crew = 0;
    NSMutableDictionary *parsedPersons = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *parsedMovie2Persons = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 2; i++) {
        
        // persons
        NSArray *persons = (i == 0) ? [djson objectForKey:@"cast"] : [djson objectForKey:@"crew"];
        NSString *ptype = [NSString stringWithString:(i == 0) ? @"cast" : @"crew" ];
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
                    Asset *profile = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                    profile.name = person.name;
                    profile.type = assetProfile;
                    profile.size = assetSizeThumb;
                    profile.value = [self parseImage:[dperson objectForKey:@"profile_path"] type:apiTMDbProfileThumb];
                    profile.sort = [NSNumber numberWithInt:-1];
                    profile.person = person;
                    [person addAssetsObject:profile];
                    
                    // defaults
                    person.loaded = NO;
                    
                }
                
                // Movie2Person
                Movie2Person *m2p = [parsedMovie2Persons objectForKey:pid];
                if (m2p == NULL) {
                    m2p = [self cachedMovie2Person:movie.mid person:pid];
                }
                if (m2p == NULL) {
                    
                    // create object
                    m2p = (Movie2Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie2Person" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    m2p.mid = movie.mid;
                    m2p.pid = pid;
                    m2p.year = movie.released;
                    
                    // reference
                    m2p.movie = movie;
                    m2p.person = person;
                    
                    // init
                    m2p.type = typePerson;
                    m2p.department = @"";
                    m2p.job = @"";
                    m2p.character = @"";
                    m2p.order = [NSNumber numberWithInt:10000];
                    
                }
                
                // update cast
                if ([ptype isEqualToString:@"cast"]) {
                    counter_cast++;
                    
                    // update data
                    m2p.type = [self updateType:m2p.type updated:typePersonActor];
                    m2p.character = [self updateCharacter:m2p.character updated:[self parseString:[dperson objectForKey:@"character"]]];
                    m2p.order = [self updateOrder:m2p.order updated:[self parseNumber:[dperson objectForKey:@"order"]]]; 
                    
                    // type
                    if (! person.loaded) {
                        person.type = [self updateType:person.type updated:typePersonActor];
                    }
                }
                // update crew
                else {
                    counter_crew++;
                    
                    // update data
                    m2p.type = [self updateType:m2p.type updated:[self parseString:[dperson objectForKey:@"department"]]];
                    m2p.department = [self updateDepartment:m2p.department updated:[self parseString:[dperson objectForKey:@"department"]]];
                    m2p.job = [self updateJob:m2p.job updated:[self parseString:[dperson objectForKey:@"job"]]];
                    m2p.order = [self updateOrder:m2p.order updated:[NSNumber numberWithInt:counter_cast+counter_crew]];
                    if ([m2p.type isEqualToString:typePersonDirector]) {
                        m2p.order = [NSNumber numberWithInt:-1];
                    }
                    
                    // type
                    if (! person.loaded) {
                        person.type = [self updateType:person.type updated:m2p.department];
                    }
                }
                
                
                // add
                [movie addPersonsObject:m2p];
                [parsedPersons setObject:person forKey:pid];
                [parsedMovie2Persons setObject:m2p forKey:pid];
                
            }
            
        }
        
        
    }
    
    // release
    [parsedPersons release];
    [parsedMovie2Persons release];
    
    
    // back
    return movie;
}


/*
 * Query movie details.
 */
- (Movie*)queryMovieDetails:(Movie *)movie retry:(BOOL)retry{
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryMovieDetails"];
    
    // errors
    NSError *error = nil;
    
    // images
    Movie *mimages = [self queryMovieImages:movie retry:retry];
    if (mimages == NULL) {
        
        // ignore movie images
        FLog("Ignoring movie images.");
        
        // restore
        [managedObjectContext rollback];
    }
    else {
        
        // assign
        movie = mimages;
        movie.details = [NSNumber numberWithBool:YES];
        
        // save
        [managedObjectContext save:&error];
    }
    
    // wait a bit
    [NSThread sleepForTimeInterval:kTMDbTimeQueueDetail];
    
    // trailers
    Movie *mtrailers = [self queryMovieTrailers:movie retry:retry];
    if (mtrailers == NULL) {
        
        // ignore movie images
        FLog("Ignoring movie trailers.");
        
        // restore
        [managedObjectContext rollback];
    }
    else {
        
        // assign
        movie = mtrailers;
        movie.details = [NSNumber numberWithBool:YES];
        
        // save
        [managedObjectContext save:&error];
        
    }
    
    // handle the error
    if (error) {
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
    }
    
    // always return movie
    return movie;
}


/*
 * Query movie images.
 */
- (Movie*)queryMovieImages:(Movie*)movie retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryMovieImages"];
    
    // sending
    FLog("Send request...");
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i%@?api_key=%@",apiTMDbMovie,[movie.mid intValue],apiTMDbMovieImages,apiTMDbKey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeoutDetail];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
	
    // connection
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];  
    
    
    // error / invalid response
    if (error || ! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid response %i",[movie.mid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // nothing
        return NULL;
    }
    
    
    // parse
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *djson = [parser objectWithString:json error:nil];
    [parser release];
    
    
    // backdrops
    int bdcount = 0;
    NSArray *backdrops = [djson objectForKey:@"backdrops"];
    for (NSDictionary *dbackdrop in backdrops)	{
        
        // backdrop mid
        Asset *backdrop_mid = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        backdrop_mid.name = movie.title;
        backdrop_mid.type = assetBackdrop;
        backdrop_mid.size = assetSizeMid;
        backdrop_mid.value = [self parseImage:[dbackdrop objectForKey:@"file_path"] type:apiTMDbBackdropMid];
        backdrop_mid.sort = [NSNumber numberWithInt:bdcount++];
        backdrop_mid.movie = movie;
        [movie addAssetsObject:backdrop_mid];
        
        // backdrop med
        Asset *backdrop_med = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        backdrop_med.name = movie.title;
        backdrop_med.type = assetBackdrop;
        backdrop_med.size = assetSizeMed;
        backdrop_med.value = [self parseImage:[dbackdrop objectForKey:@"file_path"] type:apiTMDbBackdropMed];
        backdrop_med.sort = [NSNumber numberWithInt:bdcount++];
        backdrop_med.movie = movie;
        [movie addAssetsObject:backdrop_med];
        
        // backdrop original
        Asset *backdrop_original = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        backdrop_original.name = movie.title;
        backdrop_original.type = assetBackdrop;
        backdrop_original.size = assetSizeOriginal;
        backdrop_original.value = [self parseImage:[dbackdrop objectForKey:@"file_path"] type:apiTMDbBackdropOriginal];
        backdrop_original.sort = [NSNumber numberWithInt:bdcount++];
        backdrop_original.movie = movie;
        [movie addAssetsObject:backdrop_original];
    }
    
    // return
    return movie;
}

/*
 * Query movie trailers.
 */
- (Movie*)queryMovieTrailers:(Movie *)movie retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryMovieTrailers"];
    
    // sending
    FLog("Send request...");
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i%@?api_key=%@",apiTMDbMovie,[movie.mid intValue],apiTMDbMovieTrailer,apiTMDbKey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeoutDetail];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
	
    // connection
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];  
    
    
    // error / invalid response
    if (error || ! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid response %i",[movie.mid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // nothing
        return NULL;
    }
    
    
    // parse
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *djson = [parser objectWithString:json error:nil];
    [parser release];
    
    // youtube
    int tcount = 0;
    NSArray *youtubes = [djson objectForKey:@"youtube"];
    for (NSDictionary *dyoutube in youtubes) {
        
        // backdrop med
        Asset *trailer = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        trailer.name = [self parseString:[dyoutube objectForKey:@"name"]];
        trailer.type = assetTrailer;
        trailer.size = [self parseString:[dyoutube objectForKey:@"size"]];;
        trailer.value = [self parseString:[dyoutube objectForKey:@"source"]];
        trailer.sort = [NSNumber numberWithInt:tcount++];
        trailer.movie = movie;
        [movie addAssetsObject:trailer];

    }
    
    // back
    return movie;
    
}


/*
 * Query movie related.
 */
- (Movie*)queryMovieRelated:(Movie*)movie retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryMovieRelated"];
    
    // similar
    Similar *similar = movie.similar;
    if (similar == NULL) {
        
        // create
        similar = (Similar*)[NSEntityDescription insertNewObjectForEntityForName:@"Similar" inManagedObjectContext:managedObjectContext];
        similar.page = [NSNumber numberWithInt:0];
        similar.count = [NSNumber numberWithInt:0];
        similar.total = [NSNumber numberWithInt:0];
        
        similar.movie = movie;
        movie.similar = similar;
    }
    
    // sending
    FLog("Send request...");
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i%@?api_key=%@&page=%i",apiTMDbMovie,[movie.mid intValue],apiTMDbMovieRelated,apiTMDbKey,[similar.page intValue]+1];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeoutQuery];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
	
    // connection
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    FLog("received data.");
    
    
    // connection error
    if (error) {
        
        // rollback
        [managedObjectContext rollback];
        
        // delegate
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            
            // error
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Connection Error", @"Connection Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // today is not my day
        return movie;
    }
    
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];  
    
    // invalid response 
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid related query: %@", movie.title);
        NSLog(@"%@",json);
        #endif
        
        // back
        [managedObjectContext rollback];
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryMovieRelated:movie retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable")
                                                      message:NSLocalizedString(@"Could not load movies. \nPlease try again later.", @"Could not load movies. \nPlease try again later.")] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // well then
        return movie;
    }
    
    
    // parse result
    int count = 0;
    int sort = [similar.count intValue];
    if ([self validResult:json]) {
        
        // parse
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *djson = [parser objectWithString:json error:nil];
        [parser release];
        
        // results
        NSArray *results = [djson objectForKey:@"results"];
        for (NSDictionary *dresult in results)	{
            
            // similar data
            SimilarMovie *similarMovie = (SimilarMovie*)[NSEntityDescription insertNewObjectForEntityForName:@"SimilarMovie" inManagedObjectContext:managedObjectContext];
            
            // validate
            if ([self validSimilar:dresult]) {
                
                // dta
                NSString *title = [self parseString:[dresult objectForKey:@"original_title"]];
                if (! [self isEmpty:[dresult objectForKey:@"release_date"]]) {
                    title = [NSString stringWithFormat:@"%@ (%@)",title,[self parseYear:[dresult objectForKey:@"release_date"]]];
                }
                
                // data
                similarMovie.mid = [self parseNumber:[dresult objectForKey:@"id"]];
                similarMovie.title = title;
                similarMovie.thumb = [self parseImage:[dresult objectForKey:@"poster_path"] type:apiTMDbPosterThumb];
                similarMovie.sort = [NSNumber numberWithInt:sort];
                
                // add
                count++;
                sort++;
                [similar addMoviesObject:similarMovie];
            }
        }
        
        // total
        similar.total = [self parseNumber:[djson objectForKey:@"total_results"]];
        
    }
    
    // related
    movie.related = [NSNumber numberWithBool:YES];
    
    // count
    similar.count = [NSNumber numberWithInt:[similar.count intValue] + count];
    
    // page
    similar.page = [NSNumber numberWithInt:[similar.page intValue] + 1];
    
    
    // save
    if (! [managedObjectContext save:&error]) {
        
        // error
        if (delegate && [delegate respondsToSelector:@selector(apiError:)]) {
            APIError *apiError = [[[APIError alloc] initError:typeMovie 
                                                        title:NSLocalizedString(@"Data Error", @"Data Error") 
                                                      message:[error localizedDescription]] autorelease];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // handle the error
        NSLog(@"TMDb CoreData Error\n%@\n%@", error, [error userInfo]);
        [managedObjectContext rollback];
        
        // back
        return movie;
        
    }
    
   
    
    // return
    return movie;
}




/*
 * Query person.
 */
- (Person*)queryPerson:(NSNumber*)pid retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryPerson"];
    
    // play nice with tmdb...
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i?api_key=%@",apiTMDbPerson,[pid intValue],apiTMDbKey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeout];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
	
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
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];  
    
    
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
    NSDictionary *djson = [parser objectWithString:json error:nil];
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
        person.deathday = [self parseDate:[djson objectForKey:@"deathday"]];
        person.birthplace = [self parseString:[djson objectForKey:@"place_of_birth"]];
         
        
        // profile thumb
        Asset *profile_thumb = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        profile_thumb.name = person.name;
        profile_thumb.type = assetProfile;
        profile_thumb.size = assetSizeThumb;
        profile_thumb.value = [self parseImage:[djson objectForKey:@"profile_path"] type:apiTMDbProfileThumb];
        profile_thumb.sort = [NSNumber numberWithInt:-1];
        profile_thumb.person = person;
        [person addAssetsObject:profile_thumb];
        
        
        // profile mid
        Asset *profile_mid = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        profile_mid.name = person.name;
        profile_mid.type = assetProfile;
        profile_mid.size = assetSizeMid;
        profile_mid.value = [self parseImage:[djson objectForKey:@"profile_path"] type:apiTMDbProfileMid];
        profile_mid.sort = [NSNumber numberWithInt:-1];
        profile_mid.person = person;
        [person addAssetsObject:profile_mid];
        
        
        // profile original
        Asset *profile_original = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
        profile_original.name = person.name;
        profile_original.type = assetProfile;
        profile_original.size = assetSizeOriginal;
        profile_original.value = [self parseImage:[djson objectForKey:@"profile_path"] type:apiTMDbProfileOriginal];
        profile_original.sort = [NSNumber numberWithInt:-1];
        profile_original.person = person;
        [person addAssetsObject:profile_original];
        
        // credits
        person = [self queryPersonCredits:person retry:YES];
       
    }
    
    // oops
    if (person == NULL) {
        
        // rollin back
        [managedObjectContext rollback];
        
        // too bad
        return NULL;
    }
        
    // loaded
    person.loaded = [NSNumber numberWithBool:YES];
    person.timestamp = [NSDate date];
    
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



/*
 * Query person credits.
 */
- (Person*)queryPersonCredits:(Person*)person retry:(BOOL)retry {
    FLog();
    
    // track
    [Tracker trackEvent:TEventAPI action:@"Query" label:@"queryPersonCredits"];
    
    
    // play nice with tmdb...
    [NSThread sleepForTimeInterval:kTMDbTimeQueueBase+((rand() / RAND_MAX) * kTMDbTimeQueueRandom)];
    FLog("Send request...");
    
	
    // request
    NSString *url = [NSString stringWithFormat:@"%@%i%@?api_key=%@",apiTMDbPerson,[person.pid intValue],apiTMDbPersonCredits,apiTMDbKey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:kTMDbTimeoutQuery];
    
    // response
    NSError *error = nil;
    NSURLResponse *response = nil;
    #ifdef DEBUG    
    NSLog(@"%@",url);
    #endif
    
	
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
            [apiError setDataId:person.pid];
            [delegate performSelectorOnMainThread:@selector(apiError:) withObject:apiError waitUntilDone:NO];
        }
        
        // fluff back
        return NULL;
    }
    
    
    // json
    NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];  
    
    
    // invalid response
    if (! [self validResponse:json]) {
        #ifdef DEBUG
        NSLog(@"Invalid response %i",[person.pid intValue]);
        NSLog(@"%@",json);
        #endif
        
        // retry
        if (retry) {
            FLog("Wait...");
            [NSThread sleepForTimeInterval:kTMDbTimeRetryBase+((rand() / RAND_MAX) * kTMDbTimeRetryRandom)];
            FLog("... and try again.");
            return [self queryPersonCredits:person retry:NO];
        }
        
        // note
        if (delegate && [delegate respondsToSelector:@selector(apiGlitch:)]) {
            APIError *apiError = [[[APIError alloc] initError:typePerson 
                                                        title:NSLocalizedString(@"TMDb Service Unavailable", @"TMDb Service Unavailable") 
                                                      message:NSLocalizedString(@"Could not load person. \nPlease try again later.", @"Could not load person. \nPlease try again later.")] autorelease];
            [apiError setDataId:person.pid];
            [delegate performSelectorOnMainThread:@selector(apiGlitch:) withObject:apiError waitUntilDone:NO];
        }
        
        // nothing
        return NULL;
    }

    
    // parse
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *djson = [parser objectWithString:json error:nil];
    [parser release];
    
    
    // estimate if director, crew or actor...
    int count = 0;
    int dcount = 0;
    int ccount = 0;
    int acount = 0;
    
    // movies
    NSMutableDictionary *parsedMovies = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *parsedMovie2Persons = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 2; i++) {
        
        // persons
        NSArray *movies = (i == 0) ? [djson objectForKey:@"cast"] : [djson objectForKey:@"crew"];
        NSString *mtype = [NSString stringWithString:(i == 0) ? @"cast" : @"crew" ];
        for (NSDictionary *dmovie in movies)	{
            
            // validate
            if ([self validMovie:dmovie]) {
                count++;
                
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
                    movie.title = [self parseString:[dmovie objectForKey:@"original_title"]];
                    movie.released = [self parseDate:[dmovie objectForKey:@"release_date"]];
                    
                    // poster
                    Asset *poster = (Asset*)[NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:managedObjectContext];
                    poster.name = movie.title;
                    poster.type = assetPoster;
                    poster.size = assetSizeThumb;
                    poster.value = [self parseImage:[dmovie objectForKey:@"poster_path"] type:apiTMDbPosterThumb];
                    poster.sort = [NSNumber numberWithInt:-1];
                    poster.movie = movie;
                    [movie addAssetsObject:poster];
                    
                    // defaults
                    movie.loaded = [NSNumber numberWithBool:NO];
                    movie.details = [NSNumber numberWithBool:NO];
                    movie.related = [NSNumber numberWithBool:NO];
                }
                
                // Movie2Person
                Movie2Person *m2p = [parsedMovie2Persons objectForKey:mid];
                if (m2p == NULL) {
                    m2p = [self cachedMovie2Person:mid person:person.pid];
                }
                if (m2p == NULL) {
                    
                    // create object
                    m2p = (Movie2Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Movie2Person" inManagedObjectContext:managedObjectContext];
                    
                    // set data
                    m2p.mid = mid;
                    m2p.pid = person.pid;
                    
                    // reference
                    m2p.movie = movie;
                    m2p.person = person;
                    
                    // init
                    m2p.year = movie.released;
                    m2p.type = typePerson;
                    m2p.department = @"";
                    m2p.job = @"";
                    m2p.character = @"";
                    m2p.order = [NSNumber numberWithInt:10000];
                }
                
                // update cast
                if ([mtype isEqualToString:@"cast"]) {
                    
                    // update data
                    m2p.type = [self updateType:m2p.type updated:typePersonActor];
                    m2p.character = [self updateCharacter:m2p.character updated:[self parseString:[dmovie objectForKey:@"character"]]];
                    
                }
                // update crew
                else {
                    
                    // update data
                    m2p.type = [self updateType:m2p.type updated:[self parseString:[dmovie objectForKey:@"department"]]];
                    m2p.department = [self updateDepartment:m2p.department updated:[self parseString:[dmovie objectForKey:@"department"]]];
                    m2p.job = [self updateJob:m2p.job updated:[self parseString:[dmovie objectForKey:@"job"]]];
                    if ([m2p.type isEqualToString:typePersonDirector]) {
                        m2p.order = [NSNumber numberWithInt:-1];
                    }
                    
                }
                
                
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
    if ((dcount > acount && dcount > ccount) || dcount > 10) {
        person.type = typePersonDirector;
    }
    
    // count casts
    person.casts = [NSNumber numberWithInt:count];
    
    
    // finally
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
- (NSString*)parseImage:(NSObject *)token type:(NSString*)type {
    
    // img
    if ([self isEmpty:token]) {
        return @"";
    }
    
    // format
    NSString *img = (NSString*)token;
    return [NSString stringWithFormat:@"%@%@%@",apiTMDbBaseURL,type,img];

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
    if ([original rangeOfString:updated].location == NSNotFound) {
        
        // append
        return [NSString stringWithFormat:@"%@, %@",original,updated];
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
    if ([original rangeOfString:updated].location == NSNotFound) {
        
        // append
        return [NSString stringWithFormat:@"%@, %@",original,updated];
    }
    
    // original
    return original;
}
- (NSString*)updateJob:(NSString *)original updated:(NSString *)updated {
    
    // initial
    if ([self isEmpty:original]) {
        return updated;
    }
    
    // update
    if ([original rangeOfString:updated].location == NSNotFound) {
        
        // append
        return [NSString stringWithFormat:@"%@, %@",original,updated];
    }
    
    // original
    return original;
}
- (NSNumber*)updateOrder:(NSNumber *)original updated:(NSNumber *)updated {
    
    // initial
    if ([self isEmpty:original] || [updated intValue] < [original intValue]) {
        return updated;
    }
    
    // keep original 
    return original;

}
- (NSString*)updateType:(NSString *)original updated:(NSString *)updated {
    
    // director
    if ([updated rangeOfString:@"Directing"].location != NSNotFound || ([original rangeOfString:typePersonDirector].location != NSNotFound)) {
        return typePersonDirector;
    }
    // actor
    else if ([updated isEqualToString:typePersonActor] || ([original rangeOfString:typePersonActor].location != NSNotFound)) {
        return typePersonActor;
    }
    // crew
    else {
        return typePersonCrew;
    }
    
}

/*
 * Updates the category.
 */
- (NSString*)updateCategory:(NSSet *)genres {

    // default
    if ([genres count] <= 0) {
        return catEntertainment;
    }
    
    // counter
    int counter_entertainment = 0;
    int counter_violence = 0;
    int counter_creativity = 0;
    int counter_passion = 0;
    int counter_happiness = 0;
    int counter_natural = 0;
    
    // parse
    for (Genre *genre in genres) {
        
        // count
        switch ([genre.gid intValue]) {
                
            // Action
            case 28:
                counter_entertainment += 1;
                break;
            
            // Action & Adventure
            case 10759:
                counter_entertainment += 1;
                break;
                
            // Adventure
            case 12:
                counter_entertainment += 1;
                break;
                
            // Animation
            case 16:
                counter_creativity += 1;
                break;
                
            // British
            case 10760:
                break;
                
            // Comedy
            case 35:
                counter_happiness += 1;
                break;
                
            // Crime
            case 80:
                counter_violence += 1;
                break;
                
            // Disaster
            case 105:
                counter_entertainment += 1;
                break;
                
            // Documentary
            case 99:
                counter_creativity += 1;
                break;
                
            // Drama
            case 18:
                counter_entertainment += 1;
                break;
                
            // Eastern
            case 82:
                counter_violence += 1;
                break;
                
            // Education
            case 10761:
                counter_natural += 1;
                break;
                
            // Erotic
            case 2916:
                counter_passion += 1;
                break;
                
            // Family
            case 10751:
                counter_natural += 1;
                break;
                
            // Fan Film
            case 10750:
                break;
                
            // Fantasy
            case 14:
                counter_happiness += 1;
                break;
                
            // Film Noir
            case 10753:
                counter_creativity += 1;
                break;
                
            // Foreign
            case 10769:
                counter_creativity += 1;
                break;
                
            // History
            case 36:
                break;
                
            // Holiday
            case 10595:
                counter_happiness += 1;
                break;
                
            // Horror
            case 27:
                counter_violence += 2;
                break;
                
            // Indie
            case 10756:
                counter_creativity += 1;
                break;
            
            // Kids
            case 10762:
                counter_happiness += 1;
                break;
            
            // Music
            case 10402:
                counter_creativity += 1;
                break;
                
            // Musical
            case 22:
                counter_natural += 1;
                break;
                
            // Mystery
            case 9648:
                counter_creativity += 1;
                break;
                
            // Neo-noir
            case 10754:
                counter_creativity += 1;
                break;
                
            // News
            case 10763:
                counter_natural += 1;
                break;
                
            // Reality
            case 10764:
                counter_natural += 1;
                break;
                
            // Road Movie
            case 1115:
                counter_creativity += 1;
                break;
                
            // Romance
            case 10749:
                counter_passion += 1;
                break;
                
            // Sci-Fi & Fantasy
            case 10765:
                counter_creativity += 1;
                break;
                
            // Science Fiction
            case 878:
                counter_creativity += 1;
                break;
                
            // Short
            case 10755:
                break;
                
            // Soap
            case 10766:
                counter_happiness += 1;
                break;
                
            // Sport
            case 9805:
                counter_entertainment += 1;
                break;
                
            // Sporting Event
            case 10758:
                counter_natural += 1;
                break;
                
            // Sports Film
            case 10757:
                counter_entertainment += 1;
                break;
                
            // Suspense
            case 10748:
                counter_creativity += 1;
                break;
                
            // TV movie
            case 10770:
                break;
                
            // Talk
            case 10767:
                counter_natural += 1;
                break;
                
            // Thriller
            case 53:
                counter_entertainment += 1;
                break;
                
            // War
            case 10752:
                counter_violence += 2;
                break;
                
            // War & Politics
            case 10768:
                counter_violence += 2;
                break;
                
            // Western
            case 37:
                counter_violence += 1;
                break;
            
            // nope
            default:
                break;
        }
    }
    
    
    // determine
    #ifdef DEBUG    
    NSLog(@"counter_entertainment = %i, counter_violence = %i, counter_creativity = %i, counter_passion = %i, counter_happiness = %i, counter_natural = %i",counter_entertainment,counter_violence,counter_creativity,counter_passion,counter_happiness,counter_natural);
    #endif
    
    
    // categories
    [[[DataCounter alloc] initCounter:catEntertainment count:counter_entertainment sort:1] autorelease];
    NSMutableArray *categories = [NSMutableArray arrayWithObjects:[[[DataCounter alloc] initCounter:catEntertainment count:counter_entertainment sort:6] autorelease],
                                                         [[[DataCounter alloc] initCounter:catViolence count:counter_violence sort:5] autorelease],
                                                         [[[DataCounter alloc] initCounter:catCreativity count:counter_creativity sort:2] autorelease],
                                                         [[[DataCounter alloc] initCounter:catPassion count:counter_passion sort:3] autorelease],
                                                         [[[DataCounter alloc] initCounter:catHappiness count:counter_happiness sort:4] autorelease],
                                                         [[[DataCounter alloc] initCounter:catNatural count:counter_natural sort:1] autorelease], 
                                                         nil];
    
    // sort
    NSSortDescriptor *sort_counter = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSSortDescriptor *sort_sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
	[categories sortUsingDescriptors:[NSArray arrayWithObjects:sort_counter, sort_sorter, nil]];
	[sort_counter release];
    [sort_sorter release];
    
    // counter
    DataCounter *cat = (DataCounter*) [categories objectAtIndex:0];
    #ifdef DEBUG    
    NSLog(@"category = %@",cat.name);
    #endif
    
    
    // return
    return cat.name;
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
    if (dresult == NULL 
        || [[dresult objectForKey:@"adult"] boolValue]) {
        return NO;
    }
    
    // valid
    return YES;
}

/*
 * Validate PopularResult.
 */
- (BOOL)validPopular:(NSDictionary *)dresult {
    
    // exclude adult
    if (dresult == NULL 
        || [[dresult objectForKey:@"adult"] boolValue]) {
        return NO;
    }
    
    // valid
    return YES;
}

/*
 * Validate NowPlayingResult.
 */
- (BOOL)validNowPlaying:(NSDictionary *)dresult {
    
    // exclude adult
    if (dresult == NULL 
        || [[dresult objectForKey:@"adult"] boolValue]) {
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
    if (dmovie == NULL 
        || [[self parseNumber:[dmovie objectForKey:@"id"]] intValue] <= 0
        || [[dmovie objectForKey:@"adult"] boolValue]) {
        return NO;
    }
    
    
    // exclude by title
    NSString *name = [[self parseString:[dmovie objectForKey:@"original_title"]] lowercaseString];
    if ([name rangeOfString:@"obsolete"].location != NSNotFound) {
        return NO; 
    }
    
    // valid
    return YES;
}

/*
 * Validate Similar.
 */
- (BOOL)validSimilar:(NSDictionary *)dresult {
    
    // exclude 
    if (dresult == NULL || [[dresult objectForKey:@"adult"] boolValue]) {
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
    if (dperson == NULL 
        || [[self parseNumber:[dperson objectForKey:@"id"]] intValue] <= 0
        || [[dperson objectForKey:@"adult"] boolValue]) {
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
    if (response == nil 
        || [[response stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0 
        || [response length] <= 0) {
        
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
    if (result == nil 
        || [[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0 
        || [result rangeOfString : @"Nothing found."].location != NSNotFound) {
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
+ (NSString *)applicationCachesDirectory {
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
	NSString *storePath = [[TMDb applicationCachesDirectory] stringByAppendingPathComponent:kTMDbStore];
	
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
