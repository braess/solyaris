//
//  API_IMDB.h
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Search.h"


// alerts
enum {
    API_IMDB_AlertFatal,
	API_IMDB_AlertError
};


/*
 * Delegate.
 */
@protocol APIDelegate <NSObject>
- (void)searchResult:(Search*)result;
@end

/**
 * API IMDB.
 */
@interface API_IMDB : NSObject {
    
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



@end
