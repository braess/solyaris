//
//  TMDb.h
//  IMDG
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


// alerts
enum {
    TMDb_AlertFatal,
	TMDb_AlertError
};


/*
 * Delegate.
 */
@protocol APIDelegate <NSObject>
- (void)loadedSearch:(Search*)result;
- (void)loadedMovie:(Movie*)movie;
- (void)loadedPerson:(Person*)person;
- (void)quit;
@end

/**
 * API TMDb.
 */
@interface TMDb : NSObject <UIAlertViewDelegate> {
    
    // delegate
	id<APIDelegate>delegate;
    
    // queue
    NSOperationQueue *queue;
    
    // core data
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
// Properties
@property (assign) id<APIDelegate> delegate;

// Business
- (void)cancel;
- (void)search:(NSString*)q type:(NSString*)t;
- (void)movie:(NSNumber*)mid;
- (void)person:(NSNumber*)mid;
- (Movie*)dataMovie:(NSNumber*)mid;
- (Person*)dataPerson:(NSNumber*)pid;


@end
