//
//  IMDB.h
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Search.h"
#import "Movie.h"
#import "Actor.h"
#import "Director.h"


// alerts
enum {
    IMDB_AlertFatal,
	IMDB_AlertError
};


/*
 * Delegate.
 */
@protocol APIDelegate <NSObject>
- (void)searchResult:(Search*)result;
- (void)loadedMovie:(Movie*)movie;
- (void)loadedActor:(Actor*)movie;
- (void)loadedDirector:(Director*)movie;
@end

/**
 * API IMDB.
 */
@interface IMDB : NSObject <UIAlertViewDelegate> {
    
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
- (void)search:(NSString*)q type:(NSString*)t;
- (void)movie:(NSNumber*)mid;
- (void)actor:(NSNumber*)aid;
- (void)director:(NSNumber*)did;



@end
