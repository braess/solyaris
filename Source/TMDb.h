//
//  TMDb.h
//  Solyaris
//
//  Created by CNPP on 26.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Search.h"
#import "SearchResult.h"
#import "Movie.h"
#import "Person.h"
#import "Movie2Person.h"
#import "Asset.h"


/**
 * APIError.
 */
@interface APIError : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSNumber *dataId;
@property (nonatomic, retain) NSString *dataType;
@property (nonatomic, retain) NSString *message;

// Object
- (id)initError:(NSNumber*)did type:(NSString*)dtype message:(NSString*)msg;

@end


/*
 * Delegate.
 */
@protocol APIDelegate <NSObject>
- (void)loadedSearch:(Search*)result;
- (void)loadedMovie:(Movie*)movie;
- (void)loadedPerson:(Person*)person;
- (void)apiInfo:(APIError*)error;
- (void)apiError:(APIError*)error;
- (void)apiFatal:(NSString*)msg;
@end

/**
 * API TMDb.
 */
@interface TMDb : NSObject {
    
    // delegate
	NSObject<APIDelegate> *delegate;
    
    // queue
    NSOperationQueue *queue;
    
    // core data
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
// Properties
@property (nonatomic, assign) NSObject <APIDelegate> *delegate;

// Business
- (void)reset;
- (void)search:(NSString*)q type:(NSString*)t;
- (void)movie:(NSNumber*)mid;
- (void)person:(NSNumber*)mid;
- (void)clearCache;
- (Movie*)dataMovie:(NSNumber*)mid;
- (Person*)dataPerson:(NSNumber*)pid;
- (NSArray*)dataMovies;


@end
